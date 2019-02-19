//
//  ViewController.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/10/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import UIKit

class Base: UIViewController {

    
    
    var locationData: LocationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadStudentLocations()
    }
    
    func setupUI()
    {
        let plusBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocation(_:)))
        let logoutBtn  =  UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        
        navigationItem.rightBarButtonItems = [plusBtn, refreshBtn]
        navigationItem.leftBarButtonItem = logoutBtn
    }
    
    @objc private  func addLocation(_ sender: Any){
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        
        present(navController, animated:  true, completion: nil)
    }
    @objc private func refreshLocation(_ sender: Any){
        loadStudentLocations()
    }
    @objc private func logout(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "", style: .default, handler: {(_) in
            API.deleteSession { (error) in
                guard error == nil else {
                    self.showAlert(title: "Error", message: error!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

    private func loadStudentLocations() {
        API.getStudentsLocations { (data) in
            guard let data = data else {
                self.showAlert(title: "Error", message: "No internet connection found")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(title: "Error", message: "No pins found")
                return
            }
            self.locationData = data
        }
    }
    
}

