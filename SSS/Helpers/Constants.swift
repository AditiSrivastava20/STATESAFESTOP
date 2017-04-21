//
//  Constants.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import EZSwiftExtensions


import UIKit

enum fontSize : CGFloat {
    case small = 12.0
    case medium = 14.0
    case large = 16.0
    case xLarge = 18.0
    case xXLarge = 20.0
    case xXXLarge = 32.0
}

enum fonts {
    
    enum Gotham : String {
        case regular = "Gotham-Book"
        case bold = "Gotham-Bold"
        case medium = "Gotham-Medium"
        
        func font(_ size : fontSize) -> UIFont {
            return UIFont(name: self.rawValue, size: size.rawValue)!
        }
    }
}


enum colors : String {
    
    case mainLabelColor = "0x4B4B4B"
    case appColor = "0xFDDC2F"
    case sepratorColor = "0xBABABA"
    case loaderColor = "0xF3DC2F"
    
    func color() -> UIColor {
        return UIColor(hexString: self.rawValue)!
    }
}


enum userPrefrences : String{
    
    case aybizUserProfile = "SSSUserProfile"

}

enum permissions: String {
    
    case location = "Permission for \'Location when in use\' not granted"
    case microphone = "This App does not have access to your microphone"
    case camera = "This App does not have access to your camera"

}



enum Alert : String{
    case alert = "Alert"
    case success = "Success"
    case oops = ""
    case login = "Login Successfull"
    case signup = "Sign Up Successfull"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = " "
    case incorrectPin = "Incorrect Pin"
    case noPinEntered = "No pin entered"
    case logout = "Logged out"
    case friendsErr = "Number of friends less than 10"
    case shared = "Shared successfully"
    case tokenExp = "Token expired"
    case invitesRequired = "more Invites were Required"
}

enum MobileDevice: String {
    case token = "iaudhikaskdfh"
}

enum segues: String {
    
    case loginToMain = "loginToMain"
    case loginToSignup = "loginToSignup"
    case signupToPin = "signupToPin"
    case pinToPackage = "pinToPackage"
    case settingsToResetPin = "settingsToResetPin"
    case loginToForgotPassword = "loginToForgotPassword"
    
}



infix operator =>
infix operator =|
infix operator =<

typealias OptionalJSON = [String : JSON]?

func =>(key : ParamKeys, json : OptionalJSON) -> String?{
    return json?[key.rawValue]?.stringValue
}

func =<(key : ParamKeys, json : OptionalJSON) -> [String : JSON]?{
    return json?[key.rawValue]?.dictionaryValue
}

func =|(key : ParamKeys, json : OptionalJSON) -> [JSON]?{
    return json?[key.rawValue]?.arrayValue
}

prefix operator /
prefix func /(value : String?) -> String {
    return value.unwrap()
}
