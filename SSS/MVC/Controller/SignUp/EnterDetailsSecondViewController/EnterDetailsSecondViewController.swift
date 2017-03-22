//
//  EnterDetailsFirstViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class EnterDetailsSecondViewController: BaseViewController {
    
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPasswd: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFullname.placeHolderAtt()
        txtEmail.placeHolderAtt()
        txtPassword.placeHolderAtt()
        txtConfirmPasswd.placeHolderAtt()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: Any) {
        print("back")
        _ = navigationController?.popViewController(animated: true)
    }

}
