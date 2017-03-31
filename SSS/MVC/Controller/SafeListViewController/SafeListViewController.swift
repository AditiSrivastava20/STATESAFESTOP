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

protocol contactListner: class {
    
    func getUserIds(ids: [String]?)
}


class SafeListViewController: BaseViewController {
    
    
    @IBOutlet weak var heightOfAddAndRemove: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemove: Button!
    
    weak var delegateContact: contactListner?

    var login:[String: String]?
    var safelistArray:[Safelist]?
    var isFromEdit = false
    var isFromShare = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromShare {
            addDoneButton()
            heightOfAddAndRemove.constant = -10
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getSafelist()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - nav bar right button
    func addDoneButton() {
        let btnDone = UIButton(type: .custom)
        btnDone.setTitle("Done", for: .normal)
        btnDone.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btnDone.addTarget(self, action: #selector(doneSharing), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btnDone)
        
        self.navigationItem.setRightBarButtonItems([item2], animated: true)

    }
    
    //MARK: - done sharing
    func doneSharing() {
        let array = safelistArray?.filter(){$0.isSelected == 1}
        delegateContact?.getUserIds(ids: userIds(value: array) )
        popVC()
        
    }
    
    
    //MARK: Handle response
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                self.safelistArray = value.contacts
                tableView?.estimatedRowHeight = 89
                setupTableView(tableView: tableView, cellId: "SafelistTableViewCell", items: safelistArray)
                tableView.reloadData()
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
    }
    
    
    //MARK: get safelist API
    func getSafelist() {
        safelistArray = []
        
        APIManager.shared.request(with: LoginEndpoint.safelist(accessToken: "$2y$10$AFo5Pnyf164YOUUlbfq.rO9Nb1HMGu3oBQBKwS56r9sZuwACLHrZK"), completion: { (response) in
            
            self.handle(response: response)
            
        })
        
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
        
        let array = safelistArray?.filter(){$0.isSelected == 1}
        if !(array?.isEmpty)! {
            self.ApiSafelist(array: userIds(value: array), check: .remove)
        }
        
        safelistArray = safelistArray?.filter(){$0.isSelected != 1}
        dataSource?.items = safelistArray
        tableView.reloadData()
    }
    
    //MARK: get user ids
    func userIds(value: [Safelist]?) -> [String] {
        var ids:[String] = []
        for user in value! {
            ids.append(user.id!)
        }
        return ids
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
            return LoginEndpoint.addSafelist(accessToken: "$2y$10$AFo5Pnyf164YOUUlbfq.rO9Nb1HMGu3oBQBKwS56r9sZuwACLHrZK")
        case .remove:
            return LoginEndpoint.removeSafeuser(accessToken: "$2y$10$AFo5Pnyf164YOUUlbfq.rO9Nb1HMGu3oBQBKwS56r9sZuwACLHrZK")
        }
        
    }
    
}



extension SafeListViewController {
    
    //MARK: setup tableview
    override func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items: items as Array<AnyObject>? , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: {[unowned self] (cell, item, indexPath) in
            
            print(cell)
            
            (cell as? SafelistCell)?.objSafeuser = item as? Safelist
            
            if self.isFromShare {
                (cell as? SafelistCell)?.imageViewStaticPhone.isHidden = !self.isFromShare
                (cell as? SafelistCell)?.checkBoxContact.isHidden = (self.isFromShare)
            } else {
                (cell as? SafelistCell)?.imageViewStaticPhone.isHidden = self.isFromEdit
                (cell as? SafelistCell)?.checkBoxContact.isHidden = !(self.isFromEdit)
            }

            
            }, aRowSelectedListener: { (indexPath) in
                
                print(indexPath)
                
                if self.isFromEdit || self.isFromShare {
                    if self.safelistArray?[indexPath[1]].isSelected == 0 {
                        self.safelistArray?[indexPath[1]].isSelected = 1
                    } else {
                        self.safelistArray?[indexPath[1]].isSelected = 0
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
