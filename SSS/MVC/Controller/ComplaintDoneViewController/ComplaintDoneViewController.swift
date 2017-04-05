//
//  ComplaintDoneViewController.swift
//  SSS
//
//  Created by Sierra 4 on 30/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class ComplaintDoneViewController: UIViewController {
    
    var obj:UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnComplaintDoneAction(_ sender: Any) {
        dismissVC { 
            self.obj?.popVC()
        }
        
    }
    

}
