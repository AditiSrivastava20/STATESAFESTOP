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


internal struct FacebookInvite {
    
    static let image_url = "https://scontent-sit4-1.xx.fbcdn.net/v/t1.0-9/17522662_979563635512365_8880744625037125330_n.png?oh=83d47d30912cf94ac8b422111fc988d3&oe=59640C01"
    static let app_link_url = "https://fb.me/1809174539335259"
}


class FBManager {
    
    static let shared = FBManager()
    
    //MARK:- Facebook login
    func login(_ obj: UIViewController, check: SocialCheck, completion : @escaping (FacebookResponse) -> () ) {
        
        var fbProfile:FacebookResponse?
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: obj) { (result, err) in
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
    }
    
    func fetchFriendsAction(completion : @escaping (Int) -> () ) {
        
        FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["fields": "id"]).start {(connection, result , error) -> Void in
            
            if error != nil {
                print("failed to start graph request: \(error)")
                return
            }
            
            let resultdict = result as! NSDictionary
            let friends = resultdict.object(forKey: "data") as! NSArray
            //print("Found \(friends.count) friends")
            
            completion(friends.count)
        }
        
    }
    
    //MARK:- login/signup after facebook response
    func apiHit(param: FacebookResponse , check: SocialCheck , obj: UIViewController) {
        
        switch check {
        case .login:
            APIManager.shared.request(with: LoginEndpoint.login(email: param.email, password: "", facebookId: param.fbId, twitterId: "", accountType: AccountType.facebook.rawValue, deviceToken: MobileDevice.token.rawValue), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, obj, from: .login)
            })
        
        case .signup:
            print(SocialCheck.signup.rawValue)
            
        }
        
    }
    
}
