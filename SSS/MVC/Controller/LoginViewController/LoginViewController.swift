//
//  LoginViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages
import FBSDKLoginKit
import TwitterKit
import NVActivityIndicatorView

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var btnFacebook: Button!
    
    @IBOutlet weak var btnTwitter: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.placeHolderAtt()
        txtPassword.placeHolderAtt()
        
        //checkLogin()
    }
    
    func checkLogin() {
        if let _ = UserDefaults.standard.value(forKey: "User") as? User {
            performSegue(withIdentifier: "main", sender: self)
        }
    }
    
    func Validate() -> Valid{
        let value = Validation.shared.validate(login: txtEmail?.text, password: txtPassword?.text)
        return value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


//MARK: Normal login action

extension LoginViewController {
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        
        print("forgot password")
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        print("login")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            APIManager.shared.request(with: LoginEndpoint.login(email: txtEmail.text, password: txtPassword.text, facebookId: "", twitterId: "", accountType: AccountType.normal.rawValue, deviceToken: Device.token.rawValue), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self)
                
            })
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
}


//MARK: Facebook login action
extension LoginViewController {
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        print("facebook login selected")
        
        FBManager.shared.login(self, check: .login , completion: { (fbProfile) in
            print(fbProfile.fbId ?? "")
        })

    }

}




//MARK: Twitter login Action
extension LoginViewController {
    
    @IBAction func btnTwitterAction(_ sender: Any) {
        print("twitter login selected")
        
        TWManager.shared.login(self, check: .login, completion: { (json) in
            
            print("\(json["id"]!)")
        
        })
    }

}





































