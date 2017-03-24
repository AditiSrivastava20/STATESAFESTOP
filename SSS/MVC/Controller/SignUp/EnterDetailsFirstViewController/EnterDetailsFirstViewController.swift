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
import TwitterKit
import Kingfisher
import GooglePlacePicker

class EnterDetailsFirstViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    var facebookID:String = ""
    var twitterID:String = ""
    
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
        let value = Validation.shared.validate(signup: txtFullname.text, email: txtEmailAddress.text, password: txtPassword.text, confirmPasswd: txtConfirmPassword.text, fulladdress: txtFullAddress.text, phoneNo: txtPhoneNumber.text, facebookID: facebookID, twitterID: twitterID)
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
        
        FBManager.shared.login(self, check: .signup, completion: { (fbProfile) in
            
            print(fbProfile.fbId ?? "")
            if let url = fbProfile.imageUrl {
                self.imgProfile.kf.setImage(with: URL(string: url))
            }
            self.txtFullname.text = fbProfile.name ?? ""
            self.txtEmailAddress.text = fbProfile.email ?? ""
            self.facebookID = fbProfile.fbId ?? ""
            self.twitterID = ""
        })
    }
    
    
    //Mark:- Twitter Sign up
    @IBAction func btnTwitterAction(_ sender: Any) {
        
        TWManager.shared.login(self, check: .signup, completion: { (json) in
            
            print("\(json["id"]!)")
            self.imgProfile.kf.setImage(with: URL(string: "\(json["profile_image_url_https"]!)"))
            self.txtFullname.text = "\(json["name"]!)"
            self.twitterID = "\(json["id"]!)"
            self.facebookID = ""
        
        })
        
    }
    
    
    //Mark:- Normal Sign up
    @IBAction func btnSignUpAction(_ sender: Any) {
        print("Sign up")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            
            APIManager.shared.request(withImages: LoginEndpoint.signup(fullname: txtFullname.text, email: txtEmailAddress.text, fullAddress: txtFullAddress.text, password: txtPassword.text, facebookId: facebookID, twitterId: twitterID, phone: txtPhoneNumber.text, accountType: accountType(), deviceToken: Device.token.rawValue),image: imgProfile.image , completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    func accountType() -> String {
        
        if !facebookID.isEmpty {
            return AccountType.facebook.rawValue
        } else if !twitterID.isEmpty {
            return AccountType.twitter.rawValue
        } else {
            return AccountType.normal.rawValue
        }
        
    }
    
    
    //MARK:- Check existing email/phone
    func checkExistEmailOrPhone() {
        
        APIManager.shared.request(with: LoginEndpoint.checkExistEmailOrPhone(email: txtEmailAddress.text, phone: txtPhoneNumber.text) , completion: { (response) in
            
            HandleResponse.shared.handle(response: response, self)
            
        })
        
    }
    
}

extension EnterDetailsFirstViewController:  DataSentDelegate  {
    func userProfilePicInput(image: UIImage) {
        imgProfile.image = image
    }
}
























