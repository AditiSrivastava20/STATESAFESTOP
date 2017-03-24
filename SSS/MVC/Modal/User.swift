//
//  User.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import SwiftyJSON


class User: NSObject {
    
    var profile: Profile?
    var status_code: String?
    var is_user_exist: String?
    var access_token: String?
    var isnewuser: String?
    var msg: String?
    
    required init(attributes: OptionalJSON) throws{
        super.init()
        
        msg = .msg => attributes
        status_code = .status_code => attributes
        is_user_exist = .is_user_exist => attributes
        access_token = .access_token => attributes
        isnewuser = .isnewuser => attributes
        profile = try Profile(attributes: .profile =< attributes)
    }
    
    override init() {
        super.init()
    }
    
    
}
