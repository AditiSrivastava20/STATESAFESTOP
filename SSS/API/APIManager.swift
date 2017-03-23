//
//  APIManager.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import SwiftyJSON
import NVActivityIndicatorView


class APIManager : UIViewController , NVActivityIndicatorViewable{
    
    typealias Completion = (Response) -> ()
    static let shared = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    func request(with api : Router , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .lineScalePulseOutRapid , color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequest(withApi: api, success: {[weak self] (data) in
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
            let responseType = Validate(rawValue: json[APIConstants.userExist].stringValue) ?? .failure
            if responseType == Validate.success{
                
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                
                return
            }
            else{ 
                completion(Response.failure(json[APIConstants.message].stringValue))
            
            }
            
            }, failure: {[weak self] (message) in
                self?.stopAnimating()
                completion(Response.failure(message))
                
        })
    }
    
    func request(withImages api : Router , image : UIImage?  , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .lineScalePulseOutRapid, color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequestWithImages(withApi: api, image: image, success: {[weak self] (data) in
            
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
            let responseType = SignUpValidation(rawValue: json[APIConstants.success].stringValue) ?? .failure
            
            switch responseType {
            case .success:
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                
            case .failure( _):
                completion(Response.failure(json[APIConstants.message].stringValue))
            default : break
            }
            
            }, failure: {[weak self] (message) in
                
                self?.stopAnimating()
                completion(Response.failure(message))
        })
    }
    
    
    
    
    func isLoaderNeeded(api : Router) -> Bool{
        
        switch api.route {
        case APIConstants.login : return true
        default: return true
        }
    }
    
}
