//
//  Notification.swift
//  SSS
//
//  Created by Sierra 4 on 06/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import SwiftyJSON


class NotificationData: NSObject {
    
    var media_content: String?
    var thumbnail_url: String?
    var username: String?
    var media_type: String?
    var message: String?
    var created_at: String?
    
    init(attributes: OptionalJSON) {
        super.init()
        
        media_content = .media_content => attributes
        thumbnail_url = .thumbnail_url => attributes
        username = .username => attributes
        media_type = .media_type => attributes
        message = .message => attributes
        created_at = .created_at => attributes
        
    }
    
    override init() {
        super.init()
    }

    
    
}
