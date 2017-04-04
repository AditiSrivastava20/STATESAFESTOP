//
//  twitter.swift
//  SSS
//
//  Created by Sierra 4 on 04/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation

class TwitterResponse: NSObject {
    
    var id: String?
    var image_url: String?
    var name: String?
    var email: String?
    
    init(attributes: OptionalJSON) {
        super.init()
        
        id = .id => attributes
        name = .name => attributes
        image_url = .twitter_image_url => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}

