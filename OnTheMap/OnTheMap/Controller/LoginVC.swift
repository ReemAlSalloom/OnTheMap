//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/10/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ToggleUI(true)
        emailText.delegate = self
        passwordText.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    
    private func ToggleUI(_ enable: Bool) {
        emailText.isEnabled = enable
        passwordText.isEnabled = enable
        loginBtn.isEnabled = enable
        signupBtn.isEnabled = enable
    }
    
 
    
    @IBAction func Signin(_ sender: UIButton) {
        
        let email = emailText.text
        let password = passwordText.text
        
        ToggleUI(false)
        
        if (email!.isEmpty) || (password!.isEmpty) {
            
            let Alert = UIAlertController (title: "Required fields", message: "Please fill both the email and password", preferredStyle: .alert)
            
            Alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                self.ToggleUI(true)
                return
            }))
            
            self.present (Alert, animated: true, completion: nil)
            ToggleUI(true)
        }
        else
        {
            API.login(email, password){(Message) in
                
                guard Message == nil else {
                    self.showAlert(title: "Error", message: Message!)
                     self.ToggleUI(true)
                    return
                    
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }
                
            }
        }
       
    }
    
    
    @IBAction func signup(_ sender: Any) {
        
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
       
}//end of class



