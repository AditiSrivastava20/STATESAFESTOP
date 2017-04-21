//
//  ChangePasswordViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages
import EZSwiftExtensions


class ChangePasswordViewController: BaseViewController, TextFieldDelegate {
    
    @IBOutlet weak var txtCurrentPassword: TextField!
    @IBOutlet weak var txtNewPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCurrentPassword.placeHolderAtt()
        txtNewPassword.placeHolderAtt()
        txtConfirmPassword.placeHolderAtt()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
    }
    
    
    func textFieldDidBeginEditing(_ textField: TextField) {
        ISMessages.hideAlert(animated: true)
    }
    
    //MARK: - validate all fields
    func validate() -> Valid {
        
        return Validation.shared.validate(changePassword: txtCurrentPassword.text, new: txtNewPassword.text, confirm: txtConfirmPassword.text)
        
    }
    
    
    //MARK: hit change password api
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        
        switch validate() {
            
        case .success:
            print("success")
            
            Loader.shared.start()
            
            let token = UserDataSingleton.sharedInstance.loggedInUser?.profile?.access_token
            
            APIManager.shared.request(with: LoginEndpoint.changePassword(accessToken: token, old_password: txtCurrentPassword.text, new_password: txtNewPassword.text), completion: { (response) in
                
                Loader.shared.stop()
                
                HandleResponse.shared.handle(response: response, self, from: .changePassword , param: nil)
                
            })
            
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .error)
            
            
        }
        
        
    }
    

}
