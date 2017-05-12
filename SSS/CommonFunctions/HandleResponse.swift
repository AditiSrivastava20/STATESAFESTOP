//
//  HandleResponse.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import ISMessages
import UIKit
import EZSwiftExtensions

enum HandleCheck {
    
    case login
    case fbLogin
    case twLogin
    case signup
    case pinPassword
    case sssPackage
    case forgotPassword
    case changePassword
    case editProfile
    case resetPin
    case logout
    case cameraScreen
    case writeComplaint

}


class HandleResponse {
    
    static let shared = HandleResponse()
    
    func handle(response : Response, _ obj: UIViewController, from: HandleCheck, param: Any?) {
        
        switch response{
        case .success(let responseValue):
            
            if let value = responseValue as? User {
                print(value.msg ?? "")
                
                switch from {
                case .login, .fbLogin, .twLogin:
                    
                    UserDataSingleton.sharedInstance.loggedInUser = value
                    LoginChecks.shared.check(obj, user: UserDataSingleton.sharedInstance.loggedInUser)
                    
                    
                case .signup:
                    
                    UserDataSingleton.sharedInstance.loggedInUser = value
                    obj.performSegue(withIdentifier: segues.signupToPin.rawValue, sender: obj)
                    
                    
                case .pinPassword:
                    
                    let login = UserDataSingleton.sharedInstance.loggedInUser
                    login?.profile?.is_pin = "1"
                    login?.profile?.pin_password = value.profile?.pin_password
                    UserDataSingleton.sharedInstance.loggedInUser = login
                    
                    obj.performSegue(withIdentifier: segues.pinToPackage.rawValue, sender: obj)
                    
                    
                case .sssPackage:
                    
                    print("go to main")
                    UserDefaults.standard.set("1", forKey: "FirstSignUp")
                    UserDefaults.standard.set("1", forKey: "RateUs")
                    obj.present(StoryboardScene.Main.initialViewController() , animated: false, completion: nil)
                    
                    
                case .forgotPassword, .changePassword:
                    
                    Alerts.shared.show(alert: .success, message: /value.msg, type: .success)
                    
                    ez.dispatchDelay(0.3, closure: {
                        obj.popVC()
                    })
                
                
                case .editProfile:
                    
                    Alerts.shared.show(alert: .success, message: /value.msg, type: .success)
                    UserDataSingleton.sharedInstance.loggedInUser = value
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSidePanel"), object: nil)
                    obj.popVC()
                    
                    
                case .resetPin:
                    
                    if let pin = param as? String {
                        
                        var login = UserDataSingleton.sharedInstance.loggedInUser
                        login?.profile?.pin_password = pin
                        UserDataSingleton.sharedInstance.loggedInUser = login
                        Alerts.shared.show(alert: .success, message: value.msg!, type: .success)
                    }
                    obj.popVC()
                
                
                case .logout:
                    
                    LoginChecks.shared.exitFromMain()
                    
                    
                case .cameraScreen:
                    
                    Alerts.shared.show(alert: .success, message: /value.msg, type: .success)
                    
                    
                case .writeComplaint:
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "complaint_done"), object: nil)
                
                
                }
                
            }
            
        case .failure(let str):
            
            switch from {
                
            case .fbLogin:
                
                if let fb = param as? FacebookResponse {
                    
                    let vc = StoryboardScene.SignUp.instantiateEnterDetailsFirstViewController()
                    vc.fbProfile = fb
                    vc.isFromFacebook = true
                    obj.pushVC(vc)
                }
            
            case .twLogin:
                
                if let tw = param as? TwitterResponse {
                    
                    let vc = StoryboardScene.SignUp.instantiateEnterDetailsFirstViewController()
                    vc.isFromTwitter = true
                    vc.twProfile = tw
                    obj.pushVC(vc)
                }
                
            
            default:
                Alerts.shared.show(alert: .alert, message: /str, type: .error)
                
                
            }
            
            
            
        }
        
    }
    
    

}


