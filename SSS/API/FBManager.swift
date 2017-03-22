//
//  FBManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class FBManager {
    
    static let shared = FBManager()
    
    func login(_ obj: UIViewController) {
        
        var fbProfile:FacebookResponse?
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: obj) { (result, err) in
            if err != nil {
                print("failed to start graph request: \(err)")
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name , email, picture.width(480).height(480)"]).start { (connection, result, err) -> Void in
                
                if err != nil {
                    print("failed to start graph request: \(err)")
                    return
                }
                print(result ?? "")
                fbProfile = FacebookResponse(result: result as AnyObject?)
                APIManager.shared.request(with: LoginEndpoint.login(email: fbProfile?.email, password: "", facebookId: fbProfile?.fbId, twitterId: "", accountType: AccountType.facebook.rawValue, deviceToken: "jasgdjgajsh"), completion: { (response) in
                    
                    HandleResponse.shared.handle(response: response, obj)
                })
            }
        }
        
    }
    

}
