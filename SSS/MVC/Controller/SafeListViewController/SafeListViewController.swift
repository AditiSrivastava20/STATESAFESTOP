//
//  SafeListViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import EPContactsPicker
import SwiftyJSON
import Material
import M13Checkbox


class SafeListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemove: Button!

    var items:[Safelist]?

    var isFromEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSafelist()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: get safelist API
    func getSafelist() {
        
        
        let arrayData = [
        [
        "phone" : "077-065-8931",
        "unformatted_phone" : "0770658931",
        "reg_id" : " ",
        "id" : 44,
        "device_token" : " ",
        "is_block" : 0,
        "image" : " ",
        "email" : " ",
        "user_id" : 0,
        "fullname" : "Aron "
            ],
        ["phone" : "077-065-4562",
                "unformatted_phone" : "0770658931",
                "reg_id" : " ",
                "id" : 44,
                "device_token" : " ",
                "is_block" : 0,
                "image" : " ",
                "email" : " ",
                "user_id" : 0,
                "fullname" : "Paul "
            ]]
        
        let json = JSON(arrayData)
        
        items = []
        
        for dict in json.arrayValue {
            
            do {
                let item = try Safelist(attributes: dict.dictionaryValue)
                items?.append(item)
            } catch {
                
            }
        }
        
        tableView?.estimatedRowHeight = 89
        setupTableView(tableView: tableView, cellId: "SafelistTableViewCell", items: items)
        
//        APIManager.shared.request(with: LoginEndpoint.addSafelist(accessToken: /login["access_token"]), completion: { (response) in
//            
//            self.handle(response: response)
//            
//        })
        
    }
    
    
    
    //MARK: Handle response
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
            }
            
            if let value = responseValue as? [Safelist]{
                self.items = value
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
    }
    
    
    //MARK: Remove safe user action
    @IBAction func btnRemoveAction(_ sender: Any) {
        
        if isFromEdit == false {
            isFromEdit = true
            btnRemove.setTitle("Done", for: UIControlState.normal)
        } else {
            isFromEdit = false
            btnRemove.setTitle("Remove", for: UIControlState.normal)
            removeSafeuser()
        }
        tableView.reloadData()
        
        
        
    }
    
    func removeSafeuser() {
        for (index, value) in (items?.enumerated())! {
            if value.isSelected == 1 {
                items?.remove(at: index)
//                tableView.deleteRows(at: [[0,index]], with: UITableViewRowAnimation.none)
            }
        }
    }
    
    
    override func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items: items as Array<AnyObject>? , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: {[unowned self] (cell, item, indexPath) in
            
            (cell as? SafelistCell)?.objSafeuser = item as? Safelist
            (cell as? SafelistCell)?.imageViewStaticPhone.isHidden = self.isFromEdit
            (cell as? SafelistCell)?.checkBoxContact.isHidden = !(self.isFromEdit)
            
        }, aRowSelectedListener: { [unowned self] (indexPath) in
            
            print(indexPath)
            
            if self.isFromEdit == true {
                if self.items?[indexPath[1]].isSelected == 0 {
                    self.items?[indexPath[1]].isSelected = 1
                } else {
                    self.items?[indexPath[1]].isSelected = 0
                }
                
                tableView?.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
            
        }) { (scrollView) in
            
        }
        
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        
    }
    
    

}


extension SafeListViewController: EPPickerDelegate {
    
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
