//
//  APIConstants.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation

internal struct APIConstants {
    
    static let basePath = "http://35.167.142.176/api/users/"
    static let login = "login"
    static let signup = "signup"
    static let editProfile = "edit-profile"
    static let pinPassword = "set/pin-password"
    static let phoneNumber = "set/phone-number"
    static let forgotPassword = "forgot-password"
    static let checkExistEmailOrPhone = "checkexist-email-phone"
    static let readContacts = "readcontacts"
    static let addToSafelist = "addsafelist"
    static let removeFromSafelist = "removesafeuser"
    static let statusCode = "status_code"
    static let userExist = "is_user_exist"
    static let newUser = "isnewuser"
    static let message = "msg"
    static let completeProfile = "is_complete_profile"
    static let recordingsList = "recordingslist"
    static let complaintList = "complaintlist"
    static let addComplaint = "add-complaint"
    static let shareMedia = "sharemedia"
    
    
}

enum AccountType: String {
    
    case normal = "1"
    case facebook = "2"
    case twitter = "3"
    
}

enum Keys: String {
    
    //login
    case email = "email"
    case password = "password"
    case facebookId = "facebook_id"
    case twitterId = "twitter_id"
    case accountType = "account_type"
    case deviceToken = "device_token"
    
    //signup
    case fullName = "fullname"
    case address = "address"
    case phone = "phone"
    case image = "image"
    
    //edit profile
    case accessToken = "access_token"
    case profilePic = "profile_pic"
    
    //set pin password
    case pin = "pin_password"
    
    //set phone number
    
    //forgot password
    
    //check existing email and phone
    
    //read contacts
    case contacts = "contacts" //array of phone numbers
    
    //add to safelist
    
    //remove from safelist
    case safeUserIds = "safe_user_ids"
    
    //recording list
    
    //complaint list
    
    //add complaint
    case title = "title"
    case description = "description"
    case media_id = "media_id"
    
    //share media_id
    case media = "media"
    case media_type = "media_type"
    case thumbnail = "thumbnail_url"
    
}

enum Validate: String {
    
    case none
    case success = "1"
    case failure = "0"
    
    func map(response message: String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure:
            return message
        default:
            return message
        }
    }
}

enum StatusValidation: String {
    
    case none
    case success = "200"
    case failure = "400"
    
    func map(response message: String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure:
            return message
        default:
            return message
        }
    }
}

enum Safeusers {
    case add
    case remove
}

enum SocialCheck: String {
    case login = "login"
    case signup = "signup"
}


enum Response {
    case success(AnyObject?)
    case failure(String?)
}

enum MediaType: String {
    case audio = "audio"
    case video = "video"
    case none
    
}


typealias OptionalDictionary = [String: Any]?

struct Parameters {
    
    static let login: [Keys] = [.email, .password, .facebookId, .twitterId, .accountType, .deviceToken]
    static let signup: [Keys] = [.fullName, .email, .address, .password, .facebookId, .twitterId, .phone, .accountType, .deviceToken]
    static let editProfile: [Keys] = [.accessToken, .fullName, .address, .email, .phone, .profilePic]
    static let pinPassword: [Keys] = [.accessToken, .pin]
    static let phoneNumber: [Keys] = [.accessToken, .phone]
    static let forgotPassword: [Keys] = [.email]
    static let checkExistEmailOrPhone: [Keys] = [.email, .phone]
    static let readContacts: [Keys] = [.accessToken]
    static let addSafelist: [Keys] = [.accessToken, .contacts]
    static let removeSafeUser: [Keys] = [.accessToken, .safeUserIds]
    static let recordingList: [Keys] = [.accessToken]
    static let complaintList: [Keys] = [.accessToken]
    static let addComplaint: [Keys] = [.accessToken, .title, .description, .media_id]
    static let shareMedia: [Keys] = [.accessToken, .media_type]
}







