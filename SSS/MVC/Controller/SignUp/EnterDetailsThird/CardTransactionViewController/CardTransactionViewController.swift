//
//  CardTransactionViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import SwiftyStoreKit

class CardTransactionViewController: UIViewController {
    
    @IBOutlet weak var txtCardNo: TextField!
    @IBOutlet weak var txtExpDate: TextField!
    @IBOutlet weak var txtZipCode: TextField!
    @IBOutlet weak var txtCardName: TextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCardNo.placeHolderAtt()
        txtExpDate.placeHolderAtt()
        txtZipCode.placeHolderAtt()
        txtCardName.placeHolderAtt()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPayAction(_ sender: Any) {
        
        
    }
    
    
    
}
