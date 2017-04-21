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

class SSSPackageViewController: BaseViewController, FBSDKGameRequestDialogDelegate , NVActivityIndicatorViewable {
    

    var totalInvitesSent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func appTerminated() {
        UserDataSingleton.sharedInstance.loggedInUser = nil
    }
    
    //MARK: - Invite Status Api
    func InviteStatusApi(check: InviteStatus) {
        
        guard let user = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        Loader.shared.start()
        
        APIManager.shared.request(with: LoginEndpoint.inviteStatus(accessToken: user.profile?.access_token, deviceToken: check.status()), completion: {(response) in
            
            Loader.shared.stop()
            
            HandleResponse.shared.handle(response: response, self, from: .sssPackage , param: nil)
            
        })
    }
    
    
    //MARK: In App purchase button action
    @IBAction func btnInAppPurchaseAction(_ sender: Any) {
        
        
        let actionSheetController = UIAlertController(title: "Subscription", message: "Are you sure you want to subscribe to State safe stop for ¢99 ?", preferredStyle: .alert)
        
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
    
    //MARK: Purchase product action
    func pay() {
        Loader.shared.start()
        
        ez.dispatchDelay(3) {
            Loader.shared.stop()
        }
        
        SwiftyStoreKit.purchaseProduct("com.statesafestop.product99", atomically: true) { result in
            Loader.shared.start()
            
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                Loader.shared.stop()
                
                self.InviteStatusApi(check: .pay )
                
            case .error(let error):
                
                Loader.shared.stop()
                print(error.localizedDescription)
                Alerts.shared.show(alert: .alert, message: /error.localizedDescription, type: .error)
                
            }
        }

        
    }
    
    
    //MARK: App invite button action
    @IBAction func btnAppInviteAction(_ sender: Any) {
        print("Invite button tapped")
        
        FBManager.shared.login(self, check: .login , graphRequest: .friends , completion: {(count) in
            
            _ = count as? Int
            
            self.appInviteAction()
            
        })
        
    }
    
    
    //MARK: Generate App invite dialog
    func appInviteAction() {
        
        let inviteDialog:FBSDKGameRequestDialog = FBSDKGameRequestDialog()
        if(inviteDialog.canShow()){
            
            let inviteContent:FBSDKGameRequestContent = FBSDKGameRequestContent()
            inviteContent.message = FacebookInvite.message
            inviteContent.data = FacebookInvite.data
            inviteContent.title = FacebookInvite.data
            
            inviteContent.actionType = .none
            inviteDialog.content = inviteContent
            
            inviteDialog.delegate = self
            inviteDialog.show()
        }
        
        
        
    }
    
    
    //MARK: App/Game invite delegates

    public func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        let resultObject = NSDictionary(dictionary: results)
        
        print(resultObject)
        
        if let invites = resultObject.value(forKey: "to") {
            print((invites as AnyObject).count)
            self.totalInvitesSent += (invites as AnyObject).count
            
            if self.totalInvitesSent >= 10 {
                
                self.InviteStatusApi(check: .invite )
                
            } else {
                
                Alerts.shared.show(alert: .alert, message: "\(10 - self.totalInvitesSent) \(Alert.invitesRequired.rawValue)", type: .error)
                
            }
        }
    }
    

    public func gameRequestDialog(_ gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: Error!) {
        
        print(error.localizedDescription)
        
    }
    

    public func gameRequestDialogDidCancel(_ gameRequestDialog: FBSDKGameRequestDialog!) {
        
        print("canceled")
        
    }
    
    

}
