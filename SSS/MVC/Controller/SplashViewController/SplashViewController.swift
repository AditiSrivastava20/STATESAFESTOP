//
//  SplashViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDataSingleton.sharedInstance.loggedInUser  != nil{
            
            let user = UserDataSingleton.sharedInstance.loggedInUser
            
            if validateToken(user) {
                loginChecks(user!)
                
            } else {
                UserDataSingleton.sharedInstance.loggedInUser = nil
                performSegue(withIdentifier: segue.splashToLogin.rawValue, sender: self)
            }
            
        } else {
            
            performSegue(withIdentifier: segue.splashToLogin.rawValue, sender: self)
            
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func validateToken(_ login: User?) -> Bool {
        return true
    }
    
    func loginChecks(_ login: User) {
        
        if login.profile?.is_pin == "0" {
            //go to pin-password setup
            let vc = StoryboardScene.SignUp.instantiateEnterDetailsSecondViewController()
            pushVC(vc)
            
        } else {
            //go to main
            performSegue(withIdentifier: segue.splashToMain.rawValue, sender: self)
        }
        
        
    }
    

}
