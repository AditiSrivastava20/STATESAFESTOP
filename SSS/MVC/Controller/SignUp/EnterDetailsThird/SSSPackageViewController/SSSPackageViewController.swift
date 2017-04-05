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


class SSSPackageViewController: BaseViewController, FBSDKAppInviteDialogDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: In App purchase action
    @IBAction func btnInAppPurchaseAction(_ sender: Any) {
        
    }
    
    override func appTerminated() {
        UserDataSingleton.sharedInstance.loggedInUser = nil
    }
    
    
    //MARK: App invite button action
    @IBAction func btnAppInviteAction(_ sender: Any) {
        print("Invite button tapped")
        
        FBManager.shared.login(self, check: .login , graphRequest: .friends, completion: {(count) in
            
            let value = count as? Int
            
            if value! < 10 {
                Alerts.shared.show(alert: .oops, message: Alert.friendsErr.rawValue, type: .error)
            } else {
                self.appInviteAction()
            }
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
