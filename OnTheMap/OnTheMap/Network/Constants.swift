//
//  Constant.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/10/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//


import Foundation

struct Constants {
    
    // MARK: - Commons
    
    //    struct HTTPHeaderField {
    //        static let accept = "Accept"
    //        static let contentType = "Content-Type"
    //    }
    
    //    struct HTTPHeaderFieldValue {
    //        static let json = "application/json"
    //    }
    
    // MARK: - Udacity API
    static let SESSION = "https://onthemap-api.udacity.com/v1/session"
    static let PUBLIC_USER = "https://onthemap-api.udacity.com/v1/users/"
    
    struct Udacity {
        static let MAIN = "https://parse.udacity.com"
        
        //        static let APIScheme = "https"
        //        static let APIPath = "/api"
        static let APIHost = "https://onthemap-api.udacity.com/v1"
        
        static let STUDENT_LOCATION = MAIN + "/parse/classes/StudentLocation"
        
        
        static let Authentication = "/session"
        static let Users = "/users/"
        //        static let SESSION = APIHost + "session"
        //        static let PUBLIC_USER = APIHost + "users/"
    }
    
    //    struct UdacityJSONResponseKeys {
    //        static let Account = "account"
    //        static let Registered = "registered"
    //        static let UserKey = "key"
    //        static let Session = "session"
    //        static let SessionID = "id"
    //    }
    
    // MARK: - Parse API
    
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse"
    }
    
    struct ParseMethods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
//    struct ParseJSONResponseKeys {
//        static let Results = "results"
//    }
    
    struct ParseKeys {
        static let API_Key = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        //static let Where = "where"
        //static let Order = "order"
    }
    
    struct ParseValues {
        static let API_Key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}




