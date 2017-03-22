//
//  EnterDetailsSecondViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class EnterDetailsFirstViewController: BaseViewController {
    
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNo: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFullAddress.placeHolderAtt()
        txtPhoneNo.placeHolderAtt()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }


}
