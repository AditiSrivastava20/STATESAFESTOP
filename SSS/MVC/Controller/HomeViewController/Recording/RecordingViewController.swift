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
import NVActivityIndicatorView
import ISMessages
import Kingfisher



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
    var arrayRecording:[Recording] = []
    var askForPin = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoRecordings.isHidden = true
        
        guard let _ = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
        login = UserDataSingleton.sharedInstance.loggedInUser
        
        tableView?.estimatedRowHeight = 84
        setupTableView(tableView: tableView, cellId: "RecordingTableViewCell", items: arrayRecording)
        tableView.delegate = self
        
        //Loader
        if isFromMediaSelection {
            Loader.shared.start()
        }

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getRecordings()
    }
    
    
    //MARK: - Tap on name
    func tappedOnName(_ sender: UITapGestureRecognizer) {
        
        print("select")
        
        if let lbl = sender.view as? UILabel {
            
            print(lbl.tag)
            selectMediaFromRecordings(index: lbl.tag)
        }
    }
    
    //MARK: - Tap on image
    func tappedOnImage(_ sender: UITapGestureRecognizer) {
        print("play")
        
        if let img = sender.view as? UIImageView {
            
            print(img.tag)
            guard let urlMedia = arrayRecording[img.tag].media_content else {return}
            playMedia(urlMedia: urlMedia)
            
        }
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
            Alerts.shared.show(alert: .alert, message: /str, type: .error)
        }
        
    }
    
    //MARK: - populate list / share response
    func noRecordingsLabel(array: [Recording]?,  _ check: Recordinglist) {
        
        switch check {
            
        case .populate:
            arrayRecording = array!
            self.setupTableview()
            
            lblNoRecordings.isHidden = arrayRecording.count != 0
            
        case .share:
            Alerts.shared.show(alert: .success, message: /Alert.shared.rawValue , type: .success)
            
        }
        
    }
    
    
    //MARK: - setup tableview
    func setupTableview() {
        
        dataSource?.items = arrayRecording
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
        } else if (/value).isEmpty {
            
            Alerts.shared.show(alert: .alert, message: /Alert.noPinEntered.rawValue, type: .error)
            
            if isFromMediaSelection {
                popVC()
            } else {
                self.switchToHome?(true)
            }
            
        } else {
            Alerts.shared.show(alert: .alert, message: /Alert.incorrectPin.rawValue, type: .error)
            
            if isFromMediaSelection {
                popVC()
            } else {
                self.switchToHome?(true)
            }
            
        }
        
    }
    
    //MARK: - hit get recording list api
    func getRecordings() {
        
        //Api
        APIManager.shared.request(with: LoginEndpoint.recordingList(accessToken: login?.profile?.access_token), completion: { [weak self]
            (response) in
            

            Loader.shared.stop()
            
            self?.handle(response: response, check: .populate)
            
        })
    }
    
    //MARK: - Play media from URL
    func playMedia(urlMedia: String?) {
        
        let videoURL = URL(string: urlMedia!)
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


//MARK: Action sheet
extension RecordingViewController: UIActionSheetDelegate {
    
    
    func btnActionSheetAction(sender : UIButton) {
        ISMessages.hideAlert(animated: true)
        
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        
        let shareActionButton = UIAlertAction(title: "Share", style: .default) { action -> Void in
            print("Share")
            self.shareMediaFromRecordings(media_id: self.arrayRecording[sender.tag].id)
        }
        actionSheetController.addAction(shareActionButton)
            
        let shareViaActionButton = UIAlertAction(title: "Share via..", style: .default) { action -> Void in
            print("Share")
            self.shareMediaFromRecordingsVia(media: self.arrayRecording[sender.tag])
        }
        actionSheetController.addAction(shareViaActionButton)
            
        let saveActionButton = UIAlertAction(title: "Save", style: .default) { action -> Void in
            print("Save")
            self.downloadVideoFrom(url: self.arrayRecording[sender.tag].media_content)
        }
        actionSheetController.addAction(saveActionButton)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - share via social media
    func shareMediaFromRecordingsVia(media: Recording?) {
        
        let firstActivityItem = "Share media "
        let secondActivityItem : NSURL = NSURL(string: /media?.media_content )!
        // If you want to put an image
        
        var image:UIImageView?
        image?.image = Image.blankImage()
        
        image?.kf.setImage(with: URL(string: /media?.media_content), placeholder: Image.blankImage(), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image?.image], applicationActivities: nil)
        
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,

        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Select media for complaint
    func selectMediaFromRecordings(index: Int) {
        
        delegateMedia?.getMedia(id: self.arrayRecording[index].id , name : arrayRecording[index].media_content)
        popVC()
        
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
        
        Download.shared.downloadMediaFrom(url: url)
        
    }
    
    
}


//MARK: - User id listner for sharing media
extension RecordingViewController : contactListner {
    
    func getUserIds(ids: [String]?) {
        
        if let _ = ids {
            print("share")
            
            if !(ids?.isEmpty)! {
                
                Loader.shared.start()
                
                APIManager.shared.request(withArrays: LoginEndpoint.shareothermedia(accessToken: login?.profile?.access_token), arrayOne: [selectedMediaId], arrayTwo: ids, completion: { (response) in
                    
                    Loader.shared.stop()
                    
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
            (cell as? RecordingTableViewCell)?.labelName.tag = ((indexPath as? IndexPath)?.row ?? 0 )
            (cell as? RecordingTableViewCell)?.imageViewUser.tag = ((indexPath as? IndexPath)?.row ?? 0 )
            (cell as? RecordingTableViewCell)?.btnActionSheet.tag = ((indexPath as? IndexPath)?.row ?? 0 )
            (cell as? RecordingTableViewCell)?.btnActionSheet.addTarget(self, action: #selector(self.btnActionSheetAction), for: .touchUpInside)
            (cell as? RecordingTableViewCell)?.btnActionSheet.isHidden = self.isFromMediaSelection
            
            if self.isFromMediaSelection {
                
                let tapToPlay = UITapGestureRecognizer(target: self, action:  #selector(self.tappedOnImage(_:)))
                let tapToSelect = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnName(_:)))
                
                (cell as? RecordingTableViewCell)?.labelName.addGestureRecognizer(tapToSelect)
                (cell as? RecordingTableViewCell)?.imageViewUser.addGestureRecognizer(tapToPlay)
                
            }
            
            
        }, aRowSelectedListener: { (indexPath) in
            
        }) { (scrollView) in
            
        }
        
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        
    }

    
    
    //MARK: - Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isFromMediaSelection {
            
            guard let urlMedia = arrayRecording[indexPath.row].media_content else {return}
            
            self.playMedia(urlMedia: urlMedia)
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

