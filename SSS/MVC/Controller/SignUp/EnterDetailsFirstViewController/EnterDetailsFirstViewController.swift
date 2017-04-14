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

class EnterDetailsFirstViewController: BaseViewController, TextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var txtFullAddress: TextField!
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    var isFromFacebook = false
    var isFromTwitter = false
    var fbProfile:FacebookResponse?
    var twProfile:TwitterResponse?
    var imageSelected = false
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.touchBegan (_:)))
        backgroundView.addGestureRecognizer(gesture)
        
        if isFromFacebook {
            ifFromFacebook(obj: fbProfile)
            hidePasswordFields()
        } else if isFromTwitter {
            ifFromTwitter(obj: twProfile)
            hidePasswordFields()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    

    //textfield begin editing
    func textFieldDidBeginEditing(_ textField: TextField)  {
        ISMessages.hideAlert(animated: true)
        
        
        if textField == txtFullAddress {
            
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
            
            ez.dispatchDelay(0.3, closure: {
                self.fetchFullAddress(completion: {(address) in
                    
                    self.txtFullAddress.text = address
                })
            })
        }
    }
    
    func hidePasswordFields() {
        
        txtPassword.isHidden = true
        txtConfirmPassword.isHidden = true
        
    }
    
    
    override func appTerminated() {
        
    }

    
    //MARK: - Action for touch began
    func touchBegan(_ sender:UITapGestureRecognizer){
        
        txtFullname.text = txtFullname.text?.uppercaseFirst
        
        ISMessages.hideAlert(animated: true)
        self.view.endEditing(true)
        
    }
    
    
    //MARK: pre-fill all fields if from facebook
    func ifFromFacebook(obj: FacebookResponse?) {
        
        if let url = obj?.imageUrl {
            self.imgProfile.kf.setImage(with: URL(string: url))
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
            imageSelected = true
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
            
            let newUrl = url.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil)
            
            self.imgProfile.kf.setImage(with: URL(string: newUrl))
            
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
            imageSelected = true
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
    
    
    //MARK:- Validation
    func Validate() -> Valid{
        let value = Validation.shared.validate(signup: txtFullname.text , email: txtEmailAddress.text, password: txtPassword.text, confirmPasswd: txtConfirmPassword.text, fulladdress: txtFullAddress.text, phoneNo: txtPhoneNumber.text, facebookID: facebookID, twitterID: twitterID)
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
    
    
    //MARk: - handle response for check-exsiting-phone/email
    func handle(response: Response) {
        
        switch response {
        case .success(let responseValue):
            
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                self.SignupApiAction()
                
            }
            
        case .failure(let str ):
            Alerts.shared.show(alert: .alert, message: /str, type: .error)
            
        }
        
    }
    
    //Mark:- Sign up Action
    @IBAction func btnSignUpAction(_ sender: Any) {
        
        print("Sign up")
        ISMessages.hideAlert(animated: true)
        let value = Validate()
        switch value {
        case .success:
            
            
            APIManager.shared.request(with: LoginEndpoint.checkExistEmailOrPhone(email: "", phone: txtPhoneNumber.text), completion: { (response) in
                
                self.handle(response: response)
                
            })
            
        case .failure( _,let msg):
            Alerts.shared.show(alert: .alert, message: msg , type : .error)
        }
    }
    
    
    //MARK: - Hit sign up api
    func SignupApiAction() {
        
        APIManager.shared.request(withImages: LoginEndpoint.signup(fullname: txtFullname.text?.uppercaseFirst , email: txtEmailAddress.text, fullAddress: txtFullAddress.text, password: txtPassword.text, facebookId: facebookID, twitterId: twitterID, phone: txtPhoneNumber.text, accountType: accountType(), deviceToken: ""),image: isImageSelected(imageSelected) , completion: { (response) in
            
            HandleResponse.shared.handle(response: response, self, from: .signup)
            
        })
        
    }
    
    
    
    func isImageSelected(_ val: Bool) -> UIImage? {
        
        if val {
            return imgProfile.image
        } else {
            return nil
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


//MARK: - image picker delegate
extension EnterDetailsFirstViewController:  DataSentDelegate  {
    func userProfilePicInput(image: UIImage) {
        imgProfile.image = image
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imageSelected = true
    }
}
























