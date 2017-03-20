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
import NVActivityIndicatorView

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func handleResponse(response : Response) {
        switch response{
            
        case .success(let responseValue):
            if let _ = responseValue as? User{
                Alerts.shared.show(alert: .success, message: Alert.login.rawValue, type: .success)
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str.rawValue, type: .error)
        }
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
            APIManager.shared.request(with: LoginEndpoint.login(email: txtEmail.text, password: txtPassword.text, accountType: AccountType.normal.rawValue, deviceToken: "adaffasdgsdg"), completion: {[weak self] (response) in
                
                self?.handleResponse(response: response)
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
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            
            if err != nil {
                print("failed to start graph request: \(err)")
                return
            }
            self.getEmailNameIdImageFromFB()
        }
    }
    
    
    
    func getEmailNameIdImageFromFB() {
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name , email, picture.width(480).height(480), "]).start { (connection, result, err) -> Void in
            
            if err != nil {
                print("failed to start graph request: \(err)")
                return
            }
            print(result ?? "")
        }
    }
}


//Mark: Twitter login Action 
extension LoginViewController {
    
    @IBAction func twitterAction(_ sender: Any) {
        print("twitter login selected")
    }
    
    
}










