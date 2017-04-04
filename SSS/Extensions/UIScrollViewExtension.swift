//
//  UIScrollViewExtension.swift
//  SSS
//
//  Created by Sierra 4 on 04/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
