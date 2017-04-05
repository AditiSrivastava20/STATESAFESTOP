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


class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFullname: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPhone: TextField!
    @IBOutlet weak var txtAddress: TextField!
    @IBOutlet weak var backgroundView: UIView!
    
    

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
        
        imgProfilePic.kf.setImage(with: URL(string: (login.profile?.image_url)!), placeholder: Image(asset: .icProfile), options: nil, progressBlock: nil, completionHandler: nil)
        
        txtFullname.text = login.profile?.fullname
        txtEmail.text = login.profile?.email
        txtPhone.text = login.profile?.unformatted_phone
        txtAddress.text = login.profile?.fulladdress
        
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
    
    //MARK: - Handle response
    func handle(response : Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                
                print(value.msg ?? "")
                Alerts.shared.show(alert: .success, message: /value.msg, type: .success)
                UserDataSingleton.sharedInstance.loggedInUser = value
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSidePanel"), object: nil)
                popVC()
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    

    
    
    //MARK: - Save changes in edit profile
    @IBAction func btnSaveChangesAction(_ sender: UIBarButtonItem) {
        print("hit api")
        
        switch validate() {
        case .success:
            
            let token = UserDataSingleton.sharedInstance.loggedInUser?.profile?.access_token
            let email = UserDataSingleton.sharedInstance.loggedInUser?.profile?.email
            
            APIManager.shared.request(withImages: LoginEndpoint.editProfile(accessToken: token, fullName: txtFullname.text, address: txtAddress.text, email: email, phone: txtPhone.text), image: imgProfilePic.image, completion: { (response) in
                
                self.handle(response: response)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
        }
        
        
        
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
    }
}


