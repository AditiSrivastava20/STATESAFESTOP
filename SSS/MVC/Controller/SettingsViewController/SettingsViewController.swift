//
//  SettingsViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
        
    }
    
    
    @IBAction func btnSendEmailAction(_ sender: Any) {

    }
    
    @IBAction func btnCallAction(_ sender: Any) {
    }
    
    
    
    //MARK: - Reset pin action
    @IBAction func btnResetPinAction(_ sender: Any) {
        let vc = StoryboardScene.Main.instantiatePinValidationViewController()
        vc.delegatePin = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        presentVC(vc)
        
    }
    
    
    //MARK: - pin validation
    func validatePin(pin: String?) {
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        if (pin?.isEqual(/login.profile?.pin_password))! {
            performSegue(withIdentifier: segue.settingsToResetPin.rawValue, sender: self)
        } else {
            Alerts.shared.show(alert: .error, message: "Invalid Pin", type: .error)
        }
        
        
    }
    

}

extension SettingsViewController  : pinEnteredListner {
    
    func getPinCode(pin : String?) {
        
        print(pin ?? "")
        if let _ = pin {
            validatePin(pin: pin)
        } else {
            validatePin(pin: "")
        }
        
        
    }
    
}

