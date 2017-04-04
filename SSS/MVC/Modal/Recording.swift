//
//  Recording.swift
//  SSS
//
//  Created by Sierra 4 on 29/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation


class Recording: NSObject {
    
    var id: String?
    var thumbnail_url: String?
    var media_content: String?
    var media_type: String?
    var isSelected : Int = 0
    
     init(attributes: OptionalJSON) {
        super.init()
        
        id = .id => attributes
        thumbnail_url = .thumbnail_url => attributes
        media_content = .media_content => attributes
        media_type = .media_type => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}
