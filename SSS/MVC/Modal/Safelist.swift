//
//  Safelist.swift
//  SSS
//
//  Created by Sierra 4 on 28/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation

class Safelist: NSObject {
    
    var phone: String?
    var id: String?
    var image: String?
    var email: String?
    var fullname: String?
    var isSelected : Int = 0
    
    required init(attributes: OptionalJSON) throws{
        super.init()
        
        email = .email => attributes
        fullname = .fullname => attributes
        id = .id => attributes
        email = .email => attributes
        phone = .phone => attributes
        
    }
    
    override init() {
        super.init()
    }
    
    
}
