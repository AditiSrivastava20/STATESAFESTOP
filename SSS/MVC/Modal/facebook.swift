//
//  facebook.swift
//  SSS
//
//  Created by Sierra 4 on 22/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookResponse : NSObject {
    
    var fbId : String?
    var name : String?
    var imageUrl : String?
    var email : String?
    
    init(result : AnyObject?) {
        super.init()
        guard let fbResult = result else { return }
        
        fbId = fbResult.value(forKey: "id") as? String
        name = fbResult.value(forKey: "name") as? String
        email = fbResult.value(forKey: "email") as? String
        imageUrl = "https://graph.facebook.com/".appending(FBSDKAccessToken.current().userID).appending("/picture?type=large")
        
    }
    
    override init() {
        super.init()
    }
}
