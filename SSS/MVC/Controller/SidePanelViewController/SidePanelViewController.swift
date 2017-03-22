//
//  SidePanelViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Back.backPanel(obj: self,opr: .left)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logOut(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        TWManager.shared.logOut()
        
        
    }
}
