//
//  LoginViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import Firebase
import ISMessages
import EZSwiftExtensions
import NVActivityIndicatorView

class LoginViewController: BaseViewController, NVActivityIndicatorViewable, TextFieldDelegate {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var btnFacebook: Button!
    @IBOutlet weak var btnTwitter: Button!
    @IBOutlet weak var btnLogin: Button!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        txtEmail.placeHolderAtt()
        txtPassword.placeHolderAtt()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }
    
    
    func checkForSession(){
        
        
    }
    
    //MARK: - validate fields
    func Validate() -> Valid{
        let value = Validation.shared.validate(login: txtEmail?.text, password: txtPassword?.text)
        return value
    }
    
    
    func textFieldDidBeginEditing(_ textField: TextField)  {
        ISMessages.hideAlert(animated: true)
    }
    
}


//MARK: Normal login action

extension LoginViewController {
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        print("forgot password")
        performSegue(withIdentifier: segue.loginToForgotPassword.rawValue, sender: self)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        print("login")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            
            guard let FCM = UserDefaults.standard.value(forKey: "FCM") as? String else {
                return
            }
            
            APIManager.shared.request(with: LoginEndpoint.login(email: txtEmail.text, password: txtPassword.text, facebookId: "", twitterId: "", accountType: AccountType.normal.rawValue, deviceToken: FCM), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self, from: .login)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .error)
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        performSegue(withIdentifier: segue.loginToSignup.rawValue, sender: nil)
    }
    
}


//MARK: Facebook login action
extension LoginViewController {
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        FBManager.shared.login(self, check: .login , graphRequest: .me , completion: { (fbProfile) in
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let value = fbProfile as? FacebookResponse
            print(value?.fbId ?? "")
        })

    }

}




//MARK: Twitter login Action
extension LoginViewController {
    
    @IBAction func btnTwitterAction(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
                
        UIApplication.shared.beginIgnoringInteractionEvents()
        TWManager.shared.login(self, check: .login, completion: { (twProfile) in
            UIApplication.shared.endIgnoringInteractionEvents()
            print(/twProfile.id)
        })
       
    }

}



