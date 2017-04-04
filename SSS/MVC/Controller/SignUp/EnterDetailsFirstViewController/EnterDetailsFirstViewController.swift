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
import EZSwiftExtensions
import NVActivityIndicatorView

class EnterDetailsFirstViewController: BaseViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    
    var isFromFacebook = false
    var isFromTwitter = false
    var fbProfile:FacebookResponse?
    var twProfile:TwitterResponse?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isFromFacebook {
            ifFromFacebook(obj: fbProfile)
        } else if isFromTwitter {
            ifFromTwitter(obj: twProfile)
        }
        
        
    }
    
    //MARK: pre-fill all fields if from facebook
    func ifFromFacebook(obj: FacebookResponse?) {
        
        if let url = obj?.imageUrl {
            self.imgProfile.kf.setImage(with: URL(string: url))
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
        }
        self.txtFullname.text = obj?.name ?? ""
        self.txtEmailAddress.text = obj?.email ?? ""
        self.facebookID = obj?.fbId ?? ""
        self.twitterID = ""
        self.scrollView.scrollToTop()
    }
    
    
    //MARK: pre-fill all fields if from twitter
    func ifFromTwitter(obj: TwitterResponse?) {
        
        if let url = obj?.image_url {
            self.imgProfile.kf.setImage(with: URL(string: url))
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
        }
        self.txtFullname.text = /obj?.name
        self.twitterID = /obj?.id
        self.facebookID = ""
        self.scrollView.scrollToTop()
        
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
        
        FBManager.shared.login(self, check: .signup, graphRequest: .me, completion: { (profile) in
            
            let fbProfile = profile as? FacebookResponse
            
            print(fbProfile?.fbId ?? "")
            
            self.ifFromFacebook(obj: fbProfile)
            
        })
    }
    
    
    //Mark:- Twitter Sign up
    @IBAction func btnTwitterAction(_ sender: Any) {
        
        ez.runThisInMainThread {
            self.startAnimating(nil, message: nil, messageFont: nil, type: .ballClipRotate , color: colors.loaderColor.color(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        TWManager.shared.login(self, check: .signup, completion: { (twProfile) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            print(twProfile.id ?? "")
            
            self.ifFromTwitter(obj: twProfile)

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
























