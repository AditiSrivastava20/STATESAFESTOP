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
    case editProfile(accessToken : String?, fullName : String?, address : String?, email :  String?, phone : String?)
    case checkExistEmailOrPhone(email: String?, phone: String?)
    case pinPassword(accessToken: String?, pinPassword: String?)
    case addSafelist(accessToken: String?)
    case removeSafeuser(accessToken: String?)
    case safelist(accessToken: String?)
    case recordingList(accessToken: String?)
    case complaintList(accessToken: String?)
    case addComplaint(accessToken: String?, title: String?, description: String?, media_id: String?)
    case shareMedia(accessToken: String?, media_type: String?)
    case shareLocation(accessToken: String?, locatiom_name: String?, latitude: String?, longitude: String?)
    case shareothermedia(accessToken: String?)
    case resetPin(accessToken: String?, pinPassword: String?)
    case changePassword(accessToken: String?, old_password: String?, new_password: String?)
    case logout(accessToken: String?)
    case forgotPassword(email: String?)
    case notification(accessToken: String?)
    
}


extension LoginEndpoint : Router{
    
    var route : String  {
        
        switch self {
            
        case .login(_): return APIConstants.login
        case .signup(_): return APIConstants.signup
        case .editProfile(_): return APIConstants.editProfile
        case .checkExistEmailOrPhone(_): return APIConstants.checkExistEmailOrPhone
        case .pinPassword(_): return APIConstants.pinPassword
        case .addSafelist(_): return APIConstants.addToSafelist
        case .removeSafeuser(_): return APIConstants.removeFromSafelist
        case .safelist(_): return APIConstants.safelist
        case .recordingList(_): return APIConstants.recordingsList
        case .complaintList(_): return APIConstants.complaintList
        case .addComplaint(_): return APIConstants.addComplaint
        case .shareMedia(_): return APIConstants.shareMedia
        case .shareLocation(_): return APIConstants.shareLocation
        case .shareothermedia(_): return APIConstants.shareothermedia
        case .resetPin(_): return APIConstants.resetPin
        case .changePassword(_): return APIConstants.changePassword
        case .logout(_): return APIConstants.logout
        case .forgotPassword(_): return APIConstants.forgotPassword
        case .notification(_): return APIConstants.notification
            
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
        
        case .editProfile(let accessToken, let fullName, let address, let email, let phone):
            return Parameters.editProfile.map(values: [accessToken, fullName, address, email, phone])
        
        case .checkExistEmailOrPhone(let email, let phone):
            return Parameters.checkExistEmailOrPhone.map(values: [email, phone])
            
        case .pinPassword(let accessToken, let pinPassword):
            return Parameters.pinPassword.map(values: [accessToken, pinPassword])
        
        case .addSafelist(let accessToken):
            return Parameters.addSafelist.map(values: [accessToken])
            
        case .removeSafeuser(let accessToken):
            return Parameters.removeSafeUser.map(values: [accessToken])
        
        case .safelist(let accessToken):
            return Parameters.safelist.map(values: [accessToken])
            
        case .recordingList(let accessToken):
            return Parameters.recordingList.map(values: [accessToken])
            
        case .complaintList(let accessToken):
            return Parameters.complaintList.map(values: [accessToken])
            
        case .addComplaint(let accessToken, let title, let description, let media_id):
            return Parameters.addComplaint.map(values: [accessToken, title, description, media_id])
        
        case .shareMedia(let accessToken, let media_type):
            return Parameters.shareMedia.map(values: [accessToken, media_type])
        
        case .shareLocation(let accessToken, let location_name, let latitude, let longitude):
            return Parameters.shareLocation.map(values: [accessToken, location_name, latitude, longitude])
            
        case .shareothermedia(let accessToken):
            return Parameters.shareothermedia.map(values: [accessToken])
            
        case .resetPin(let accessToken, let pinPassword):
            return Parameters.resetPin.map(values: [accessToken, pinPassword])
        
        case .changePassword(let accessToken, let old_password, let new_password):
            return Parameters.changePassword.map(values: [accessToken, old_password, new_password])
            
        case .logout(let accessToken):
            return Parameters.logout.map(values: [accessToken])
            
        case .forgotPassword(let email):
            return Parameters.forgotPassword.map(values: [email])
            
        case .notification(let accessToken):
            return Parameters.notification.map(values: [accessToken])
    
        
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



