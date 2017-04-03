//
//  ChangePasswordViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class ChangePasswordViewController: UIViewController {
    
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
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
    }
    
    //MARK: - validate all fields
    func validate() -> Valid {
        
        return Validation.shared.validate(changePassword: txtCurrentPassword.text, new: txtNewPassword.text, confirm: txtConfirmPassword.text)
        
    }
    
    //MARK: - handle response
    func handle(response : Response) {
        
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
    
    //MARK: hit change password api
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        
        switch validate() {
            
        case .success:
            print("success")
            
            let token = UserDataSingleton.sharedInstance.loggedInUser?.profile?.access_token
            
            APIManager.shared.request(with: LoginEndpoint.changePassword(accessToken: token, old_password: txtCurrentPassword.text, new_password: txtNewPassword.text), completion: {(response) in
                
                self.handle(response: response)
            })
            
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
            
            
        }
        
        
    }
    

}
