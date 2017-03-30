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
    
    required init(attributes: OptionalJSON) throws{
        super.init()
        
        id = .id => attributes
        name = .name => attributes
        image = .image => attributes
        unformatted_phone = .unformatted_phone => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}
