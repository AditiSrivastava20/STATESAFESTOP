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
    static let alphabeticRegex = "^[a-zA-Z ]*$"
    
}


class Validation: NSObject {
    
    static let shared = Validation()
    
    //MARK: - login validation
    func validate(login email : String? , password : String?) -> Valid {
        
        if (/email).isEmpty {
            return errorMsg(str: "Please enter your email id")
        }
        else if (/password).isEmpty{
            return errorMsg(str: "Please enter password")
        }
        return .success
    }
    
    
    //MARK: - signup validation
    func validate(signup fullname: String?, email: String?, password: String?, confirmPasswd: String?, fulladdress: String?, phoneNo: String?, facebookID: String?, twitterID: String?) -> Valid {
        
        if !isValidName((/fullname)) {
            return errorMsg(str: "Enter fullname")
        }
        
        if (/email).isEmpty {
            return errorMsg(str: "Please enter email")
        }
        
        if !isValidEmail((/email)) {
            return errorMsg(str: "Invalid email")
        }
        
        if (/facebookID).isEmpty && (/twitterID).isEmpty {
            if !isValidPasswd(/password) {
                return errorMsg(str: "Enter valid password")
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
    
    //MARK: - pincode validation
    func validate(pinCode value: String?) -> Valid {
        
        if ((/value).characters.count) < 4 {
            return errorMsg(str: "Fill all four fields")
        }
        
        return .success
    }
    
    //MARK: - add complaint validation
    func validate(complaint title: String?, description: String?) -> Valid {
        
        if (/title).isEmpty {
            return errorMsg(str: "Enter complaint title")
        }
        
        if (/description).isEmpty {
            return errorMsg(str: "Enter complaint description")
        }
        
        return .success
    }
    
    //MARK: - edit profile validation
    func validate(edit fullname: String?, address: String?, phone: String?) -> Valid {
        
        if (/fullname).isEmpty {
            return errorMsg(str: "Enter name")
        }
        
        if (/address).isEmpty {
            return errorMsg(str: "Enter address")
        }
        
        if !isValidPhone((/phone)) {
            return errorMsg(str: "Enter valid phone number")
        }
        
        return .success
        
    }
    
    //MARK: - change password
    func validate(changePassword old: String?, new: String?, confirm: String?) -> Valid {
        
        if !isValidPasswd(/old) {
            return errorMsg(str: "Enter valid Password")
        }
        
        if !isValidPasswd(/new) {
            return errorMsg(str: "Enter valid new Password")
        }
        
        if !(/confirm).isEqual(/new) {
            return errorMsg(str: "New and Confirm Passwords do not match")
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
//        for char in testStr.characters {
//            if !(char <= "Z") && !(char >= "A") {
//                return false
//            } else if !(char <= "z") && !(char >= "a") {
//                return false
//            }
//        }
//        return true
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", RegexExpresssions.alphabeticRegex)
        return nameTest.evaluate(with: testStr)
    }
    
    func errorMsg(str : String) -> Valid{
        return .failure(.error,str)
    }
    
}




