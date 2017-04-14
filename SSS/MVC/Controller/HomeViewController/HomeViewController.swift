//
//  HomeViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/23/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import EZSwiftExtensions



class HomeViewController: TwitterPagerTabStripViewController {

    let child_1 = StoryboardScene.Main.instantiateRecordingViewController()
   
    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moveToViewController(at: 1)
        self.containerView.bounces = false
        
        if let val = UserDefaults.standard.value(forKey: "FirstSignUp") as? String {
            
            if val == "1" {
                UserDefaults.standard.set("0", forKey: "FirstSignUp")
                let vc = StoryboardScene.Main.instantiateSafeListViewController()
                navigationController?.pushViewController(vc, animated: false)
                
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(openNotification), name: NSNotification.Name(rawValue: "notification") , object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setBtnImage()
        
    }
    
    func openNotification() {
        
        if let val = UserDefaults.standard.value(forKey: "notification_tapped") as? String {
            
            if val == "1" {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload_notification"), object: nil)
                
                
            } else {
                
                let vc = StoryboardScene.Main.instantiateNotificationViewController()
                navigationController?.pushViewController(vc, animated: false)
                
            }
            
        }
        

    }
    
    func setBtnImage() {
        
        guard let user = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        if let url = user.profile?.image_url {
                
                URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        
                        self.setIBarButton(image: image)
                    })
                    
                }).resume()
            }
        
    }
    
    func setIBarButton(image : UIImage?){
        
        if let _ = image {
            
            let button = UIButton.init(type: .custom)
            button.setImage(image, for: UIControlState.normal)
            button.addTarget(self, action:#selector(HomeViewController.leftDrawer), for: UIControlEvents.touchUpInside)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            self.navigationItem.leftBarButtonItem = barButton

        }
        
    }
    
    
    func leftDrawer() {
        toggleSideMenuView()
    }
    
    
    @IBAction func actionBtnSideMenu(_ sender: Any) {
          toggleSideMenuView()
    }
    
    
    
    override func indexWasChangedTemp(isTrue : Bool) {
        child_1.showPopUp()
    }
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
        
        child_1.switchToHome = {[weak self]
            (isHome) in
            self?.moveToViewController(at: isHome ? 1 :0)
        }
        
        let child_2 = StoryboardScene.Main.instantiateCameraViewController()
        
        child_2.onSwitchVc = {[weak self]
            (isRecoding) in
             self?.moveToViewController(at: isRecoding ? 0 :2)
        }
        
        let child_3 = StoryboardScene.Main.instantiateComplaintViewController()
        
    
        return [child_1, child_2, child_3]
    }
    
    
    
    
  
    
}



