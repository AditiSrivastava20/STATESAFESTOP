//
//  Location.swift
//  SSS
//
//  Created by Sierra 4 on 16/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import CoreLocation


class Location {
    
    static let shared = Location()
    
    func GPS() -> (lat: String,long: String) {
        let locManager = CLLocationManager()
        //locManager.requestWhenInUseAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ){
            
            currentLocation = locManager.location!
        }
        
        let currnetLat:String = currentLocation.coordinate.latitude.description
        let currentLong:String = currentLocation.coordinate.latitude.description
        
        return (currnetLat, currentLong)
    }
}
