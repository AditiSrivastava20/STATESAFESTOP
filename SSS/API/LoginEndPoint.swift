//
//  LoginEndPoint.swift
//  SSS
//
//  Created by Sierra 4 on 16/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//


import UIKit
import Alamofire

enum LoginEndpoint {
    
    case login(email : String? , password : String?, facebookId: String?, twitterId: String?, accountType: String?, deviceToken: String?)
    case signup(fullname : String? , email : String?, fullAddress: String?, password: String? , facebookId: String?, twitterId: String?, phone: String?, accountType: String?, deviceToken: String?, image: String?)
    
}


extension LoginEndpoint : Router{
    
    var route : String  {
        
        switch self {
            
        case .login(_): return APIConstants.login
        case .signup(_): return APIConstants.signup
            
        }
    }
    
    var parameters: OptionalDictionary{
        return format()
    }
    
    
    func format() -> OptionalDictionary {
        
        switch self {
            
        case .login(let email , let password, let facebookId, let twitterId, let accountType, let deviceToken):
            return Parameters.login.map(values: [email, password, facebookId, twitterId, accountType, deviceToken])
            
        case .signup(let fullname, let email, let password, let facebookId, let twitterId, let accountType, let phone, let fullAddress, let deviceToken, let image):
            return Parameters.signup.map(values: [fullname , email , password , facebookId, twitterId, accountType , phone , fullAddress , deviceToken, image])
            
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var baseURL: String{
        return APIConstants.basePath
    }
    
}



