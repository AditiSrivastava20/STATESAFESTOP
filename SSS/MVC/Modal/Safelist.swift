//
//  Safelist.swift
//  SSS
//
//  Created by Sierra 4 on 28/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation

class Safelist: NSObject {
    
    var id: String?
    var unformatted_phone: String?
    var image: String?
    var name: String?
    var isSelected : Int = 0
    
     init(attributes: OptionalJSON) {
        super.init()
        
        id = .id => attributes
        name = .fullname => attributes
        image = .image => attributes
        unformatted_phone = .unformatted_phone => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}
