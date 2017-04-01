//
//  ComplaintViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/23/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON


class ComplaintViewController: BaseViewController {

    
    var itemInfo = IndicatorInfo(title: "COMPLAINT")
    var arrayComplaints:[Complaint]?
    
    @IBOutlet weak internal var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getComplaints()
    }
    
    
    //MARK: - Handle response
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                self.arrayComplaints = value.complaints
                tableView?.estimatedRowHeight = 84
                setupTableView(tableView: tableView, cellId: "ComplaintTableViewCell", items: arrayComplaints)
                tableView.reloadData()
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
    //MARK: - get complaints list
    func getComplaints() {
        
        arrayComplaints = []
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        APIManager.shared.request(with: LoginEndpoint.complaintList(accessToken: login.access_token), completion: {
            (response) in
            
            self.handle(response: response)
        })
    }
    
}


// MARK: - IndicatorInfoProvider

extension ComplaintViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}
