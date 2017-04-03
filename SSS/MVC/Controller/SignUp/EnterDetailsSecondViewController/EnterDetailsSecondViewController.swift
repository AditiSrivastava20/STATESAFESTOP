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

    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    @IBOutlet weak var btnDone: Button!
    
    var accessToken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Validate pin
    func Validate() -> Valid {
        return Validation.shared.validate(pinCode: pinCodeTextField.text)
    }
    
    
    //MARK: Button done Action
    @IBAction func btnDoneAction(_ sender: Any) {
        
        switch Validate() {
        case .success:
            guard let login = UserDataSingleton.sharedInstance.loggedInUser  else {
                Alerts.shared.show(alert: .error , message: Alert.error.rawValue , type : .info)
                return
            }
            
            APIManager.shared.request(with: LoginEndpoint.pinPassword(accessToken: login.profile?.access_token, pinPassword: pinCodeTextField.text), completion: { (response) in
                HandleResponse.shared.handle(response: response, self, from: .pinPassword)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }

}

