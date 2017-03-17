//
//  APIConstants.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation

internal struct APIConstants {
    
    static let basePath = "http://192.168.100.37:8000/api/"
    static let login = "users/login"
    static let signup = "users/signup"
    static let editProfile = "users/edit-profile"
    static let status = "success"
    static let userExist = "is_user_exist"
    static let message = "msg"
    
}

enum Keys: String {
    
    //login
    case email = "email"
    case pasword = "password"
    case facebookId = "facebook_id"
    case twitterId = "twitter_id"
    
    
}








