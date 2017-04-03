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
import Photos



protocol mediaSelectListner : class {
    
    func getMedia(id : String?,name : String?)
}



class RecordingViewController: BaseViewController {

    weak var delegateMedia : mediaSelectListner?
    
    var switchToHome : ((_ isHome: Bool) -> ())?
    
    @IBOutlet weak var lblNoRecordings: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var login:User?
    var isFromMediaSelection = false
    var itemInfo = IndicatorInfo(title: "RECORDING")
    var selectedMediaId:String = ""
    var arrayRecording:[Recording]?
    var askForPin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        login = UserDataSingleton.sharedInstance.loggedInUser

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecordings()
    }
    
    //MARK: - handle response
    func handle(response: Response, check: Recordinglist ) {
        
        switch response{
        case .success(let responseValue):
            if let value = responseValue as? User{
                print(value.msg ?? "")
                
                noRecordingsLabel(array: value.recordings ,check)
            }
            
        case .failure(let str):
            Alerts.shared.show(alert: .oops, message: /str, type: .error)
        }
        
    }
    
    //MARK: - populate list / share response
    func noRecordingsLabel(array: [Recording]?,  _ check: Recordinglist) {
        
        switch check {
            
        case .populate:
            arrayRecording = array
            self.setupTableview()
            
            if (arrayRecording?.isEmpty)! {
                lblNoRecordings.isHidden = false
            } else {
                lblNoRecordings.isHidden = true
            }
        
        case .share:
            Alerts.shared.show(alert: .success, message: /Alert.shared.rawValue , type: .success)
            
        }
        
    }
    
    
    //MARK: - setup tableview
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
            
            if askForPin {
                let vc = StoryboardScene.Main.instantiatePinValidationViewController()
                vc.delegatePin = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                presentVC(vc)
        }
        
    }
    
    //MARK: validate pin password
    func validatePin( value: String?) {
        
        if (/value).isEqual(login?.profile?.pin_password) {
            self.askForPin = false
            print(value ?? "")
        } else {
            self.switchToHome?(true)
        }
        
    }
    
    //MARK: - hit get recording list api
    func getRecordings() {
        
        arrayRecording = []
        
        APIManager.shared.request(with: LoginEndpoint.recordingList(accessToken: login?.profile?.access_token), completion: {
            (response) in
            
            self.handle(response: response, check: .populate)
            
        })
    }
    
   
}

extension RecordingViewController: UIActionSheetDelegate {
    
    //MARK: Action sheet
    func btnActionSheetAction(sender : UIButton) {
        
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let shareActionButton = UIAlertAction(title: "Share", style: .default) { action -> Void in
            print("Share")
            self.shareMediaFromRecordings(media_id: self.arrayRecording?[sender.tag].id)
        }
        actionSheetController.addAction(shareActionButton)

        let saveActionButton = UIAlertAction(title: "Save", style: .default) { action -> Void in
            print("Save")
            self.downloadVideoFrom(url: self.arrayRecording?[sender.tag].media_content)
        }
        actionSheetController.addAction(saveActionButton)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    //MARK: - Share media
    func shareMediaFromRecordings(media_id: String?) {
        self.selectedMediaId = media_id!
        let vc = StoryboardScene.Main.instantiateSafeListViewController()
        vc.delegateContact = self
        vc.isFromShare = true
        pushVC(vc)
        
    }
    
    
    //MARK: -  Download media
    func downloadVideoFrom(url :String?){
        
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url ?? ""),
                let urlData = NSData(contentsOf: url)
            {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4";
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
        
    }
    
    
}


//MARK: - User id listner for sharing media
extension RecordingViewController : contactListner {
    
    func getUserIds(ids: [String]?) {
        
        if let _ = ids {
            print("share")
            
            if !(ids?.isEmpty)! {
                APIManager.shared.request(withArrays: LoginEndpoint.shareothermedia(accessToken: login?.access_token), arrayOne: [selectedMediaId], arrayTwo: ids, completion: { (response) in
                    
                    self.handle(response: response, check: .share)
                    
                })
            }
            
        } else {
            print("none selected")
        }
        
    }
    
}






extension RecordingViewController : UITableViewDelegate{
    
    //MARK: - Tableview datasource
    override func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items:items , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: { (cell, item, indexPath) in
            
            (cell as? RecordingTableViewCell)?.objRecording = item as? Recording
            (cell as? RecordingTableViewCell)?.btnActionSheet.tag = ((indexPath as? IndexPath)?.row ?? 0 )
            (cell as? RecordingTableViewCell)?.btnActionSheet.addTarget(self, action: #selector(self.btnActionSheetAction), for: .touchUpInside)
            
            if self.isFromMediaSelection {
                (cell as? RecordingTableViewCell)?.btnActionSheet.isHidden = true
            }
            
        }, aRowSelectedListener: { (indexPath) in
            
        }) { (scrollView) in
            
        }
        
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        
    }

    
    
    //MARK: - Tableview delegate
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

