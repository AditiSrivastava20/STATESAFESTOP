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
    var pin_password: String?
    var complaints: [Complaint]?
    var recordings: [Recording]?
    var contacts: [Safelist]?
    
     init(attributes: OptionalJSON) {
        super.init()
        
        msg = .msg => attributes
        status_code = .status_code => attributes
        is_user_exist = .is_user_exist => attributes
        access_token = .access_token => attributes
        isnewuser = .isnewuser => attributes
        pin_password = .pin_password => attributes
        profile =  Profile(attributes: .profile =< attributes)
        
        complaints = []
        (.complaints =| attributes)?.forEach({ (_,element) in
            self.complaints?.append(Complaint(attributes: element.dictionaryValue))
        })
        
        recordings = []
        (.recordings =| attributes)?.forEach({ (_,element) in
            self.recordings?.append(Recording(attributes: element.dictionaryValue))
        })
    
        contacts = []
        (.contacts =| attributes)?.forEach({ (_,element) in
            self.contacts?.append(Safelist(attributes: element.dictionaryValue))
        })
        
    }
    
    override init() {
        super.init()
    }
        
}
