//
//  LoginViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension LoginViewController {
    
    @IBAction func forgotPasswd(_ sender: Any) {
        print("forgot password")
    }
    
    @IBAction func login(_ sender: Any) {
        print("login")
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    
}
