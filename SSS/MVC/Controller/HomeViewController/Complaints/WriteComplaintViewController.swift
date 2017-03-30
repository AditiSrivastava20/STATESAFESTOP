//
//  WriteComplaintViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import SZTextView

class WriteComplaintViewController: BaseViewController {

    @IBOutlet weak var tfTitle: TextField!
    @IBOutlet weak var txtDesc: SZTextView!
    @IBOutlet weak var btnAddFile: FlatButton!
    
    var media_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle?.placeHolderAtt()
        tfTitle.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Handle response 
    func handle(response: Response) {
        
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
        
        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
            return
        }
        
        switch Validate() {
        case .success:
            APIManager.shared.request(with: LoginEndpoint.addComplaint(accessToken: "$2y$10$AFo5Pnyf164YOUUlbfq.rO9Nb1HMGu3oBQBKwS56r9sZuwACLHrZK", title: tfTitle.text, description: txtDesc.text, media_id: /media_id), completion: { (response) in
                
                self.handle(response: response)
            })
            
        case .failure(let title,let msg):
            Alerts.shared.show(alert: title, message: msg , type : .info)
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
