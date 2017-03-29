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
    
    
    func color() -> UIColor {
        return UIColor(hexString: self.rawValue)!
    }
}









enum userPrefrences : String{
    
    case aybizUserProfile = "aybizUserProfile"
    case aybizUserHome = "aybizUserHome"
    case aybizUserSearch = "aybizUserSearch"
    case aybizCategory = "aybizCategory"
    case aybizLangId = "aybizLangId"
    case aybizCurrentLang = "aybizCurrentLang"
}








enum Alert : String{
    case success = "Success"
    case oops = "Oops Something went wrong !"
    case login = "Login Successfull"
    case signup = "Sign Up Successfull"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = "Error"
    case logout = "Logged out"
    case friendsErr = "Number of friends less than 10"
}

enum Device: String {
    case token = "iaudhikaskdfh"
}

enum segue: String {
    
    case loginToMain = "loginToMain"
    case loginToSignup = "loginToSignup"
    case loginToPin = "loginToPin"
    case loginToPackage = "loginToPackage"
    case signupToPin = "singupToPin"
    case pinToPackage = "pinToPackage"
    case packageToInAppPurchase = "packageToInAppPurchase"
    
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
