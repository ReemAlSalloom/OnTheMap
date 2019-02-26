//
//  API.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/10/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation

class API {
    private  static var accountID: String?
    private  static var sessionID: String?
    private  static var errorMessage: String?
    
    private static var currentUser: StudentInformation?
    
    static func login(_ email : String!, _ password : String!, completion: @escaping (String?)->()) {
        guard let url = URL(string: Constants.SESSION) else {
            completion ( "invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion ( "fail")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode < 400 {
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dictionary = json as? [String: Any],
                        let sessionDictornary = dictionary["session"] as? [String: Any],
                        let accountDictionary = dictionary["account"] as? [String: Any] {
                        
//print("value of accountDictionary[account]:    \(accountDictionary["key"])")
                       
                        self.sessionID = sessionDictornary["id"] as? String
                        
                        self.accountID = accountDictionary["key"] as? String
                    } else {
                        errorMessage = "Could not parse data"
                    }
                }
                else{
                    errorMessage = "make sure you entered correct username and password "
                } }
            else {
                errorMessage = "no interenet connection"
            }
            DispatchQueue.main.async {
                completion(errorMessage)
            }
        }
        task.resume()
    }
    
    
    
    static func deleteSession (completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: Constants.Udacity.APIHost + Constants.Udacity.Authentication) else {
            completion ( "invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
            
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            print(String(data: newData!, encoding: .utf8) ?? "@ delete session")
            
            DispatchQueue.main.async {
                completion(nil)
            }
            }.resume()
    }
    
    
    
    static func getUserInformation(completion: @escaping (String?, String?) -> Void)
    {
        guard let UserID = self.accountID, let url = URL(string: "\(Constants.PUBLIC_USER)\(UserID)") else {
            completion(nil, nil)
            return
        }
        print("url: \(Constants.PUBLIC_USER)\(UserID)")
        var request = URLRequest(url: url)
        request.addValue(self.sessionID!, forHTTPHeaderField: "session_id")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var firstName: String?
            var lastName: String?
            //            var nickName: String = ""
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 400 {
                let Range = 5..<data!.count
                let newData = data?.subdata(in: Range)
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: [.allowFragments]),
                    let dictionary = json as? [String: Any]{
                    firstName =  dictionary["first_name"] as? String ?? ""
                    lastName = dictionary["last_name"] as? String ?? ""
                    
                    currentUser?.firstName = firstName
                    currentUser?.lastName = lastName
                    currentUser?.key = dictionary["key"] as! String
                    
                    print(dictionary)
                }
                
                   // let user = dictionary["user"] as? [String: Any],
//                    let guardDictionary = user["guard"] as? [String: Any] {
//                    //                    nickName = user["nickname"] as? String ?? ""
//
//                }
               
            }
            DispatchQueue.main.async {
                completion(firstName, lastName)
            }
        }
        task.resume()
        
    }
    
    
    static func getStudentsLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationData?)-> Void)
    {
        guard let url = URL(string: "\(Constants.Udacity.STUDENT_LOCATION)?limit=\(limit)&skip=\(skip)&order=\(orderBy)") else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(Constants.ParseValues.ApplicationID, forHTTPHeaderField: Constants.ParseKeys.ApplicationID)
        request.addValue(Constants.ParseValues.API_Key, forHTTPHeaderField: Constants.ParseKeys.API_Key)
        let session = URLSession.shared
        let task  = session.dataTask(with: request) {data, response, error in
            var studentLocations: [StudentLocation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if  statusCode < 400 {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dictionary = json as? [String: Any],
                        let results = dictionary["results"] as? [Any]
                    {
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                            studentLocations.append(studentLocation)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(LocationData(studentLocations: studentLocations))
            }
            
            }.resume()
        
        
    }//end of get location
    
    
    
    static func addLocation (completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        
        var request = URLRequest (url: URL (string: "")!)
        
        request.addValue(Constants.ParseValues.ApplicationID, forHTTPHeaderField: Constants.ParseKeys.ApplicationID) //"X-Parse-Application-Id"
        request.addValue(Constants.ParseValues.API_Key, forHTTPHeaderField: Constants.ParseKeys.API_Key) //"X-Parse-REST-API-Key"
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            }.resume()
    }
    
    static func postLocation (_ info: StudentLocation, completion: @escaping (String?)-> Void)
    {
      //  let url = URL(string: "\(Constants.Udacity.STUDENT_LOCATION)")
        guard let accountID = self.accountID, let url = URL(string: "\(Constants.Udacity.STUDENT_LOCATION)") else {
            completion("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.addValue(Constants.ParseValues.ApplicationID, forHTTPHeaderField: Constants.ParseKeys.ApplicationID)
        request.addValue(Constants.ParseValues.API_Key, forHTTPHeaderField: Constants.ParseKeys.API_Key)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        getUserInformation { _,_ in }
        
        let jsonBody = "{\"uniqueKey\": \"\(self.currentUser?.key)\", \"firstName\": \"\(String(describing: self.currentUser?.firstName))\", \"lastName\": \"\(self.currentUser?.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
      
        print("body: \(jsonBody)")
        
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if  statusCode  >= 400 {
                    errString = "Could not post your location"
                }
            }
            else
            {
                errString = "no internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
        }
        task.resume()
    }
  
    
}// end of class




