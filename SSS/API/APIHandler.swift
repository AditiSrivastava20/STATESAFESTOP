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
        case .login(_),.signup(_),.pinPassword(_),.checkExistEmailOrPhone(_):
            
            do {
                return try User(attributes: parameters.dictionaryValue )
            } catch _ { return nil }
        
        }
    }
}
