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
                
                print(value.profile?.twitter_id ?? "" )
                //Alerts.shared.show(alert: .success, message: Alert.login.rawValue, type: .success)
                print(Alert.login.rawValue)
                obj.performSegue(withIdentifier: "main", sender: obj)
                
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
            TWManager.shared.logOut()
        }
        
    }
    
}
