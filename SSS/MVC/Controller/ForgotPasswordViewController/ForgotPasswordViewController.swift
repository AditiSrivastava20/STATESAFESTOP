//
//  ForgotPasswordViewController.swift
//  SSS
//
//  Created by Sierra 4 on 03/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages
import EZSwiftExtensions
import NVActivityIndicatorView


class ForgotPasswordViewController: BaseViewController, TextFieldDelegate {
    
    @IBOutlet weak var txtEmail: TextField!
    
    var email:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let _ = email {
            txtEmail.text = email
        }
        
        txtEmail.placeHolderAtt()
    }

    
    func textFieldDidBeginEditing(_ textField: TextField)  {
        ISMessages.hideAlert(animated: true)
    }
    
    //MARK: validate
    func validate() -> Bool {
        
        if txtEmail.isEmpty {
            Alerts.shared.show(alert: .alert, message: "Enter email", type: .error)
            return false
        } else {
            return true
        }
    }
    
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        popVC()
    }
    
    //MARK: - submit email action
    @IBAction func btnSubmitAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        if validate() {
            
            Loader.shared.start()
            
            APIManager.shared.request(with: LoginEndpoint.forgotPassword(email: txtEmail.text), completion: { (response) in
                
                Loader.shared.stop()
                
                HandleResponse.shared.handle(response: response, self, from: .forgotPassword , param: nil)
            })
        }
        
    }
    
}
