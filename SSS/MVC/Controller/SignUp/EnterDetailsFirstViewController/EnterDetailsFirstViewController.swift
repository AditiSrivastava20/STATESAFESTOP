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
import GooglePlacePicker

class EnterDetailsFirstViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK:- fetch full address
    func fetchAddress() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            self.txtFullAddress.text = ""
            self.txtFullAddress.text = "\(place.name)" + " \(place.formattedAddress!)" + " \(place.attributions)"
        })
    }
    
    @IBAction func btnPickAddressAction(_ sender: Any) {
        self.fetchAddress()
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
        
        let modalViewController = StoryboardScene.SignUp.instantiateImagePickViewController()
        
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
            APIManager.shared.request(withImages: LoginEndpoint.signup(fullname: txtFullname.text, email: txtEmailAddress.text, fullAddress: txtFullAddress.text, password: txtPassword.text, facebookId: "", twitterId: "", phone: txtPhoneNumber.text, accountType: AccountType.normal.rawValue, deviceToken: Device.token.rawValue),image: imgProfile.image , completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self)
            })
            
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
























