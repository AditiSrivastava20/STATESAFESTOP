//
//  HTTPClient.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpClientSuccess = (Any?) -> ()
typealias HttpClientFailure = (String) -> ()

class HTTPClient {
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : Router  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        
        let params = api.parameters!
        let fullPath = api.baseURL + api.route
        let method = api.method
        print(fullPath)
        print(params)
        Alamofire.request(fullPath, method: method, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
    
}

