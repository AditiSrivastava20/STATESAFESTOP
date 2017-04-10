//
//  Alert.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit
import ISMessages
import EZSwiftExtensions

typealias AlertBlock = (_ success: AlertTag) -> ()

enum AlertTag {
    case done
    case yes
    case no
}

class Alerts: NSObject {
    
    static let shared = Alerts()
    
    func show(alert title : Alert , message : String , type : ISAlertType){
        
        ISMessages.showCardAlert(withTitle: title.rawValue, message: message, duration: 0.01, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
        
        ez.dispatchDelay(1.5, closure: {
            ISMessages.hideAlert(animated: true)
        })
    }
    
}
