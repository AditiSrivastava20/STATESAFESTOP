//
//  Validation.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation


import Foundation

enum Valid{
    case success
    case failure(Alert,String)
}

class Validation: NSObject {
    
    static let shared = Validation()
    
    func validate(login email : String? , password : String?) -> Valid {
        
        if (/email).isEmpty {
            return errorMsg(str: "Please enter your email id")
        }
        else if (/password).isEmpty{
            return errorMsg(str: "Please enter password")
        }
        return .success
    }
    
    func errorMsg(str : String) -> Valid{
        return .failure(.error,str)
    }
    
}
