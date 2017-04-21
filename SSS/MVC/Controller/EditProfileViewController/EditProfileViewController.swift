//
//  EditProfileViewController.swift
//  SSS
//
//  Created by Sierra 4 on 01/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import Kingfisher
import ISMessages
import EZSwiftExtensions
import NVActivityIndicatorView


class EditProfileViewController: BaseViewController, TextFieldDelegate {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPhone: TextField!
    @IBOutlet weak var txtAddress: TextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    
    var fullname:String?
    var address:String?
    var image:UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtFullname.placeHolderAtt()
        txtEmail.placeHolderAtt()
        txtPhone.placeHolderAtt()
        txtAddress.placeHolderAtt()
        // Do any additional setup after loading the view.
        
        fillAllFields()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.touchBegan (_:)))
        backgroundView.addGestureRecognizer(gesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: TextField)  {
        ISMessages.hideAlert(animated: true)
        
        if textField == txtAddress {
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
            
            ez.dispatchDelay(0.3, closure: {
                self.fetchFullAddress(completion: {(address) in
                    
                    self.txtAddress.text = address
                })
            })
        }
        
    }
    
    //MARK: - dismiss ISmessages and end editing
    func touchBegan(_ sender:UITapGestureRecognizer){
        
        txtFullname.text = txtFullname.text?.uppercaseFirst
        
        ISMessages.hideAlert(animated: true)
        self.view.endEditing(true)
        
    }
    
    
    
    //MARK: -  prefill all textfields
    func fillAllFields() {
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        imgProfilePic.clipsToBounds = true
        imgProfilePic.kf.setImage(with: URL(string: (login.profile?.image_url)!), placeholder: Image(asset: .icEditProfile), options: nil, progressBlock: nil, completionHandler: nil)
        
        if Image(asset: .icEditProfile) != imgProfilePic.image {
            imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height / 2
        }
        
        txtFullname.text = login.profile?.fullname
        fullname = login.profile?.fullname
        txtEmail.text = login.profile?.email
        txtPhone.text = login.profile?.unformatted_phone
        txtAddress.text = login.profile?.fulladdress
        address = login.profile?.fulladdress
        image = imgProfilePic.image
        
        btnChangePassword.isHidden = login.profile?.account_type != "1"
        
    }
    
    
    
    //MARK: - back action
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
        
    }
    
    //MARK: - Place picker action
    @IBAction func btnPickPlaceAction(_ sender: Any) {
        
        fetchFullAddress(completion: {(address) in
            
            self.txtAddress.text = address
        })
    }
    
    
    
    //MARK: - Validate fields
    func validate() -> Valid {
        return Validation.shared.validate(edit: txtFullname.text, address: txtAddress.text, phone: txtPhone.text)
        
    }
    
    
    //MARK: - Save changes in edit profile
    @IBAction func btnSaveChangesAction(_ sender: UIBarButtonItem) {
        print("hit api")
        
        if changesDone() {
            return
        }
        
        Loader.shared.start()
        
        switch validate() {
        case .success:
            
            let token = UserDataSingleton.sharedInstance.loggedInUser?.profile?.access_token
            let email = UserDataSingleton.sharedInstance.loggedInUser?.profile?.email
            
            APIManager.shared.request(withImages: LoginEndpoint.editProfile(accessToken: token, fullName: txtFullname.text, address: txtAddress.text, email: email, phone: txtPhone.text), image: imgProfilePic.image, completion: { (response) in
                
                Loader.shared.stop()
                
                HandleResponse.shared.handle(response: response, self, from: .editProfile, param: nil)
                
            })
            
        case .failure( _ ,let msg):
            
            Loader.shared.stop()
            Alerts.shared.show(alert: .alert, message: msg , type : .error)
        }
        
    }
    
    
    func changesDone() -> Bool {
        
        if !(fullname?.isEqual(txtFullname.text))! || !(address?.isEqual(txtAddress.text))! || image != imgProfilePic.image {
            return false
        }
        return true
        
    }
    
    
    
    //MARK: - pick new profile image
    @IBAction func btnImagePickerAction(_ sender: Any) {
        
        let modalViewController = StoryboardScene.SignUp.instantiateImagePickViewController()
        
        // custom delegate to get image back from addPhotoViewController
        modalViewController.pickImageDelegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .crossDissolve
        present(modalViewController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - go to change password
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        
        let vc = StoryboardScene.Main.instantiateChangePasswordViewController()
        pushVC(vc)
        
    }
   
    
}



//MARK: - imgae picker delegate
extension EditProfileViewController: DataSentDelegate {
    func userProfilePicInput(image: UIImage) {
        imgProfilePic.image = image
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height / 2
    }
}


