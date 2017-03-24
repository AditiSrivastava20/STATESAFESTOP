//
//  TWManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import TwitterKit
import Kingfisher

class TWManager {
    
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
    func login(_ obj: UIViewController, check: Check, completion : @escaping ([String: Any]) -> () ) {
        
        Twitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                print("signed in as \(session!.userName)")
                print("\(session?.userID)")
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                client.sendTwitterRequest(request) { response, data, connectionError in
                    if (connectionError == nil) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                            print("\(json["id"]!)")
                            
                            self.apiHit(param: json, check: check, obj: obj)
                            completion(json)
                            
                        } catch {
                            
                        }
                    }
                    else {
                        print("Error: \(connectionError)")
                    }
                }
            } else {
                NSLog("Login error: ", error!.localizedDescription);
            }
        }
        
    }
    
    
    
    //MARK:- login/signup after twitter response
    func apiHit(param: [String: Any] , check: Check , obj: UIViewController) {
        
        switch check {
        case .login:
            APIManager.shared.request(with: LoginEndpoint.login(email: "", password: "", facebookId: "", twitterId: "\(param["id"]!)", accountType: AccountType.twitter.rawValue, deviceToken: Device.token.rawValue), completion: { (response) in
                
                HandleResponse.shared.handle(response: response, obj)
            })
            
        case .signup:
            print(param)
            
        }
        
    }
    
        
}


