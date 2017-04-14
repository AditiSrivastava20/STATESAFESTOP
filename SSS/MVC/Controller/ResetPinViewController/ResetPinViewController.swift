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
    
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    
    
    //MARK: - handle api response
    func handle(response : Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                
                print(value.msg ?? "")
                var login = UserDataSingleton.sharedInstance.loggedInUser
                login?.profile?.pin_password = pinCodeTextField.text
                UserDataSingleton.sharedInstance.loggedInUser = login
                Alerts.shared.show(alert: .success, message: value.msg!, type: .success)
            }
            popVC()
            
        case .failure(let str):
            Alerts.shared.show(alert: .alert, message: /str, type: .error)
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
            
            APIManager.shared.request(with: LoginEndpoint.resetPin(accessToken: login.profile?.access_token, pinPassword: pinCodeTextField.text) , completion: { (response) in
                
                self.handle(response: response)
            })
            
        case .failure( _,let msg):
            Alerts.shared.show(alert: .alert, message: msg , type : .error)
        }
        
    }
    
    
    

}
