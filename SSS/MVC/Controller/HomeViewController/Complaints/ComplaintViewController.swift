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
    @IBOutlet weak var lblNoComplaints: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoComplaints.isHidden = true
        arrayComplaints = []
        tableView?.estimatedRowHeight = 84
        setupTableView(tableView: tableView, cellId: "ComplaintTableViewCell", items: arrayComplaints)
        tableView.delegate = self
        
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
                
                if let array = value.complaints {
                    self.arrayComplaints = array
                    dataSource?.items = self.arrayComplaints
                    
                    lblNoComplaints.isHidden = self.arrayComplaints?.count != 0
                    
                    tableView.reloadData()
                }
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
    //MARK: - get complaints list
    func getComplaints() {
        
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        APIManager.shared.request(with: LoginEndpoint.complaintList(accessToken: login.profile?.access_token), completion: {
            (response) in
            
            self.handle(response: response)
        })
    }
    
}


extension ComplaintViewController: UITableViewDelegate {
    
    
    //MARK: - Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let obj = arrayComplaints?[indexPath.row] else {return}
        
        let vc = StoryboardScene.Main.instantiateWriteComplaintViewController()
        vc.ShowComplaintDescription = true
        vc.complaint = obj
        self.pushVC(vc)
        
    }
    
    
}



// MARK: - IndicatorInfoProvider

extension ComplaintViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}
