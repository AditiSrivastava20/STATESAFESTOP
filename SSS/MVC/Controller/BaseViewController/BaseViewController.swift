//
//  BaseViewController.swift
//  SSS
//
//  Created by Sierra 4 on 14/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var dataSource : TableViewDataSource?{
        didSet{
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items: items as Array<AnyObject>? , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: { (cell, item, indexPath) in
            
            //(cell as? SafelistCell)?.objSafeuser = item as? Safelist
            
        }, aRowSelectedListener: { (indexPath) in
            
            print(indexPath)
            
        }) { (scrollView) in
            
        }
        
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        
    }

}


extension BaseViewController: PinCodeTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    
}
