//
//  NotificationViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navbarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navbarButtons() {
        let btn1 = MaterialButton.shared.btn()
        btn1.setImage(Image(asset: .icBack), for: .normal)
        btn1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = MaterialButton.shared.btn()
        btn2.setImage(Image(asset: .icNotification), for: .normal)
        btn2.addTarget(self, action: #selector(reloadNotification), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
    }
    
    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func reloadNotification() {
        print("reload notification")
    }

}
