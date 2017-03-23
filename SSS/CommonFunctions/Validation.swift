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
    
    func validate(signup fullname: String?, email: String?, password: String?, confirmPasswd: String?, fulladdress: String?, phoneNo: String?) -> Valid {
        
        if (/fullname).isEmpty {
            return errorMsg(str: "Enter fullname")
        }
        
//        if !(/fullname).isEmpty {
//            let name = (/fullname).trimmingCharacters(in: .whitespaces)
//            print(name)
//            let letters = CharacterSet.letters
//            for char in name.unicodeScalars {
//                if !letters.contains(char) {
//                    return errorMsg(str: "Invalid fullname")
//                }
//            }
//        }
        
        if (/email).isEmpty {
            return errorMsg(str: "Please enter email")
        }
        
        if !(/email).isEmpty {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: (/email)) {
                return errorMsg(str: "Invalid email")
            }
        }
        
        if (/password).isEmpty {
            return errorMsg(str: "Enter password")
        }
        
        if (/confirmPasswd).isEmpty {
            return errorMsg(str: "Enter confirm Password")
        }
        
        if !(/password).isEqual((/confirmPasswd)) {
            return errorMsg(str: "Password's don't match")
        }
        
        if (/fulladdress).isEmpty {
            return errorMsg(str: "Enter full address")
        }
        
        if (/phoneNo).isEmpty {
            return errorMsg(str: "Enter phone number")
        }
        
        if !(/phoneNo).isEmpty {
            let num = /phoneNo
            let numbers = CharacterSet.decimalDigits
            if String(num.characters[num.characters.startIndex]) == "0" {
                return errorMsg(str: "Invalid phone no")
            }
            if num.characters.count > 10 || num.characters.count < 10 {
                return errorMsg(str: "Invalid phone no")
            }
            for number in num.unicodeScalars {
                if !numbers.contains(number) {
                    return errorMsg(str: "Invalid phone no")
                }
            }
        }
        
        return .success
    }
    
    func errorMsg(str : String) -> Valid{
        return .failure(.error,str)
    }
    
}
