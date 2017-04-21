//
//  FBManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import UIKit
import NVActivityIndicatorView


internal struct FacebookInvite {
    
    static let message = "State Safe Stop App"
    static let data = "State Safe Stop"
}

enum GraphRequest {
    
    case me
    case friends
    
}


class FBManager: UIViewController, NVActivityIndicatorViewable {
    
    static let shared = FBManager()
    
    //MARK:- Facebook login
    func login(_ obj: UIViewController, check: SocialCheck, graphRequest: GraphRequest, completion : @escaping (Any) -> () ) {
        
        
        let fbObj = FBSDKLoginManager()
            fbObj.logOut()
        
        fbObj.loginBehavior = .native
        
        fbObj.logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: obj) { (result, err) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if err != nil {
                print(err?.localizedDescription ?? "Failed to start graph request")
                return
            } else if (result?.isCancelled)! {
                
            } else {
                
                switch graphRequest {
                case .me:
                    self.requestMe(obj, check: check, completion: {(fbProfile) in
                        
                        completion(fbProfile)
                    })
                    
                case .friends:
                    self.requestFriends(completion: {(count) in
                        completion(count)
                        
                    })
                    
                }
            }
        }
    }
    
    //MARK: - get user information
    func requestMe(_ obj: UIViewController, check: SocialCheck ,completion : @escaping (FacebookResponse) -> ()) {
        
        var fbProfile:FacebookResponse?
        
        //start loader
        self.startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name , email, picture.width(480).height(480)"]).start { (connection, result, err) -> Void in
            
            //Stop loader
            self.stopAnimating()
            
            if err != nil {
                print(err?.localizedDescription ?? "Failed to start graph request")
                return
            }
            
            print(result ?? "")
            
            fbProfile = FacebookResponse(result: result as AnyObject?)
            
            self.apiHit(param: fbProfile!, check: check, obj: obj)
            
            completion(fbProfile!)
        }
        
    }
    
    //MARK: -  get facebook friends count
    func requestFriends(completion : @escaping (Int) -> ()) {
        //start loader
        
        completion(1)

    }
    
    
    //MARK:- login/signup with facebook
    func apiHit(param: FacebookResponse , check: SocialCheck , obj: UIViewController) {
        
        switch check {
        case .login:
            
            APIManager.shared.request(with: LoginEndpoint.login(email: param.email, password: "", facebookId: param.fbId, twitterId: "", accountType: AccountType.facebook.rawValue, deviceToken: ""), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, obj, from: .fbLogin, param: param)
            })
        
        case .signup:
            print(SocialCheck.signup.rawValue)
            
        }
        
    }
    
}
