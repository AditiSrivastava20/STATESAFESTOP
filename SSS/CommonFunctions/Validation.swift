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

internal struct RegexExpresssions {
    
    static let EmailRegex = "[A-Z0-9a-z._%+-]{1,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    static let PasswordRegex = "[A-Za-z0-9]{6,20}"
    static let PhoneRegex = "[0-9]{6,14}"
    
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
    
    func validate(signup fullname: String?, email: String?, password: String?, confirmPasswd: String?, fulladdress: String?, phoneNo: String?, facebookID: String?, twitterID: String?) -> Valid {
        
        if (/fullname).isEmpty {
            return errorMsg(str: "Enter fullname")
        }
        
        if (/email).isEmpty {
            return errorMsg(str: "Please enter email")
        }
        
        if !isValidEmail((/email)) {
            return errorMsg(str: "Invalid email")
        }
        
        if (/facebookID).isEmpty && (/twitterID).isEmpty {
            if (/password).isEmpty {
                return errorMsg(str: "Enter password")
            }
            
            if (/password).characters.count <= 7 {
                return errorMsg(str: "Password should be atleast 8 characters long")
            }
            
            if (/confirmPasswd).isEmpty {
                return errorMsg(str: "Enter confirm Password")
            }
            
            if !(/password).isEqual((/confirmPasswd)) {
                return errorMsg(str: "Password's don't match")
            }
        }
        
        if (/fulladdress).isEmpty {
            return errorMsg(str: "Enter full address")
        }
        
        if (/phoneNo).isEmpty {
            return errorMsg(str: "Enter phone number")
        }
        
        if !isValidPhone((/phoneNo)) {
            return errorMsg(str: "Invalid phone number")
        }
        
        return .success
    }
    
    func validate(pinCode value: String?) -> Valid {
        
        if ((/value).characters.count) < 4 {
            return errorMsg(str: "Fill all four fields")
        }
        
        return .success
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.EmailRegex)
        return emailTest.evaluate(with: testStr)
    }

    func isValidPhone(_ testStr:String) -> Bool {
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.PhoneRegex)
        return phoneTest.evaluate(with: testStr)
    }
    
    func isValidPasswd(_ testStr:String) -> Bool {
        let passwdTest = NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.PasswordRegex)
        return passwdTest.evaluate(with: testStr)
    }
    
    func isValidName(_ testStr:String) -> Bool {
        for char in testStr.characters {
            if !(char <= "Z") && !(char >= "A") {
                return false
            } else if !(char <= "z") && !(char >= "a") {
                return false
            }
        }
        return true
    }
    
    func errorMsg(str : String) -> Valid{
        return .failure(.error,str)
    }
    
}




