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
            
            if validateToken(login: user) {
                performSegue(withIdentifier: segue.splashToMain.rawValue, sender: self)
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
    
    func validateToken(login: User?) -> Bool {
        return true
    }
    

}
