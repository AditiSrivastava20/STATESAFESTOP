//
//  WriteComplaintViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages
import SZTextView

class WriteComplaintViewController: BaseViewController, TextFieldDelegate {

    @IBOutlet weak var tfTitle: TextField!
    @IBOutlet weak var txtDesc: SZTextView!
    @IBOutlet weak var btnAddFile: FlatButton!
    @IBOutlet weak var btnAddComplaint: FlatButton!
    
    var media_id:String?
    var ShowComplaintDescription = false
    var complaint:Complaint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle?.placeHolderAtt()
        
        if ShowComplaintDescription {
            self.navigationItem.title = "Complaint Detail"
            tfTitle.text = /complaint?.title
            tfTitle.isEnabled = false
            
            txtDesc.text = /complaint?.complaintDescription
            txtDesc.isEditable = false
            
            btnAddFile.setTitle(/complaint?.media_content, for: .normal)
            btnAddFile.isEnabled = false
            
            btnAddComplaint.isHidden = true
            
        } else {
            
            tfTitle.becomeFirstResponder()
            
        }
        
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
    }
    
    //MARK: - Handle response 
    func handle(response: Response) {
        UIApplication.shared.endIgnoringInteractionEvents()
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
            }
            
            showPopUp()
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    func showPopUp() {
        let vc = StoryboardScene.Main.instantiateComplaintDoneViewController()
        vc.obj = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        presentVC(vc)
        
    }
    
    //MARK: - Validate
    func Validate() -> Valid{
        return Validation.shared.validate(complaint: tfTitle.text, description: txtDesc.text)
    }
    
    
    
    @IBAction func actionBtnAddFile(_ sender: Any) {
        
        let vc = StoryboardScene.Main.instantiateRecordingViewController()
        vc.isFromMediaSelection = true
        vc.delegateMedia = self
        pushVC(vc)
        
    }
    
    
    @IBAction func btnAddComplaintAction(_ sender: Any) {
        
        ISMessages.hideAlert(animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        switch Validate() {
        case .success:

            APIManager.shared.request(with: LoginEndpoint.addComplaint(accessToken: login.profile?.access_token, title: tfTitle.text, description: txtDesc.text, media_id: /media_id), completion: { (response) in
                
                self.handle(response: response)
            })
            
        case .failure(let title,let msg):
            UIApplication.shared.endIgnoringInteractionEvents()
            Alerts.shared.show(alert: title, message: msg , type : .error)
        }
    }
    

    @IBAction func actionBtnBack(_ sender: Any) {
        popVC()
    }
}


extension WriteComplaintViewController  : mediaSelectListner {
    
    func getMedia(id : String?,name : String?) {
        
        media_id = id
        btnAddFile.setTitle(name, for: UIControlState.normal)
    }
    
}
