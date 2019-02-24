//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/11/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationVC: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel(_:)))
        
        locationTextField.delegate = self
        mediaLinkTextField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    
    @IBAction func findLocation(_ sender: UIButton)
    {
        guard let location = locationTextField.text,
        let mediaLink = mediaLinkTextField.text,
        location != "", mediaLink != "" else {
            self.showAlert(title: "Missing Information", message: "Please make sure to fill both fields")
            return
        }
        
        var studentLocation = StudentLocation.init(createdAt: "",
                                                   firstName: nil,
                                                   lastName: nil,
                                                   latitude: 0,
                                                   longitude: 0,
                                                   mapString: location,
                                                   mediaURL: mediaLink,
                                                   objectId: "",
                                                   uniqueKey: "",
                                                   updatedAt: "")
  
        let geoDecoder = CLGeocoder()
        let ai = self.startAnActivityIndicator()
        geoDecoder.geocodeAddressString(studentLocation.mapString) { (placeMarks, _) in
            ai.stopAnimating()
            guard let marks = placeMarks else {
                self.showAlert(title: "Error", message: "could not find location")
                return
            }
            studentLocation.longitude = Float ((marks[0].location?.coordinate.longitude)!)
            //Float(((marks.first!.location?.coordinate.longitude)!))
            
            studentLocation.latitude = Float(((marks[0].location?.coordinate.latitude)!))
            
            self.performSegue(withIdentifier: "mapSegue", sender: studentLocation)

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //mapSegue
        if let vc = segue.destination as? ConfirmLocationVC, let location = sender as? StudentLocation {
            vc.location = location
        }
    }
    
    @objc private func cancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

