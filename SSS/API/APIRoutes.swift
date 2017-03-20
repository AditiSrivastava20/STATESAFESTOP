//
//  APIRoutes.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(parameters : JSON) -> AnyObject?
}

extension Sequence where Iterator.Element == Keys {
    
    func map(values: [String?]) -> OptionalDictionary {
        
        var params = [String : String]()
        
        for (index,element) in zip(self,values) {
            params[index.rawValue] = element
        }
        return params
        
    }
}
