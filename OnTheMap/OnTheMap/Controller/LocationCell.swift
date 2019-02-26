//
//  LocationCell.swift
//  OnTheMap
//
//  Created by Reem Saloom on 2/12/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation

import UIKit

class LocationCell: UITableViewCell {
    
    
   // @IBOutlet weak var labelName: UILabel!
   // @IBOutlet weak var labelUrl: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelUrl: UILabel!
    
    func configWith(_ info: StudentLocation) {
        labelName.text = info.firstName! + " " + info.lastName!
        //labelUrl.text = info.mediaURL
    }
    
}
