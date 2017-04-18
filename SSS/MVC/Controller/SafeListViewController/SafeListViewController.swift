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
import EZSwiftExtensions
import EVContactsPicker

protocol contactListner: class {
    
    func getUserIds(ids: [String]?)
}


class SafeListViewController: BaseViewController {
    
    
    @IBOutlet weak var heightOfAddAndRemove: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemove: Button!
    @IBOutlet weak var btnAdd: Button!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var lblSafelist: UILabel!
    
    
    weak var delegateContact: contactListner?

    var login:User?
    var safelistArray:[Safelist]?
    var skipList:String = ""
    var isFromEdit = false
    var isFromShare = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.isHidden = true
        lblSafelist.isHidden = true
        btnRemove.isHidden = true
        
        //done button for sharing media
        doneButtonAttributes()
        
        //setup tableview
        safelistArray = []
        tableView?.estimatedRowHeight = 89
        setupTableView(tableView: tableView, cellId: "SafelistTableViewCell", items: safelistArray)
        
        startLoader()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        login = UserDataSingleton.sharedInstance.loggedInUser

        ApiSafelist(array: nil, check: .get)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        popVC()
    }
    
    
    //MARK: - done button attributes
    func doneButtonAttributes() {
        btnDone.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        if isFromShare {
            btnDone.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            heightOfAddAndRemove.constant = 0
        }
    }
    
    //MARK: - Done button action for sharing media
    @IBAction func btnDoneAction(_ sender: UIBarButtonItem) {
        let array = safelistArray?.filter(){$0.isSelected == 1}
        delegateContact?.getUserIds(ids: userIds(value: array) )
        popVC()

    }
    
    
    
    //MARK: Handle response
    func handle(response: Response, check: Safeusers) {
        
        btnAdd.isHidden = false
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                if let _ = value.skip_numbers {
                    
                    if value.type == "0" {
                        
                        Alerts.shared.show(alert: .success, message: "Successfully added", type: .success)
                        
                    } else if value.type == "1" {
                        
                        Alerts.shared.show(alert: .alert, message: "User already exist", type: .error)
                        
                    } else if value.type == "2" {
                        
                        Alerts.shared.show(alert: .alert, message: "Cannot add your own number", type: .error)
                    }
                }
                
                updateTableView(array: value.contacts ,check: check)
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .alert, message: /str, type: .error)
        }
    }
    
    //MARK: updateTableView
    func updateTableView(array: [Safelist]? ,check: Safeusers) {
        
        switch check {
            
        case .get:
            self.safelistArray = array
            dataSource?.items = self.safelistArray
            
            tableView.reloadData()
            
        case .add, .remove:
            ApiSafelist(array: nil, check: .get)
            print("add/removed")
            
        }
        
        lblSafelist.isHidden = safelistArray?.count != 0
        btnRemove.isHidden = safelistArray?.count == 0
    }
    
    
    
    //MARK: Add safeuser action
    @IBAction func btnAddAction(_ sender: Any) {
        
  
        let contactPicker = EVContactsPickerViewController()
        contactPicker.delegate = self
        
        self.navigationController?.pushViewController(contactPicker, animated: true)
        
        
//        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.email)
//        let navigationController = UINavigationController(rootViewController: contactPickerScene)
//        self.present(navigationController, animated: true, completion: nil)
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
    
    //MARK: Get/Add/Remove safelist
    func ApiSafelist(array: [String]?, check: Safeusers) {
        print(array ?? "")
        
        switch check {
        case .get:
            APIManager.shared.request(with: endPoint(check: check), completion: { [weak self] (response) in

                self?.stopLoader()
                
                self?.handle(response: response, check: check)
            })
            
        case .add, .remove:
            
            startLoader()
            
            APIManager.shared.request(withArray: endPoint(check: check) , array: array, completion: { [weak self] (response) in
                
                self?.stopLoader()
                
                self?.handle(response: response, check: check)
            })
            
        }
        
    }
    
    //MARK: select endpoint
    func endPoint(check: Safeusers) -> Router {
        
        switch check {
        case .add:
            return LoginEndpoint.addSafelist(accessToken: login?.profile?.access_token  )
        case .remove:
            return LoginEndpoint.removeSafeuser(accessToken: login?.profile?.access_token)
        case .get:
            return LoginEndpoint.safelist(accessToken: login?.profile?.access_token)
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
                (cell as? SafelistCell)?.imageViewStaticPhone.isHidden = true
                (cell as? SafelistCell)?.checkBoxContact.isHidden = false
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


extension SafeListViewController: EVContactsPickerDelegate {
    
   
    func didChooseContacts(_ contacts: [EVContactProtocol]?) {
        var safeuser:[String] = []
        
        if let cons = contacts {
            for con in cons {
                
                let num = "\(con.phone)".digits
                
                if !safeuser.contains(num) {
                    safeuser.append("\(num)")
                }
                
                print("\(String(describing: con.phone))")
            }
        }
        self.navigationController?.popViewController(animated: true)
        print(safeuser)
        
        if !safeuser.isEmpty {
            self.ApiSafelist(array: safeuser, check: .add)
        }
        
    }

}
    

