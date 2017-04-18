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
                
                
                let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                if launchedBefore  {
                    let vc = StoryboardScene.SignUp.instantiateLogin()
                    
                    navigationController?.pushViewController(vc, animated: false)
                } else {
                    
                    
                    let vc = StoryboardScene.SignUp.instantiateTutorialViewController()
                    navigationController?.pushViewController(vc, animated: false)
                    
                    
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                    
                    
                    
                    
                    
                    
                }
                
            }
            
            
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        
        
    }
