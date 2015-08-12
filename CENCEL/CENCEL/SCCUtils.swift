//
//  Utils.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 02/04/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import Foundation
import UIKit

class SCCUtils{
    func generateAlertController(fromMessage: String) -> UIAlertController {
        var message:UIAlertController = UIAlertController(title: "CENCEL", message: fromMessage, preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        return message
    }
    
    func getCencelColor() -> UIColor {
        return UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1.0)
    }
}
