//
//  ViewExtensions.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Foundation

protocol StringType { var get: String { get } }

extension String: StringType { var get: String { return self } }

extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}
