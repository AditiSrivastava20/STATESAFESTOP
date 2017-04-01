//
//  Profile.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import SwiftyJSON

class Profile: NSObject{
    var device_token: String?
    var image: String?
    var unformatted_phone: String?
    var id: Int?
    var fulladdress: String?
    var is_complete_profile: String?
    var facebook_id: String?
    var is_verified: Int?
    var email: String?
    var account_type: String?
    var pin_password: String?
    var phone: String?
    var is_admin: Int?
    var is_pin: String?
    var access_token: String?
    var twitter_id: String?
    var reg_id: String?
    var image_url: String?
    var lastLogin: String?
    var fullname: String?
    
    required init(attributes: OptionalJSON) throws{
        super.init()
        
        email = .email => attributes
        fullname = .fullname => attributes
        image_url = .image_url => attributes
        fulladdress = .fulladdress => attributes
        facebook_id = .facebook_id => attributes
        twitter_id = .twitter_id => attributes
        is_complete_profile = .is_complete_profile => attributes
        pin_password = .pin_password => attributes
        account_type = .account_type => attributes
        is_pin = .is_pin => attributes
        phone = .phone => attributes
        unformatted_phone = .unformatted_phone => attributes
        
    }
    
    override init() {
        super.init()
    }


}
