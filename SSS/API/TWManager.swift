//
//  TWManager.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import TwitterKit

class TWManager {
    
    static let shared = TWManager()
    
    func logOut() {
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            print("log out")
            store.logOutUserID(userID)
        }
    }
    
    //Mark: Twitter login
    func login(_ obj: UIViewController) {
        
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
                            APIManager.shared.request(with: LoginEndpoint.login(email: "", password: "", facebookId: "", twitterId: "\(json["id"]!)", accountType: AccountType.twitter.rawValue, deviceToken: "ahjsdgjhagshjd"), completion: { (response) in
                                
                                HandleResponse.shared.handle(response: response, obj)
                                
                            })
                            
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
        
}


