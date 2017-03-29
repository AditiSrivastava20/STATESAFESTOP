//
//  HTTPClient.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    
    func postRequestWithArray(withApi api : Router, array: [String]? , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ) {
        
        var params = api.parameters
        
        if api.route == APIConstants.removeFromSafelist {
            params?[Keys.safeUserIds.rawValue] = array
        } else if api.route == APIConstants.addToSafelist  {
            params?[Keys.contacts.rawValue] = array
        }
        
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
    
    
    func postRequestWithImages(withApi api : Router , image: UIImage? , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ) {
        
        guard let params = api.parameters else {failure("empty"); return}
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(params)
    
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            guard let imageData = UIImageJPEGRepresentation(image!, 0.5) else {
                return }
            
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            
            for (key, value) in params {
                
                let tempKey = value as? String ?? ""
                
                multipartFormData.append(tempKey.data(using: String.Encoding.utf8)!, withName: key)
               // multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: fullPath) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        success(data)
                    case .failure(let error):
                        failure(error.localizedDescription)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
}





