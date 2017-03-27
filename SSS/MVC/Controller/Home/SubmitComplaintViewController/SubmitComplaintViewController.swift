//
//  SubmitComplaintViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material

class SubmitComplaintViewController: UIViewController {
    
    @IBOutlet weak var txtComplaintTitle: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtComplaintTitle.placeHolderAtt()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
