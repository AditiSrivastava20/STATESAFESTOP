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

enum HandleCheck {
    
    case login
    case signup
    case pinPassword
    case sssPackage
    case inAppPurchase
}


class HandleResponse {
    
    static let shared = HandleResponse()
    
    func handle(response : Response, _ obj: UIViewController, from: HandleCheck) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                
                print(value.msg ?? "")
                
                switch from {
                case .login:
                    ProfileData.shared.store(value)
                    obj.performSegue(withIdentifier: segue.loginToMain.rawValue, sender: obj)
                    
                case .signup:
                    ProfileData.shared.store(value)
                    obj.performSegue(withIdentifier: segue.signupToPin.rawValue, sender: obj)
                    
                case .pinPassword:
                    obj.performSegue(withIdentifier: segue.pinToPackage.rawValue, sender: obj)
                    
                case .sssPackage,.inAppPurchase:
                    print("go to main")
                
                }
                
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
}



