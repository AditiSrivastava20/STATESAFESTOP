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
//import FBSDKLoginKit
//import TwitterKit
import EZSwiftExtensions
import NVActivityIndicatorView

class LoginViewController: BaseViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var btnFacebook: Button!
    @IBOutlet weak var btnTwitter: Button!
    @IBOutlet weak var btnLogin: Button!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.placeHolderAtt()
        txtPassword.placeHolderAtt()
        txtEmail?.text = "abhi.ssj5@gmail.com"
        txtPassword?.text = "1234512345"
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
        performSegue(withIdentifier: segue.loginToForgotPassword.rawValue, sender: self)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        print("login")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            APIManager.shared.request(with: LoginEndpoint.login(email: txtEmail.text, password: txtPassword.text, facebookId: "", twitterId: "", accountType: AccountType.normal.rawValue, deviceToken: MobileDevice.token.rawValue), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self, from: .login)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        performSegue(withIdentifier: segue.loginToSignup.rawValue, sender: nil)
    }
    
}


//MARK: Facebook login action
extension LoginViewController {
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        
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
        
        ez.runThisInMainThread {
            self.startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        TWManager.shared.login(self, check: .login, completion: { (twProfile) in
            UIApplication.shared.endIgnoringInteractionEvents()
            print(/twProfile.id)
        })
       
    }

}



