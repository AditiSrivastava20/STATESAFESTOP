//
//  NotificationViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import AVKit
import EZSwiftExtensions


class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoNotifications: UILabel!
    
    
    var arrayNotifications:[NotificationData] = []
    
    var dataSource : NotificationTableviewDataSource?{
        
        didSet{
            
         tableView?.dataSource = dataSource
         tableView?.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoNotifications.isHidden = true
        tableView.isHidden = true
        
        tableView.estimatedRowHeight = 84
        setupTableView(tableView: tableView, items: arrayNotifications)
        
        // Do any additional setup after loading the view.
    }
    
    
    func handle(response: Response) {
        
        switch response {
            
        case .success(let responseValue):
            
            if let value = responseValue as? User {
                
                if let array = value.notifications {
                    arrayNotifications = array
                    dataSource?.items = arrayNotifications
                    tableView.reloadData()
                }
                lblNoNotifications.isHidden = arrayNotifications.count != 0
                tableView.isHidden = arrayNotifications.count == 0
            }
        
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getNotificationList()
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        sideMenuController()?.sideMenu?.allowRightSwipe = true
        sideMenuController()?.sideMenu?.allowPanGesture = true
    }
    

   
    @IBAction func actionBtnBack(_ sender: Any) {
        popVC()
    }
    
    
    //MARK: - Get Notifications api
    func getNotificationList() {
        
        APIManager.shared.request(with: LoginEndpoint.notification(accessToken: UserDataSingleton.sharedInstance.loggedInUser?.profile?.access_token) , completion: {(response) in
            
            self.handle(response: response)
        })
        
    }
    
    
    func btnDownloadAction(sender: UIButton) {
        
        let url = arrayNotifications[sender.tag].media_content
        
        Download.shared.downloadMediaFrom(url: url) 
        
    }
    
    func openMaps(sender: UIButton) {
        print("open map")
        
        let latitude: CLLocationDegrees = Double(arrayNotifications[sender.tag].latitude!)!
        let longitude: CLLocationDegrees = Double(arrayNotifications[sender.tag].longitude!)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    

    
}

extension NotificationViewController: UITableViewDelegate {
    
    func setupTableView(tableView : UITableView? , items : [Any]?){
        
        dataSource = NotificationTableviewDataSource(items: items, height:UITableViewAutomaticDimension , tableView: tableView, cellIdentifier: "temp", configureCellBlock: { (cell, item, indexPath) in
                
            let type = MediaType(rawValue: ((item as? NotificationData)?.media_type!)! ) ?? .none
            
            switch type {
                
            case .video,.audio:
                (cell as? NotificationAttachmentTableViewCell)?.objNotification = item as! NotificationData?
                (cell as? NotificationAttachmentTableViewCell)?.btnDownload.tag = ((indexPath as? IndexPath)?.row ?? 0 )
                (cell as? NotificationAttachmentTableViewCell)?.btnDownload.addTarget(self, action: #selector(self.btnDownloadAction), for: .touchUpInside)
                
            default:
                (cell as? NotificationTableViewCell)?.objNotification = item as! NotificationData?
                (cell as? NotificationTableViewCell)?.btnGoToMaps.tag = ((indexPath as? IndexPath)?.row ?? 0 )
                
                let type = self.arrayNotifications[((indexPath as? IndexPath)?.row ?? 0 )].notification_type
                
                if type == "3" {
                    (cell as? NotificationTableViewCell)?.btnGoToMapsHeight.constant = 0
                    (cell as? NotificationTableViewCell)?.btnGoToMaps.isHidden = true
                    
                } else {
                    (cell as? NotificationTableViewCell)?.btnGoToMaps.addTarget(self, action: #selector(self.openMaps), for: .touchUpInside)
                }
                
                
                
            }
            
        }, aRowSelectedListener: { (indexPath) in
            
            
        }, DidScrollListener: { (scrollView) in
            
            
        })
        
    }
    
    //MARK: - Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrayNotifications[indexPath.row].notification_type == "2" {
            
            guard let urlMedia = arrayNotifications[indexPath.row].media_content else {return}
            
            let videoURL = URL(string: urlMedia)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            ez.runThisInMainThread {
                
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            
            
        }
        
        
        
    }
    
    
}
