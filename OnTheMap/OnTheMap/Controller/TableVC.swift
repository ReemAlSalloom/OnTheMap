//
//  TableVC.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/10/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation

import UIKit

class TableVC: Base {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override var locationData: LocationData? {
        didSet {
            guard let locationData = locationData else {return }
            locations = locationData.studentLocations
        }
    }
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

extension TableVC: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        
        cell.configWith(locations[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  locationData?.didSelectLocation(info: locations[indexPath.row])
       
        let info : StudentLocation
        info = locations[indexPath.row]
        
        
        
        guard let url = URL(string: info.mediaURL), UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "Invalid Link", message: "Please select another location")
            return
        }
        UIApplication.shared.open(url, options: [:])
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    
    
        print("didselect")
    
    }
}

