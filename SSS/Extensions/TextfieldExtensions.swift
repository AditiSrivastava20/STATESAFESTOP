//
//  TextfieldExtensions.swift
//  SSS
//
//  Created by Sierra 4 on 21/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import Material

extension TextField {
    
    func placeHolderAtt() {
        self.dividerActiveColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.12)
        self.placeholderNormalColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.55)
        self.placeholderActiveColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.55)
        self.placeholderLabel.font = UIFont(name: FontFamily.HelveticaNeue.regular.rawValue, size: 12)
        self.font = UIFont(name: FontFamily.HelveticaNeue.regular.rawValue, size: 12)
        self.placeholderVerticalOffset = 6
    }
    
}
