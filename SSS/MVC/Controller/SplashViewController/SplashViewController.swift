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
        
        let user = UserDataSingleton.sharedInstance.loggedInUser
        
        if  user != nil && user?.profile?.is_pin == "1" {
            self.present(StoryboardScene.Main.initialViewController() , animated: false, completion: nil)
        } else {
            
            let vc = StoryboardScene.SignUp.instantiateLogin()
            pushVC(vc)
            
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
