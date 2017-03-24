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

class HandleResponse {
    
    static let shared = HandleResponse()
    
    func handle(response : Response, _ obj: UIViewController){
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                
                print(value.msg ?? "")
                self.handleSuccess(response: value, obj)
                
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    func handleSuccess(response: User, _ obj: UIViewController) {
        
        UserDefaults.standard.setValue(response.access_token, forKey: ParamKeys.access_token.rawValue)
        
        if response.profile?.is_pin == "0" {
            
            obj.performSegue(withIdentifier: "setUpPin", sender: obj)
            
        } else if response.is_user_exist == "1" {
            
            obj.performSegue(withIdentifier: "main", sender: obj)
            
        }
    }
    
    
}



