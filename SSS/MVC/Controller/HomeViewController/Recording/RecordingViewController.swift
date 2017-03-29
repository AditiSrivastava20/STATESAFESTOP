//
//  RecordingViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/23/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import EZSwiftExtensions


class RecordingViewController: BaseViewController {

    
     @IBOutlet weak var tableView: UITableView!
    
    var itemInfo = IndicatorInfo(title: "RECORDING")
    
    var arrayRecording:[Recording]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecordings()
    }
    
    func navbar() {
        self.navigationItem.title = "RECORDING"
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(Image(asset: .icBack), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
    }
    
    func goBack() {
        popVC()
    }

    
    
    func getRecordings() {
        
        arrayRecording = []
        
//        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
//            return
//        }
//        
//        APIManager.shared.request(with: LoginEndpoint.recordingList(accessToken: /login["access_token"]), completion: {
//            (response) in
//            
//        })
       
        let arrayData = [
            [
                "id": 1,
                "user_id": 3,
                "media_type": "video",
                "media_content": "https://s3.ap-south-1.amazonaws.com/safestatestop/media_images/cdc65ff6ba5ea0479682eeb6bPYFZWfJwlE8qyh5tJtgC1zNaj.mp4",
                "thumbnail_url": "https://s3.ap-south-1.amazonaws.com/safestatestop/media_images/4ce7a359f0a0b2ba04bd2c2f1YXJMiTnMowXllAzAktYwSM7Wq.jpg",
                "created_at": "2017-03-24 14:10:29",
                "deleted_at": "0000-00-00 00:00:00",
                "is_deleted": 0
            ],
            [
                "id": 4,
                "user_id": 3,
                "media_type": "video",
                "media_content": "https://s3.ap-south-1.amazonaws.com/safestatestop/media_images/e09126b82b7a22a3e921efbc52cthLv5dZ2iBMBF6xUnzqqi2U.mp4",
                "thumbnail_url": "https://s3.ap-south-1.amazonaws.com/safestatestop/media_images/94b1872297965a34564ff18ecNeD6LsRyCRme1D0CPbYdAaDvA.png",
                "created_at": "2017-03-29 10:42:24",
                "deleted_at": "0000-00-00 00:00:00",
                "is_deleted": 0
            ]
        ]
        
        let json = JSON(arrayData)
        
        for dict in json.arrayValue {
            
            do {
                let item = try Recording(attributes: dict.dictionaryValue)
                arrayRecording?.append(item)
            } catch {
                
            }
        }
        
        tableView?.estimatedRowHeight = 84
        setupTableView(tableView: tableView, cellId: "RecordingTableViewCell", items: arrayRecording)
        tableView.delegate = self
        
    }

}

//MARK: - Tableview delegate
extension RecordingViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let urlMedia = arrayRecording?[indexPath.row].media_content else {return}
        
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



// MARK: - IndicatorInfoProvider

extension RecordingViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}


