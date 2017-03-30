//
//  PinValidationViewController.swift
//  SSS
//
//  Created by Sierra 4 on 15/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

protocol pinEnteredListner : class {
    
    func getPinCode(pin : String?)
    
}

class PinValidationViewController: BaseViewController {
    
    weak var delegatePin : pinEnteredListner?

    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        
        delegatePin?.getPinCode(pin : pinCodeTextField.text)
        
        dismissVC(completion: nil)
        
    }
    
    
}



