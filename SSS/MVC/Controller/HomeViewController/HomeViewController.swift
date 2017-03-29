//
//  HomeViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/23/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Foundation



class HomeViewController: TwitterPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.moveToViewController(at: 1)
        self.containerView.bounces = false
    
    }
    
    
    
    @IBAction func actionBtnSideMenu(_ sender: Any) {
          toggleSideMenuView()
    }


    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
        let child_1 = StoryboardScene.Main.instantiateRecordingViewController()
        
        let child_2 = StoryboardScene.Main.instantiateCameraViewController()
        
        child_2.onSwitchVc = {[weak self]
            (isRecoding) in
             self?.moveToViewController(at: isRecoding ? 0 :2)
        }
        
        let child_3 = StoryboardScene.Main.instantiateComplaintViewController()
        
    
        return [child_1, child_2, child_3]
    }
    
    
  
    
    

}


