//
//  ProfileData.swift
//  SSS
//
//  Created by Sierra 4 on 25/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

class ProfileData {
    
    static let shared = ProfileData()
    
    func store(_ value: User?) {
        var login:[String:String] = [:]
        
        login["fullname"] = value?.profile?.fullname
        login["access_token"] = /value?.access_token
        login["account_type"] = value?.profile?.account_type
        login["email"] = value?.profile?.email
        login["is_pin"] = value?.profile?.is_pin
        login["pin_password"] = value?.profile?.pin_password
        login["image_url"] = value?.profile?.image_url
        login["phone"] = value?.profile?.phone
        login["facebook_id"] = value?.profile?.facebook_id
        login["twitter_id"] = value?.profile?.twitter_id

        UserDefaults.standard.set(login, forKey: "login")
    }
    
}
