//
//  ViewController.swift
//  OnTheMap
//
//  Created by Reem Saloom on 1/20/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
    }

    @IBAction func login(_ sender:AnyObject)
    {
        toggleForm(false)
        //after login fail
        toggleForm(true)
        
    }
    
    @IBAction func signUp(_ sender:AnyObject)
    {
        //open sign up form
    }
    
    private func toggleForm(_ enable: Bool) {
        email.isEnabled = enable
        password.isEnabled = enable
        loginBtn.isEnabled = enable
        signUpBtn.isEnabled = enable
        }
}

