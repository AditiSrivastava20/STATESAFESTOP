//
//  SSSPackageViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import SwiftyStoreKit
import NVActivityIndicatorView
import EZSwiftExtensions

class SSSPackageViewController: BaseViewController, FBSDKAppInviteDialogDelegate, NVActivityIndicatorViewable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: In App purchase action
    @IBAction func btnInAppPurchaseAction(_ sender: Any) {
        
        
        let actionSheetController = UIAlertController(title: "Subscription", message: "Are you sure you want to subscribe to State safe stop for 99¢ ", preferredStyle: .alert)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        

        let shareActionButton = UIAlertAction(title: "Accept", style: .default) { action -> Void in
                print("Accept")
            self.pay()
        }
        actionSheetController.addAction(shareActionButton)
        
        
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    
    func pay() {
        self.startAnimating()
        
        ez.dispatchDelay(3) {
            self.stopAnimating()
        }
        
        
        
        SwiftyStoreKit.purchaseProduct("statesafestop99", atomically: true) { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                self.present(StoryboardScene.Main.initialViewController() , animated: false, completion: nil)
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                default:break
                }
                
            }
        }

        
    }
    
    override func appTerminated() {
        UserDataSingleton.sharedInstance.loggedInUser = nil
    }
    
    
    //MARK: App invite button action
    @IBAction func btnAppInviteAction(_ sender: Any) {
        print("Invite button tapped")
        
        FBManager.shared.login(self, check: .login , graphRequest: .me, completion: {(count) in
            
            let value = count as? Int
            
            self.appInviteAction()
            
//            if value! < 10 {
//                Alerts.shared.show(alert: .oops, message: Alert.friendsErr.rawValue, type: .error)
//            } else {
//                self.appInviteAction()
//            }
        })
        
    }
    
    
    //MARK: Generate App invite dialog
    func appInviteAction() {
        
        let inviteDialog:FBSDKAppInviteDialog = FBSDKAppInviteDialog()
        if(inviteDialog.canShow()){
            
            let appLinkUrl:NSURL = NSURL(string: FacebookInvite.app_link_url)!
            let previewImageUrl:NSURL = NSURL(string: FacebookInvite.image_url)!
            
            let inviteContent:FBSDKAppInviteContent = FBSDKAppInviteContent()
            inviteContent.appLinkURL = appLinkUrl as URL!
            inviteContent.appInvitePreviewImageURL = previewImageUrl as URL!
            
            inviteDialog.content = inviteContent
            inviteDialog.delegate = self
            inviteDialog.show()
        }
    }
    
    //MARK: - Facebook app invite delegate
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        guard let _ = results else {
            return
        }
        
        let resultObject = NSDictionary(dictionary: results)
        
        if let didCancel = resultObject.value(forKey: "completionGesture")
        {
            if (didCancel as AnyObject).caseInsensitiveCompare("Cancel") == ComparisonResult.orderedSame
            {
                print("User Canceled invitation dialog")
            }
        } else {
            print("invite sent")
           self.present(StoryboardScene.Main.initialViewController() , animated: false, completion: nil)
        }
    }
    
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Error tool place in appInviteDialog \(error)")
    }

}
