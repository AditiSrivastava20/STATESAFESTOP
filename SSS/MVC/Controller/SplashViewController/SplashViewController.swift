//
//  SplashViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Foundation

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.performSegue(withIdentifier: "home", sender: nil)
        
//        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
//        let signup = storyBoard.instantiateViewController(withIdentifier: "loginAndSignup")
//        present(signup, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
