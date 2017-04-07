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
    
    var id: String?
    var sender_name: String?
    var sender_image: String?
    var sender_id: String?
    var loc_name: String?
    var latitude: String?
    var longitude: String?
    var notification_message: String?
    var notification_type: String?
    var thumbnail_url: String?
    var media_type: String?
    var created_at: String?
    
    init(attributes: OptionalJSON) {
        super.init()
        
        id = .id => attributes
        sender_name = .sender_name => attributes
        sender_image = .sender_image => attributes
        sender_id = .sender_id => attributes
        loc_name = .loc_name => attributes
        latitude = .latitude => attributes
        longitude = .longitude => attributes
        notification_message = .notification_message => attributes
        notification_type = .notification_type => attributes
        thumbnail_url = .thumbnail_url => attributes
        media_type = .media_type => attributes
        created_at = .created_at => attributes
        
        
    }
    
    override init() {
        super.init()
    }

    
    
}
