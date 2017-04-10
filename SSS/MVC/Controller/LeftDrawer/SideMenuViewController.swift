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
    @IBOutlet weak var btnLogout: UIButton!
    
    var login = UserDataSingleton.sharedInstance.loggedInUser
    
    var logout : (() -> ())?
    
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
    
    //MARK: Handle response
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
            }
            LoginChecks.shared.exitFromMain()
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
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
        
        let vc = StoryboardScene.Main.instantiateLogOutPopUpViewController()
        vc.obj = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        presentVC(vc)
        
    }
    
    func logOutApi() {
        APIManager.shared.request(with: LoginEndpoint.logout(accessToken: login?.profile?.access_token), completion: { (response) in
            self.handle(response: response)
        })
        
    }
    
}




