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

class ForgotPasswordViewController: BaseViewController, TextFieldDelegate {
    
    @IBOutlet weak var txtEmail: TextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.placeHolderAtt()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: TextField)  {
        ISMessages.hideAlert(animated: true)
    }
    
    //MARK: validate
    func validate() -> Bool {
        
        if txtEmail.isEmpty {
            Alerts.shared.show(alert: .oops, message: "Enter email", type: .error)
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
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        popVC()
    }
    
    //MARK: - submit email action
    @IBAction func btnSubmitAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        if validate() {
            APIManager.shared.request(with: LoginEndpoint.forgotPassword(email: txtEmail.text), completion: {(response) in
                self.handle(response: response)
            })
        }
        
    }
    
}
