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
        // Do any additional setup after loading the view.
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
    
    //MARK: Handle response
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                Alerts.shared.show(alert: .success, message: /value.msg, type: .success)
                
                ez.dispatchDelay(0.3, closure: {
                    self.popVC()
                })
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .alert, message: /str, type: .error)
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        popVC()
    }
    
    //MARK: - submit email action
    @IBAction func btnSubmitAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        if validate() {
            
            startLoader()
            
            APIManager.shared.request(with: LoginEndpoint.forgotPassword(email: txtEmail.text), completion: { [weak self] (response) in
                
                self?.stopLoader()
                
                self?.handle(response: response)
            })
        }
        
    }
    
}
