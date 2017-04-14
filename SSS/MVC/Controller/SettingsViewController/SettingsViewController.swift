//
//  SettingsViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import MessageUI

class SettingsViewController: BaseViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
        
    }
    
    
    @IBAction func btnSendEmailAction(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    //MARK: Compose email
    func configuredMailComposeViewController() -> MFMailComposeViewController {
       let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
            
        mailComposerVC.setToRecipients(["support@mediaopp.com"])
        mailComposerVC.setSubject("Subject..")
        mailComposerVC.setMessageBody("", isHTML: false)
            
        return mailComposerVC
    }
    
    //MARK: MFMail composer alert
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
        
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
        
        if (pin?.isEmpty)! {
            
            Alerts.shared.show(alert: .alert, message: /Alert.noPinEntered.rawValue, type: .error)
            
        } else if (pin?.isEqual(/login.profile?.pin_password))! {
            
            ez.dispatchDelay(0.3, closure: {
                self.performSegue(withIdentifier: segues.settingsToResetPin.rawValue, sender: nil)
            })
            
            
        } else {
            Alerts.shared.show(alert: .alert, message: /Alert.incorrectPin.rawValue, type: .error)
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

