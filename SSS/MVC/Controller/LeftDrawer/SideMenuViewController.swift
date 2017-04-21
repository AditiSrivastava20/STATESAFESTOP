//
//  SideMenuViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/24/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Kingfisher
import EZSwiftExtensions
import NVActivityIndicatorView


class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    var login = UserDataSingleton.sharedInstance.loggedInUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(insertValuesInSidePanel), name: NSNotification.Name(rawValue: "updateSidePanel") , object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        insertValuesInSidePanel()
    }
    
    
    //MARK: -  Side panel values
    func insertValuesInSidePanel() {
        
        let login = UserDataSingleton.sharedInstance.loggedInUser
        
        imgProfilePic.kf.setImage(with: URL(string: (/login?.profile?.image_url)), placeholder: Image(asset: .icProfile), options: nil, progressBlock: nil, completionHandler: nil)
        
        lblFullname.text = login?.profile?.fullname
        lblEmail.text = login?.profile?.email
        lblPhone.text = login?.profile?.unformatted_phone
        lblAddress.text = login?.profile?.fulladdress
        
    }
    
    
    //MARK: go to edit profile
    @IBAction func btnEditProfileAction(_ sender: Any) {
        
        hideSideMenuView()
        let destinationVC = StoryboardScene.Main.instantiateEditProfileViewController()
        ez.topMostVC?.pushVC(destinationVC)
    }
    
    
    //MARK: go to safelist
    @IBAction func btnSafelistAction(_ sender: Any) {
        
        hideSideMenuView()
        let destinationVC = StoryboardScene.Main.instantiateSafeListViewController()
        ez.topMostVC?.pushVC(destinationVC)
    }
    
    
    //MARK: go to settings
    @IBAction func btnSettingsAction(_ sender: Any) {
        hideSideMenuView()
        let destinationVC = StoryboardScene.Main.instantiateSettingsViewController()
        ez.topMostVC?.pushVC(destinationVC)
        
    }
    
    
    //MARK: logout action
    @IBAction func btnLogoutAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            
            switch action.style {
                
            default:
                self.logOutApi()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - logout api action
    func logOutApi() {
        
        Loader.shared.start()
        
        APIManager.shared.request(with: LoginEndpoint.logout(accessToken: login?.profile?.access_token), completion: { (response) in
            
            Loader.shared.stop()
            
            HandleResponse.shared.handle(response: response, self, from: .logout , param: nil)
        })
        
    }
    
}




