 //
//  LocationManager.swift
//  Glam360
//
//  Created by cbl16 on 6/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import CoreLocation

struct Location : CustomStringConvertible {
    
    
    
    var current_lat : String?
    var current_lng : String?
    var current_formattedAddr : String?
    var current_city : String?
    
    var description: String{
        return self.appendOptionalStrings(withArray: [current_formattedAddr])
    }
    
    func appendOptionalStrings(withArray array : [String?]) -> String {
        
        return array.flatMap{$0}.joined(separator: " ")
    }
}

 
 typealias LocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ location:String)->())?
 
class LocationManager: NSObject  {
    
    
    static let sharedInstance : LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    
    override init() {
        
        
    }
    
    /* Private variables */
    fileprivate var completionHandler:LocationCompletionHandler
    
    
    var currentLocation : Location? = Location()
    let locationManager = CLLocationManager()
    
    func startTrackingUser(_ completionHandler:((_ latitude:Double, _ longitude:Double, _ location:String)->())? = nil){
        // For use in foreground
        
         self.completionHandler = completionHandler
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
    
    }
    
    func setupLocationManger() {
        
        
        
    }
    
}

 extension LocationManager : CLLocationManagerDelegate{
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let firstLocation = locations.first else{return}
        
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
       
        
        CLGeocoder().reverseGeocodeLocation(firstLocation) {[unowned self] (placemarks, error) in
            self.currentLocation?.current_lat = "\(firstLocation.coordinate.latitude)"
            self.currentLocation?.current_lng = "\(firstLocation.coordinate.longitude)"
            guard let bestPlacemark = placemarks?.first else{return}
            self.currentLocation?.current_city = bestPlacemark.locality
            self.currentLocation?.current_formattedAddr = self.appendOptionalStrings(withArray: [bestPlacemark.subThoroughfare , bestPlacemark.thoroughfare , bestPlacemark.locality , bestPlacemark.country])
            print(self.currentLocation?.current_formattedAddr ?? "")
            print(self.currentLocation?.current_city ?? "")
            if(self.completionHandler != nil){
                
                self.completionHandler?(firstLocation.coordinate.latitude, firstLocation.coordinate.longitude, (self.currentLocation?.current_formattedAddr)!)
            }
            
         
            
        
        
        }
        
    }
    
    func appendOptionalStrings(withArray array : [String?]) -> String {
        
        return array.flatMap{$0}.joined(separator: " ")
    }

}
