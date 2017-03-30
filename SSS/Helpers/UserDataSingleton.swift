//
//  SDataSingleton.swift
//  Glam360
//
//  Created by cbl16 on 7/5/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import RMMapper

class UserDataSingleton {
        
    static let sharedInstance : UserDataSingleton = {
        let instance = UserDataSingleton()
        return instance
    }()
    
    
    init() {
        
    }
    
    
    //user data
    
        var loggedInUser : User?{
            get{
                var user : User?
                if let data = UserDefaults.standard.rm_customObject(forKey: userPrefrences.aybizUserProfile.rawValue) as? User{
                    user = data
                }
                return user
            }
            set{
                let defaults = UserDefaults.standard
                if let value = newValue{
                    defaults.rm_setCustomObject(value, forKey: userPrefrences.aybizUserProfile.rawValue)
                }
                else{
                    defaults.removeObject(forKey: userPrefrences.aybizUserProfile.rawValue)
                }
            }
    }


}

