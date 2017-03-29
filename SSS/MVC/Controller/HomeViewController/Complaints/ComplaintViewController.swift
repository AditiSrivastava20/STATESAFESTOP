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
            }
            
            if let value = responseValue as? [Complaint]{
                self.arrayComplaints = value
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
    //MARK: - get complaints list
    func getComplaints() {
        
        arrayComplaints = []
        
//        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
//            return
//        }
//        
//        APIManager.shared.request(with: LoginEndpoint.complaintList(accessToken: /login["access_token"]), completion: {
//            (response) in
//            
//            self.handle(response: response)
//        })
        
        let arrayData = [
            [
                "title": "Car Parking Issue",
                "description": "Car Parking Issue",
                "created_at": "2017-03-24 12:59:53",
                "fullname": "Varun",
                "email": "varunarora@gmail.com",
                "media_content": "https://s3.ap-south-1.amazonaws.com/safestatestop/media_images/cdc65ff6ba5ea0479682eeb6bPYFZWfJwlE8qyh5tJtgC1zNaj.mp4"
            ]
        ]
        
        let json = JSON(arrayData)
        
        for dict in json.arrayValue {
            
            do {
                let item = try Complaint(attributes: dict.dictionaryValue)
                arrayComplaints?.append(item)
            } catch {
                
            }
        }
        
        tableView?.estimatedRowHeight = 84
        setupTableView(tableView: tableView, cellId: "ComplaintTableViewCell", items: arrayComplaints)
        
    }
    
}


// MARK: - IndicatorInfoProvider

extension ComplaintViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}
