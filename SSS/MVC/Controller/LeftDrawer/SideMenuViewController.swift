//
//  SideMenuViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/24/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions


class SideMenuViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnSafelistAction(_ sender: Any) {
        
        hideSideMenuView()
        let destinationVC = StoryboardScene.Main.instantiateSafeListViewController()
        ez.topMostVC?.pushVC(destinationVC)
    }
    
    
}
