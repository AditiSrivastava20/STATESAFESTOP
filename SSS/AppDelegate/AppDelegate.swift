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
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID
import ISMessages
import EZSwiftExtensions


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //statusBar.backgroundColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
        
        UINavigationBar.appearance().tintColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
        
        //fabric and twitter
        Fabric.with([Crashlytics.self, Twitter.self])
        
        //facebook instance
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //GMS
        GMSPlacesClient.provideAPIKey("AIzaSyCAIQBZ8sU2UIN8j-j4s2_avEb7k-qzKsE")
        GMSServices.provideAPIKey("AIzaSyCAIQBZ8sU2UIN8j-j4s2_avEb7k-qzKsE")
        
        //IQ keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        //Register for remote notifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        //Firebase
        FIRApp.configure()
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
        LocationManager.sharedInstance.setupLocationManger()
        
        checkForSession()
        
        
        return true
    }
    
    func checkForSession() {
        
        if UserDataSingleton.sharedInstance.loggedInUser != nil {
            
            UIApplication.shared.keyWindow?.rootViewController = StoryboardScene.Main.initialViewController()
        }
        
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
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK - Push Notification Delegate
    
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            print("InstanceID token: \(refreshedToken)")
            
            
        }

        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        deviceTokenApi(FIRInstanceID.instanceID().token())
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    
    func deviceTokenApi(_ deviceToken: String?) {
        
        guard let user = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        
        APIManager.shared.request(with: LoginEndpoint.pushDeviceToken(accessToken: user.profile?.access_token, deviceToken: deviceToken)) { (response) in
            
            self.handle(response: response)
            
        }
        
    }
    
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(/value.msg)
            }
            
        case .failure(let str):
            print(/str)
        }
    }
    
    
    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        print("hello")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
//        UserDefaults.standard.set("1", forKey: "notification_tapped")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"), object: nil)
        
        
        //Show Notification in iOS 9.0
//        if #available(iOS 9.0, *) {
//            // use the feature only available in iOS 9
//            
//            let resultObject = NSDictionary(dictionary: userInfo)
//            print(resultObject)
//            
//            ISMessages.showCardAlert(withTitle: "State Safe Stop", message: "", duration: 0.2, hideOnSwipe: true, hideOnTap: true, alertType: .custom , alertPosition: .top, didHide: nil)
//            
//            ez.dispatchDelay(0.5, closure: {
//                ISMessages.hideAlert(animated: true)
//            })
//            
//        } else {
//            // or use some work around
//            
//            
//            
//        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,
                           UNNotificationPresentationOptions.sound,
                           UNNotificationPresentationOptions.badge])
    }
    

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //For production
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: .prod )
        
        //For Testing
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: .sandbox )
    }
    


}

