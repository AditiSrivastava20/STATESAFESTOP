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

enum Alert : String{
    case success = "Success"
    case oops = "Oops Something went wrong !"
    case login = "Login Successfull"
    case signup = "Sign Up Successfull"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = "Error"
    case logout = "Logged out"
}

enum Device: String {
    case token = "iaudhikaskdfh"
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
