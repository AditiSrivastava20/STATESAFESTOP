//
//  SafeListViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import EPContactsPicker

class SafeListViewController: UIViewController , EPPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    
    
    @IBAction func btnRemoveAction(_ sender: Any) {
    }
    
    //MARK: Add safeuser action
    @IBAction func btnAddAction(_ sender: Any) {
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: EPContactsPicker delegates
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        
        var safeuser:[String] = []
        
        for (index,contact) in contacts.enumerated() {
            print("\(contact.phoneNumbers[0].phoneNumber)")
            safeuser.insert("\(contact.phoneNumbers[0].phoneNumber)", at: index)
        }
        
        print(safeuser)
        self.addSafelist(array: safeuser)
        
    }
    
    //MARK: Add safelist
    func addSafelist(array: [String]) {
        
        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
            return
        }
        
        print(login["access_token"] ?? "")
        print(array)
        
        APIManager.shared.request(withArray: LoginEndpoint.addSafelist(accessToken: /login["access_token"]) , array: array, completion: { (response) in
            
            self.handle(response: response)
        })
        
        
    }
    

}
