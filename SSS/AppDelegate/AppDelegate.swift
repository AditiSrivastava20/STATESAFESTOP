//
//  AppDelegate.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import TwitterKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //statusBar.backgroundColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
        
        //fabric and twitter
        Fabric.with([Crashlytics.self, Twitter.self])
        
        //facebook instance
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //GMS
        GMSPlacesClient.provideAPIKey("AIzaSyCAIQBZ8sU2UIN8j-j4s2_avEb7k-qzKsE")
        GMSServices.provideAPIKey("AIzaSyCAIQBZ8sU2UIN8j-j4s2_avEb7k-qzKsE")
        
        //IQ keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

