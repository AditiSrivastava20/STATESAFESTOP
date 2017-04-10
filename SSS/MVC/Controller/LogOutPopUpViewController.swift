//
//  LogOutPopUpViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit


class LogOutPopUpViewController: UIViewController {
    
    var obj:SideMenuViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnYesAction(_ sender: Any) {
        
        dismissVC { 
            self.obj?.logOutApi()
        }
        
    }
    
    
    @IBAction func btnNoAction(_ sender: Any) {
        
        dismissVC(completion: nil)
        
    }


}
