//
//  APIHandler.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import SwiftyJSON


extension LoginEndpoint {
    
    func handle(parameters : JSON) -> AnyObject? {
        
        switch self {
        default:
            return  User(attributes: parameters.dictionaryValue)
        }
        
    }
}



