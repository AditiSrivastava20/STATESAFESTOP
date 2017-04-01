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


class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertValuesInSidePanel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -  Side panel values
    func insertValuesInSidePanel() {
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        if let imgUrl = login.profile?.image_url {
            imgProfilePic.kf.setImage(with: URL(string: imgUrl))
        }
        
        lblFullname.text = login.profile?.fullname
        lblEmail.text = login.profile?.email
        lblPhone.text = login.profile?.unformatted_phone
        lblAddress.text = login.profile?.fulladdress
        
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
        
        UserDataSingleton.sharedInstance.loggedInUser = nil
        dismissVC(completion: nil)
        popVC()
    }
    
    
}
