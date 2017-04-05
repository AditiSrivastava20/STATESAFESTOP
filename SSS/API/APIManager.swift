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
import EZSwiftExtensions


class APIManager : UIViewController , NVActivityIndicatorViewable{
    
    typealias Completion = (Response) -> ()
    static let shared = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    
    
    //MARK: Normal API (signin/login, pin setup, password setup, get recording list  etc)
    func request(with api : Router , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequest(withApi: api, success: {[weak self] (data) in
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
//            print(json)
            
            if api.route == APIConstants.login {
                
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
                
            } else {
                
                let responseType = StatusValidation(rawValue: json[APIConstants.statusCode].stringValue) ?? .failure
                if responseType == StatusValidation.success{
                    
                    let object : AnyObject?
                    object = api.handle(parameters: json)
                    completion(Response.success(object))
                    return
                } else if responseType == StatusValidation.tokenExpire {
                    completion(Response.failure(json[APIConstants.message].stringValue))
                    
                    ez.dispatchDelay(0.3, closure: {
                        LoginChecks.shared.exitFromMain()
                    })
                    
                }
                else{
                    completion(Response.failure(json[APIConstants.message].stringValue))
                }
                
            }
            
            }, failure: {[weak self] (message) in
                self?.stopAnimating()
                completion(Response.failure(message))
                
        })
    }
    
    //MARK: add and remove safelist
    func request(withArray api : Router, array: [String]? , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequestWithArray(withApi: api, array: array, success: {[weak self] (data) in
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
//            print(json)
            
            let responseType = StatusValidation(rawValue: json[APIConstants.statusCode].stringValue) ?? .failure
            if responseType == StatusValidation.success{
                
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                return
            } else if responseType == StatusValidation.tokenExpire {
                
                completion(Response.failure(json[APIConstants.message].stringValue))
                
                ez.dispatchDelay(0.3, closure: {
                    LoginChecks.shared.exitFromMain()
                })
            }
            else{
                completion(Response.failure(json[APIConstants.message].stringValue))
            }
            
            }, failure: {[weak self] (message) in
                self?.stopAnimating()
                completion(Response.failure(message))
                
        })
    }
    
    //MARK: - share other media request
    func request(withArrays api : Router, arrayOne: [String]?, arrayTwo: [String]? , completion : @escaping Completion) {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequestWithArray(withApi: api, arrayOne: arrayOne, arrayTwo: arrayTwo, success: {[weak self] (data) in
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            //            print(json)
            
            let responseType = StatusValidation(rawValue: json[APIConstants.statusCode].stringValue) ?? .failure
            if responseType == StatusValidation.success{
                
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                return
            } else if responseType == StatusValidation.tokenExpire {
                
                completion(Response.failure(json[APIConstants.message].stringValue))
                
                ez.dispatchDelay(0.3, closure: {
                    LoginChecks.shared.exitFromMain()
                })
            }
            else{
                completion(Response.failure(json[APIConstants.message].stringValue))
            }
            
            }, failure: {[weak self] (message) in
                self?.stopAnimating()
                completion(Response.failure(message))
                
        })
        
    }
    
    
    //MARK: multipart data API (signup, edit profile)
    func request(withImages api : Router , image : UIImage?  , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate, color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequestWithImages(withApi: api, image: image, success: {[weak self] (data) in
            
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
//            print(json)
            
            let responseType = StatusValidation(rawValue: json[APIConstants.statusCode].stringValue) ?? .failure
            
            switch responseType {
            case .success:
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                
            case .tokenExpire:
                completion(Response.failure(json[APIConstants.message].stringValue))
                
                ez.dispatchDelay(0.3, closure: {
                    LoginChecks.shared.exitFromMain()
                })
                
            case .failure( _):
                completion(Response.failure(json[APIConstants.message].stringValue))
            default : break
            }
            
            }, failure: {[weak self] (message) in
                
                self?.stopAnimating()
                completion(Response.failure(message))
        })
    }
    
    //MARK: APIManager for share media
    func request(withMedia api : Router , media: Data? , thumbnail : UIImage?  , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate, color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        httpClient.postRequestWithMedia(withApi: api, media: media, thumbnail: thumbnail, success: {[weak self] (data) in
            
            self?.stopAnimating()
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
//            print(json)
            
            let responseType = StatusValidation(rawValue: json[APIConstants.statusCode].stringValue) ?? .failure
            
            switch responseType {
            case .success:
                let object : AnyObject?
                object = api.handle(parameters: json)
                completion(Response.success(object))
                
            case .tokenExpire:
                completion(Response.failure(json[APIConstants.message].stringValue))
                
                ez.dispatchDelay(0.3, closure: {
                    LoginChecks.shared.exitFromMain()
                })
                
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
        case APIConstants.recordingsList : return false
        case APIConstants.complaintList : return false
        case APIConstants.addComplaint :  return true
        default: return true
        }
    }
    
}
