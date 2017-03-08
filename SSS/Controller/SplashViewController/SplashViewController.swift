//
//  SplashViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if UserDefaults.standard.value(forKey: "access_token") == nil {
            performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        } else {
            performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        }
    }

}
