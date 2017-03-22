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
    
    let dToken:String = "adaffasdgsdg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.placeHolderAtt()
        txtPassword.placeHolderAtt()
        
        if let login = UserDefaults.standard.value(forKey: "login") as? [String: String] {
            if !login.isEmpty {
                performSegue(withIdentifier: "main", sender: self)
            }
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


//Mark: Normal login action

extension LoginViewController {
    
    @IBAction func forgotPasswd(_ sender: Any) {
        print("forgot password")
    }
    
    @IBAction func login(_ sender: Any) {
        print("login")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            APIManager.shared.request(with: LoginEndpoint.login(email: txtEmail.text, password: txtPassword.text, facebookId: "", twitterId: "", accountType: AccountType.normal.rawValue, deviceToken: dToken), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self)

            })
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
}


//Mark: Facebook login action
extension LoginViewController {
    
    @IBAction func facebookLogin(_ sender: Any) {
        print("facebook login selected")
        
        FBManager.shared.login(self)
    }

}




//Mark: Twitter login Action 
extension LoginViewController {
    
    @IBAction func twitterAction(_ sender: Any) {
        print("twitter login selected")
        
        TWManager.shared.login(self)
        
    }
    
}





































