//
//  PinValidationViewController.swift
//  SSS
//
//  Created by Sierra 4 on 15/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class PinValidationViewController: BaseViewController {

    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeTextField.keyboardType = .numberPad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func Validate() -> Valid {
        return Validation.shared.validate(pinCode: pinCodeTextField.text)
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        
        switch Validate() {
        case .success:
            guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
                return
            }
            let pin:String = (login["pin_password"])!
            
            if (pinCodeTextField.text?.isEqual(pin))! {
                print("dismiss")
                dismiss(animated: true, completion: nil)
            } else {
                Alerts.shared.show(alert: .error, message: "Incorrect pin" , type : .warning)
            }
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    
}



