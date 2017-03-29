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

    var login:[String: String]?
    var items:[Safelist]?
    var isFromEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = UserDefaults.standard.value(forKey: "login") as? [String: String] {
            login = value
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSafelist()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    //MARK: get safelist API
    func getSafelist() {
        items = []
        
//        APIManager.shared.request(with: LoginEndpoint.addSafelist(accessToken: /login["access_token"]), completion: { (response) in
//            
//            self.handle(response: response)
//            
//        })
        
        let arrayData = [
        [
        "phone" : "077-065-8931",
        "unformatted_phone" : "0770658931",
        "reg_id" : " ",
        "id" : 47,
        "device_token" : " ",
        "is_block" : 0,
        "image" : " ",
        "email" : " ",
        "user_id" : 0,
        "fullname" : "Aron "
            ],
        ["phone" : "570-928-9144",
         "unformatted_phone" : "5709289144",
         "reg_id" : " ",
         "id" : 52,
         "device_token" : " ",
         "is_block" : 0,
         "image" : " ",
         "email" : " ",
         "user_id" : 0,
         "fullname" : "Paul "
            ]]
        
        let json = JSON(arrayData)
        
        for dict in json.arrayValue {
            
            do {
                let item = try Safelist(attributes: dict.dictionaryValue)
                items?.append(item)
            } catch {
                
            }
        }
        
        tableView?.estimatedRowHeight = 89
        setupTableView(tableView: tableView, cellId: "SafelistTableViewCell", items: items)
    }
    
    
    //MARK: Add safeuser action
    @IBAction func btnAddAction(_ sender: Any) {
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Remove safe user action
    @IBAction func btnRemoveAction(_ sender: Any) {
        
        if isFromEdit == false {
            isFromEdit = true
            btnRemove.setTitle("Done", for: UIControlState.normal)
            tableView.reloadData()
        } else {
            isFromEdit = false
            btnRemove.setTitle("Remove", for: UIControlState.normal)
            removeSafeuser()
        }
    }
    
    
    //MARK: remove selected safe users
    func removeSafeuser() {
        
        let array = items?.filter(){$0.isSelected == 1}
        userIds(value: array)
        
        items = items?.filter(){$0.isSelected != 1}
        dataSource?.items = items
        tableView.reloadData()
    }
    
    //MARK: get user ids
    func userIds(value: [Safelist]?) {
        var ids:[String] = []
        for user in value! {
            ids.append(user.id!)
        }
        self.ApiSafelist(array: ids, check: .remove)
    }
    
    //MARK: Add/Remove safelist
    func ApiSafelist(array: [String], check: Safeusers) {
        print(array)
        
        APIManager.shared.request(withArray: endPoint(check: check) , array: array, completion: { (response) in
            
            self.handle(response: response)
        })
    }
    
    //MARK: select endpoint
    func endPoint(check: Safeusers) -> Router {
        
        print(login?["access_token"] ?? "")
        
        switch check {
        case .add:
            return LoginEndpoint.addSafelist(accessToken: /login?["access_token"])
        case .remove:
            return LoginEndpoint.removeSafeuser(accessToken: /login?["access_token"])
        }
        
    }
    
}



extension SafeListViewController {
    
    //MARK: setup tableview
    override func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items: items as Array<AnyObject>? , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: {[unowned self] (cell, item, indexPath) in
            
            (cell as? SafelistCell)?.objSafeuser = item as? Safelist
            (cell as? SafelistCell)?.imageViewStaticPhone.isHidden = self.isFromEdit
            (cell as? SafelistCell)?.checkBoxContact.isHidden = !(self.isFromEdit)
            
            }, aRowSelectedListener: { (indexPath) in
                
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
        
        if !safeuser.isEmpty {
            self.ApiSafelist(array: safeuser, check: .add)
        }
        
    }
    
}
