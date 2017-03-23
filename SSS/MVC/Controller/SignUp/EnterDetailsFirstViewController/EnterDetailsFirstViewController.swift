//
//  EnterDetailsSecondViewController.swift
//  SSS
//
//  Created by Sierra 4 on 08/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages

class EnterDetailsFirstViewController: BaseViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.cornerRadius = imgProfile.layer.height / 2
        
        txtFullname.placeHolderAtt()
        txtEmailAddress.placeHolderAtt()
        txtPassword.placeHolderAtt()
        txtConfirmPassword.placeHolderAtt()
        txtFullAddress.placeHolderAtt()
        txtPhoneNumber.placeHolderAtt()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Validation
    func Validate() -> Valid{
        let value = Validation.shared.validate(signup: txtFullname.text, email: txtEmailAddress.text, password: txtPassword.text, confirmPasswd: txtConfirmPassword.text, fulladdress: txtFullAddress.text, phoneNo: txtPhoneNumber.text)
        return value
    }
    
    //MARK:- Go back
    @IBAction func btnBackAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Image picker action
    @IBAction func btnImagePickerAction(_ sender: Any) {
        
        let modalViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImagePickViewController") as! ImagePickViewController
        
        // custom delegate to get image back from addPhotoViewController
        modalViewController.delegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .crossDissolve
        present(modalViewController, animated: true, completion: nil)
        
    }
    
    
    //Mark:- Facebook Sign up
    @IBAction func btnFacebokAction(_ sender: Any) {
        
    }
    
    
    //Mark:- Twitter Sign up
    @IBAction func btnTwitterAction(_ sender: Any) {
        
    }
    
    
    //Mark:- Normal Sign up
    @IBAction func btnSignUpAction(_ sender: Any) {
        print("Sign up")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            print("success")
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
}

extension EnterDetailsFirstViewController:  DataSentDelegate  {
    func userProfilePicInput(image: UIImage) {
        imgProfile.image = image
    }
}
























