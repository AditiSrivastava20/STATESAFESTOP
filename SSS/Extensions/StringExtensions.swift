//
//  StringExtensions.swift
//  SSS
//
//  Created by Sierra 4 on 05/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
