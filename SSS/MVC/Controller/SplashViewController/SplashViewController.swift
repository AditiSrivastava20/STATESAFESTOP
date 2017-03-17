//
//  SplashViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import SideMenuController

class SplashViewController: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "home", sender: nil)
        self.performSegue(withIdentifier: "sidePanel", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
