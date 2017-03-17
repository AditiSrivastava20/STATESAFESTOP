//
//  MaterialButton.swift
//  SSS
//
//  Created by Sierra 4 on 17/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit
import Material

class MaterialButton {
    
    static let shared = MaterialButton()
    
    func btn() -> Button {
        let button = Button(type: .custom)
        button.pulse()
        button.pulseColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.layer.cornerRadius = 25
        return button
    }
    
}
