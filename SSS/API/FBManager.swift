//
//  FBManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Kingfisher

class FBManager {
    
    static let shared = FBManager()
    
    //MARK:- Facebook login
    func login(_ obj: UIViewController, check: Check, completion : @escaping (FacebookResponse) -> () ) {
        
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
                self.apiHit(param: fbProfile!, check: check, obj: obj)
                completion(fbProfile!)
                
            }
        }
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
    
    
    //MARK:- login/signup after facebook response
    func apiHit(param: FacebookResponse , check: Check , obj: UIViewController) {
        
        switch check {
        case .login:
            APIManager.shared.request(with: LoginEndpoint.login(email: param.email, password: "", facebookId: param.fbId, twitterId: "", accountType: AccountType.facebook.rawValue, deviceToken: "jasgdjgajsh"), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, obj)
            })
        
        case .signup:
            print("signup")
            
//            ImageDownloader.default.downloadImage(with: URL(string: param.imageUrl!)! , options: [], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//                
//                APIManager.shared.request(withImages: LoginEndpoint.signup(fullname: param.name, email: param.email, fullAddress: "", password: "", facebookId: param.fbId, twitterId: "", phone: "", accountType: AccountType.facebook.rawValue, deviceToken: Device.token.rawValue),image: image , completion: { (response) in
//                    
//                    HandleResponse.shared.handle(response: response, obj)
//                })
//            })
            
        }
        
    }
    
}
