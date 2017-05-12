//
//  ViewControllerExtension.swift
//  SSS
//
//  Created by Sierra 4 on 09/05/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func openRateUsActionSheet() {
        
        let actionSheetController = UIAlertController(title: "Rate State Safe Stop", message: "If you enjoy using State Safe Stop, would you mind taking a moment to rate it ?", preferredStyle: .alert )
        
        let pAction = UIAlertAction(title: "Rate Us", style: .default ) { action -> Void in
            print("Rate Now")
            self.rateApp(appId: "id1163114504", completion: { (success) in
                print(success)
            })
        }
        actionSheetController.addAction(pAction)
        
        
        let cancelActionButton = UIAlertAction(title: "No Thanks", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "https://itunes.apple.com/us/app/state-safe-stop/" + appId + "?mt=8") else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

}
