//
//  RecordingsViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class RecordingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let modalViewController = self.storyboard?.instantiateViewController(withIdentifier: "PinValidation")
        modalViewController?.modalPresentationStyle = .overCurrentContext
        present(modalViewController!, animated: true, completion: nil)

    }

}
