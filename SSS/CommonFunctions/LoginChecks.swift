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
            
            obj.pushVC(StoryboardScene.SignUp.instantiateEnterDetailsSecondViewController())
            
        } else if user?.profile?.is_payment_complete == "0" {
            //go to SSS package selection
            
            obj.pushVC(StoryboardScene.SignUp.instantiateSSSPackageViewController())
            
        } else {
            //go to main
            
            obj.presentVC(StoryboardScene.Main.initialViewController())
        }
        
    }
    
    func exitFromMain() {
        UserDataSingleton.sharedInstance.loggedInUser = nil
        UIApplication.shared.keyWindow?.rootViewController = StoryboardScene.SignUp.initialViewController()
    }

    
    
}
