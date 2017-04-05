//
//  TWManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import TwitterKit
import NVActivityIndicatorView
import UIKit
import SwiftyJSON

class TWManager: UIViewController, NVActivityIndicatorViewable {
    
    static let shared = TWManager()
    
    //MARK:- Twitter logout
    func logOut() {
        print("log out")
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
        }
    }
    
    
    //MARK:- Twitter login
    func login(_ obj: UIViewController, check: SocialCheck, completion : @escaping (TwitterResponse) -> () ) {
        
        self.stopAnimating()
        
        //Start twitter session
        let twObj = Twitter.sharedInstance()
        let store = twObj.sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
        twObj.logIn { (session, error) in
            
            if session != nil {
                print("signed in as \(session!.userName)")
                print("\(session?.userID)")
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                
                //start loader
                self.startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    
                    //Stop loader
                    self.stopAnimating()
                    
                    if (connectionError == nil) {
                        do{
                            
                            let jsonData = JSON(data)
                            let item = try TwitterResponse(attributes: jsonData.dictionaryValue)
                            self.apiHit(param: item, check: check, obj: obj)
                            completion(item)
                            
                        } catch {
                            
                        }
                    }
                    else {
                        
                        print("Error: \(connectionError)")
                    }
                }
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
                NSLog("Login error: ", error!.localizedDescription);
            }
        }
        
    }
    
    
    //MARK: - handle response
    func handle(response: Response,_ obj: UIViewController, param: TwitterResponse) {
        
        switch response {
            
        case .success(let responseValue):
            
            if let value = responseValue as? User {
                UserDataSingleton.sharedInstance.loggedInUser = value
                LoginChecks.shared.check(obj, user: UserDataSingleton.sharedInstance.loggedInUser)
            }
            
        case .failure(let str):
            
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
            
            let vc = StoryboardScene.SignUp.instantiateEnterDetailsFirstViewController()
            vc.isFromTwitter = true
            vc.twProfile = param
            obj.pushVC(vc)
            
        }
        
    }
    
    
    
    //MARK:- login/signup after twitter response
    func apiHit(param: TwitterResponse , check: SocialCheck , obj: UIViewController) {
        
        switch check {
        case .login:
            APIManager.shared.request(with: LoginEndpoint.login(email: "", password: "", facebookId: "", twitterId: /param.id, accountType: AccountType.twitter.rawValue, deviceToken: MobileDevice.token.rawValue), completion: { (response) in
                
                self.handle(response: response, obj, param: param)
                
            })
            
        case .signup:
            print(SocialCheck.signup.rawValue)
            
        }
        
    }
    
        
}


