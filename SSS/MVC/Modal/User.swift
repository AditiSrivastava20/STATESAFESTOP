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
    var complaints: [Complaint]?
    var recordings: [Recording]?
    var contacts: [Safelist]?
    
    required init(attributes: OptionalJSON) throws{
        super.init()
        
        msg = .msg => attributes
        status_code = .status_code => attributes
        is_user_exist = .is_user_exist => attributes
        access_token = .access_token => attributes
        isnewuser = .isnewuser => attributes
        profile = try Profile(attributes: .profile =< attributes)
        
        let arrayComplaints = User.parseComplaintArrayToModal(withAttributes : .complaints =| attributes) as? [Complaint]
        complaints = arrayComplaints
        
        let arrayRecordings = User.parseRecordingArrayToModal(withAttributes : .recordings =| attributes) as? [Recording]
        recordings = arrayRecordings
        
        let arraySafelist = User.parseSafelistArrayToModal(withAttributes: .contacts =| attributes) as? [Safelist]
        contacts = arraySafelist
        
    }
    
    override init() {
        super.init()
    }
    
    class func parseComplaintArrayToModal(withAttributes attributes : [JSON]?) -> AnyObject? {
        
        var arrayComplaints: [Complaint] = []
        
        guard let attri = attributes else {
            return nil
        }
        
        for dict in attri {
            
            do {
                let item = try Complaint(attributes: dict.dictionaryValue)
                arrayComplaints.append(item)
            } catch _ {
            }
        }
        
        return arrayComplaints as AnyObject?
        
    }
    
    class func parseRecordingArrayToModal(withAttributes attributes : [JSON]?) -> AnyObject? {
        
        var arrayRecordings: [Recording] = []
        
        guard let attri = attributes else {
            return nil
        }
        
        for dict in attri {
            
            do {
                let item = try Recording(attributes: dict.dictionaryValue)
                arrayRecordings.append(item)
            } catch _ {
            }
        }
        
        return arrayRecordings as AnyObject?
        
    }
    
    class func parseSafelistArrayToModal(withAttributes attributes : [JSON]?) -> AnyObject? {
        
        var arraySafelist: [Safelist] = []
        
        guard let attri = attributes else {
            return nil
        }
        
        for dict in attri {
            
            do {
                let item = try Safelist(attributes: dict.dictionaryValue)
                arraySafelist.append(item)
            } catch _ {
            }
        }
        
        return arraySafelist as AnyObject?
        
    }
    
    
}
