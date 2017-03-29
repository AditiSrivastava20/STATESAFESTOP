//
//  NotificationViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource : NotificationTableviewDataSource?{
        
        didSet{
            
         tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.estimatedRowHeight = 84
        // Do any additional setup after loading the view.
    }

   
    @IBAction func actionBtnBack(_ sender: Any) {
        popVC()
    }
    

    
}

extension NotificationViewController {
    
    func setupTableView(){
        
        dataSource = NotificationTableviewDataSource(items: ["","","","","","","",""], height:UITableViewAutomaticDimension , tableView: tableView, cellIdentifier: "temp", configureCellBlock: { (cell, item, indexPath) in
            
        }, aRowSelectedListener: { (indexPath) in
            
        }, DidScrollListener: { (scrollView) in
            
            
        })
        
    }
    
}
