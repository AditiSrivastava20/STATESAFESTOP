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
    case signup(fullname : String? , email : String?, fullAddress: String?, password: String? , facebookId: String?, twitterId: String?, phone: String?, accountType: String?, deviceToken: String?)
    case checkExistEmailOrPhone(email: String?, phone: String?)
    case pinPassword(accessToken: String?, pinPassword: String?)
    case addSafelist(accessToken: String?)
    case removeSafeuser(accessToken: String?)
    
}


extension LoginEndpoint : Router{
    
    var route : String  {
        
        switch self {
            
        case .login(_): return APIConstants.login
        case .signup(_): return APIConstants.signup
        case .checkExistEmailOrPhone(_): return APIConstants.checkExistEmailOrPhone
        case .pinPassword(_): return APIConstants.pinPassword
        case .addSafelist(_): return APIConstants.addToSafelist
        case .removeSafeuser(_): return APIConstants.removeFromSafelist
            
        }
    }
    
    var parameters: OptionalDictionary{
        return format()
    }
    
    
    func format() -> OptionalDictionary {
        
        switch self {
            
        case .login(let email , let password, let facebookId, let twitterId, let accountType, let deviceToken):
            return Parameters.login.map(values: [email, password, facebookId, twitterId, accountType, deviceToken])
            
        case .signup(let fullname, let email, let fullAddress, let password, let facebookId, let twitterId, let phone, let accountType,  let deviceToken):
            return Parameters.signup.map(values: [fullname , email , fullAddress , password , facebookId, twitterId, phone , accountType ,   deviceToken])
        
        case .checkExistEmailOrPhone(let email, let phone):
            return Parameters.checkExistEmailOrPhone.map(values: [email, phone])
            
        case .pinPassword(let accessToken, let pinPassword):
            return Parameters.pinPassword.map(values: [accessToken, pinPassword])
        
        case .addSafelist(let accessToken):
            return Parameters.addSafelist.map(values: [accessToken])
            
        case .removeSafeuser(let accessToken):
            return Parameters.removeSafeUser.map(values: [accessToken])
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



