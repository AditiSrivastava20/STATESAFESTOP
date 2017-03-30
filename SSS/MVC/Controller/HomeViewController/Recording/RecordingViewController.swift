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


protocol mediaSelectListner : class {
    
    func getMedia(id : String?,name : String?)
}



class RecordingViewController: BaseViewController {

    weak var delegateMedia : mediaSelectListner?
    
    var switchToHome : ((_ isHome: Bool) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    
    var isFromMediaSelection = false
    var itemInfo = IndicatorInfo(title: "RECORDING")
    
    var arrayRecording:[Recording]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showPopUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecordings()
    }
    
    func handle(response: Response) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                self.arrayRecording = value.recordings
                self.setupTableview()
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    
    func setupTableview() {
        tableView?.estimatedRowHeight = 84
        setupTableView(tableView: tableView, cellId: "RecordingTableViewCell", items: arrayRecording)
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    //MARK: - Back Action
    @IBAction func backAction(_ sender: Any) {
        popVC()
    }
    
    
    //MARK: - pin password pop up
    func showPopUp() {
        let vc = StoryboardScene.Main.instantiatePinValidationViewController()
        vc.delegatePin = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        presentVC(vc)
    }
    
    //MARK: validate pin password
    func validatePin( value: String?) {
        
        if (/value).isEmpty {
            self.switchToHome?(true)
        } else {
            print(value ?? "")
        }
        
    }
    
    //MARK: - hit get recording list api
    func getRecordings() {
        
        arrayRecording = []
        
//        guard let login = UserDefaults.standard.value(forKey: "login") as? [String: String] else {
//            return
//        }
//        
        APIManager.shared.request(with: LoginEndpoint.recordingList(accessToken: "$2y$10$AFo5Pnyf164YOUUlbfq.rO9Nb1HMGu3oBQBKwS56r9sZuwACLHrZK"), completion: {
            (response) in
            
            self.handle(response: response)
            
        })
    }

}

//MARK: - Tableview delegate
extension RecordingViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isFromMediaSelection {
            
            delegateMedia?.getMedia(id: arrayRecording?[indexPath.row].id ,name : arrayRecording?[indexPath.row].media_content)
            popVC()
        }else {
        
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
}



// MARK: - IndicatorInfoProvider

extension RecordingViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

//MARK: - pin password listner

extension RecordingViewController  : pinEnteredListner {
    
    func getPinCode(pin : String?) {
        
        self.validatePin(value: pin)
    }
    
}

