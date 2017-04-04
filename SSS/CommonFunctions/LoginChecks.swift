//
//  LoginChecks.swift
//  SSS
//
//  Created by Sierra 4 on 04/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

class LoginChecks {
    
    static let shared = LoginChecks()
    
    func check(_ obj: UIViewController, user: User?) {
        
        if user?.profile?.is_pin == "0" {
            //go to pin-password setup
            obj.performSegue(withIdentifier: segue.loginToPin.rawValue, sender: obj)
            
        } else {
            //go to main
            obj.performSegue(withIdentifier: segue.loginToMain.rawValue, sender: obj)
        }
        
    }
    
    
}
