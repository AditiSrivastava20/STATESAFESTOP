//
//  ResetPinViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import ISMessages

class ResetPinViewController: BaseViewController {

    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - handle api response
    func handle(response : Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                
                print(value.msg ?? "")
                UserDataSingleton.sharedInstance.loggedInUser?.profile?.pin_password = pinCodeTextField.text
            }
            popVC()
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
    //MARK: - Validate pin
    func Validate() -> Valid{
        let value = Validation.shared.validate(pinCode: pinCodeTextField.text)
        return value
    }
    
    
    @IBAction func goBackAction(_ sender: UIBarButtonItem) {
        popVC()
    }
    
    
    //MARK: - reset pin action
    @IBAction func btnDoneAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        switch Validate() {
        case .success:
            
            guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
                return
            }
            
            APIManager.shared.request(with: LoginEndpoint.resetPin(accessToken: login.access_token, pinPassword: pinCodeTextField.text) , completion: { (response) in
                
                self.handle(response: response)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
        
    }
    
    
    

}
