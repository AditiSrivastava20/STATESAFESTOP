//
//  Complaint.swift
//  SSS
//
//  Created by Sierra 4 on 29/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation



class Complaint: NSObject {
    
    var title: String?
    var complaintDescription: String?
    var created_at: String?
    var fullname: String?
    var email: String?
    var media_content: String?
    
     init(attributes: OptionalJSON) {
        super.init()
        
        title = .title => attributes
        complaintDescription = .complaintDescription => attributes
        created_at = .created_at => attributes
        fullname = .fullname => attributes
        email = .email => attributes
        media_content = .media_content => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}
