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
    
    var media_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle?.placeHolderAtt()
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
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    //MARK: - Validate
    func Validate() -> Valid{
        return Validation.shared.validate(complaint: tfTitle.text, description: txtDesc.text)
    }
    
    
    
    @IBAction func actionBtnAddFile(_ sender: Any) {
        
        let vc = StoryboardScene.Main.instantiateRecordingViewController()
        pushVC(vc)
        
    }
    
    
    
    @IBAction func btnAddComplaintAction(_ sender: Any) {
        
        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
            return
        }
        
        switch Validate() {
        case .success:
            APIManager.shared.request(with: LoginEndpoint.addComplaint(accessToken: /login["access_token"], title: tfTitle.text, description: txtDesc.text, media_id: /media_id), completion: { (response) in
                
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
