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
import Kingfisher

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
    
    //MARK:- Go back
    @IBAction func btnBackAction(_ sender: Any) {
        popVC()
    }
    
    
    //MARK: - open GMS place picker
    @IBAction func btnPickAddressAction(_ sender: Any) {
        self.txtFullAddress.text = ""
        fetchFullAddress(completion: {(address) in
            self.txtFullAddress.text = address
        })
        
        
    }
    
    
    //MARK:- Validation
    func Validate() -> Valid{
        let value = Validation.shared.validate(signup: txtFullname.text, email: txtEmailAddress.text, password: txtPassword.text, confirmPasswd: txtConfirmPassword.text, fulladdress: txtFullAddress.text, phoneNo: txtPhoneNumber.text, facebookID: facebookID, twitterID: twitterID)
        return value
    }
    
    
    //MARK:- Image picker action
    @IBAction func btnImagePickerAction(_ sender: Any) {
        
        let modalViewController = StoryboardScene.SignUp.instantiateImagePickViewController()
        
        // custom delegate to get image back from addPhotoViewController
        modalViewController.pickImageDelegate = self
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
    
    
    //Mark:- Sign up Action
    @IBAction func btnSignUpAction(_ sender: Any) {
        print("Sign up")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            
            APIManager.shared.request(withImages: LoginEndpoint.signup(fullname: txtFullname.text, email: txtEmailAddress.text, fullAddress: txtFullAddress.text, password: txtPassword.text, facebookId: facebookID, twitterId: twitterID, phone: txtPhoneNumber.text, accountType: accountType(), deviceToken: MobileDevice.token.rawValue),image: imgProfile.image , completion: { (response) in
                
                HandleResponse.shared.handle(response: response, self, from: .signup)
                
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
    }
    
    //MARK:- Account type
    func accountType() -> String {
        
        if (/facebookID).isEmpty {
            return AccountType.facebook.rawValue
        } else if (/twitterID).isEmpty {
            return AccountType.twitter.rawValue
        } else {
            return AccountType.normal.rawValue
        }
    }
    
}

extension EnterDetailsFirstViewController:  DataSentDelegate  {
    func userProfilePicInput(image: UIImage) {
        imgProfile.image = image
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
}
























