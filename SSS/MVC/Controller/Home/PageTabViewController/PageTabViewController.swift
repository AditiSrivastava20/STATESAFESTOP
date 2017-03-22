//
//  PageTabViewController.swift
//  SSS
//
//  Created by Sierra 4 on 21/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class PageTabViewController: UIViewController {
    
    @IBOutlet weak var btnProfile: Button!
    @IBOutlet weak var btnNotifications: Button!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    let selectedIconColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
    let deselectedIconColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sidePanel(_ sender: Any) {
        self.btnProfile.isEnabled = false
        SidePanel.shared.ShowPanel(obj: self,opr: .left,identifier: "ProfilePanel"){_ in
            self.btnProfile.isEnabled = true
        }
    }
    
    @IBAction func notifications(_ sender: Any) {
        
    }
    
    
    

}
