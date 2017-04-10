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
    
    static let image_url = "https://scontent-sit4-1.xx.fbcdn.net/v/t1.0-9/17522662_979563635512365_8880744625037125330_n.png?oh=83d47d30912cf94ac8b422111fc988d3&oe=59640C01"
    static let app_link_url = "https://fb.me/1809174539335259"
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
        
        fbObj.logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: obj) { (result, err) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if err != nil {
                print("failed to start graph request: \(err)")
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
                print("failed to start graph request: \(err)")
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
//        self.startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
//        
//        
//        FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["fields": "id"]).start {(connection, result , error) -> Void in
//            
//            //Stop loader
//            self.stopAnimating()
//            
//            if error != nil {
//                print("failed to start graph request: \(error)")
//                return
//            }
//            
//            let resultdict = result as! NSDictionary
//            let friends = resultdict.object(forKey: "data") as! NSArray
//            //print("Found \(friends.count) friends")
//            
//            completion(friends.count)
//        }
        
    }
    
    //MARK:- Handle
    func handle(response: Response,_ obj: UIViewController, param: FacebookResponse) {
        
        switch response {
            
        case .success(let responseValue):
            
            if let value = responseValue as? User {
                UserDataSingleton.sharedInstance.loggedInUser = value
                LoginChecks.shared.check(obj, user: UserDataSingleton.sharedInstance.loggedInUser)
            }
        
        case .failure(let str):
//            Alerts.shared.show(alert: .oops, message: /str, type: .error)
            
            let vc = StoryboardScene.SignUp.instantiateEnterDetailsFirstViewController()
            vc.fbProfile = param
            vc.isFromFacebook = true
            obj.pushVC(vc)
            
            
        }
        
    }
    
    
    //MARK:- login/signup with facebook
    func apiHit(param: FacebookResponse , check: SocialCheck , obj: UIViewController) {
        
        switch check {
        case .login:
            
            guard let FCM = UserDefaults.standard.value(forKey: "FCM") as? String else {
                return
            }
            
            APIManager.shared.request(with: LoginEndpoint.login(email: param.email, password: "", facebookId: param.fbId, twitterId: "", accountType: AccountType.facebook.rawValue, deviceToken: FCM), completion: { (response) in
                
                self.handle(response: response, obj, param: param)
            })
        
        case .signup:
            print(SocialCheck.signup.rawValue)
            
        }
        
    }
    
}
