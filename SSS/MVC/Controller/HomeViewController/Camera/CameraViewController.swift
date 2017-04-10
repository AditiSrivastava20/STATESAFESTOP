//
//  CameraViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/23/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import EZSwiftExtensions
import ISMessages
import NVActivityIndicatorView
import PermissionScope


class CameraViewController: RecorderViewController, NVActivityIndicatorViewable {

    var onSwitchVc : ((_ isRecording: Bool) -> ())?
    
    var itemInfo = IndicatorInfo(title: "Home")
     let vision = PBJVision.sharedInstance()
     var progressTimer = Timer()
     var progress : CGFloat = 0
     var previewView : UIView?
     var focusView : UIView?
 
    @IBOutlet weak var viewRecorder: UIView!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var imgMic: UIImageView!
    
//    let pscope = PermissionScope()

    let maxCaptureDuration = 60.0
    var paths = [String]()
    
    
    @IBOutlet weak var progressView: RPCircularProgress!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    var isPalyerStopByUser = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgMic.isHidden = true
        
        vision.clearAllDirectoryFiles()
        
        setupPreview()
        
        paths = []
        progressView.updateProgress(0.0)
        setupCamera()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusLabel?.text = "0:00"
        self.endVideoRecording()
    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ISMessages.hideAlert(animated: true)
    }

    
    @IBAction func actionBtnLocation(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        
        guard let login = UserDataSingleton.sharedInstance.loggedInUser else {
            return
        }
        
   
        LocationManager.sharedInstance.startTrackingUser { (lat, lng, locationName) in
            
            UIApplication.shared.beginIgnoringInteractionEvents()

            APIManager.shared.request(with: LoginEndpoint.shareLocation(accessToken: login.profile?.access_token, locatiom_name: locationName, latitude: "\(lat)", longitude: "\(lng)"), completion: { (response) in
                
                self.handle(response: response)
            })
            
        }
        
       
    }

    
    @IBAction func actionBtnRecordings(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        self.onSwitchVc?(true)
        
    }
    
    
    @IBAction func actionBtnComplaints(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        self.onSwitchVc?(false)
    }

    @IBAction func actionBtnAudio(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        self.endVideoRecording()
        
        viewCamera.isHidden = true
        imgMic.isHidden = false
        isPalyerStopByUser = false
        btnVideo.backgroundColor = UIColor.black
        btnAudio.backgroundColor = colors.appColor.color()
        btnAudio.isSelected = true
        btnVideo.isSelected = false
        recordButton.isHidden = true
        viewRecorder.isHidden = false
        recordButton.isSelected = false
         progressView.updateProgress(0.0)
        resetTimer()
       
        
    }
    
   
   
    @IBAction func actionBtnVideo(_ sender: Any) {
        ISMessages.hideAlert(animated: true)
        
        viewCamera.isHidden = false
        imgMic.isHidden = true
        btnVideo.backgroundColor = colors.appColor.color()
        btnAudio.backgroundColor = UIColor.black
        btnAudio.isSelected = false
        btnVideo.isSelected = true
        recordButton.isHidden = false
        viewRecorder.isHidden = true
        isPalyerStopByUser = true
        
        stop(UIButton())
    }
   
    
    override func appMovedToBackground() {
        
        if recordButton.isSelected {
            statusLabel?.text = "0:00"
            self.endVideoRecording()
        }
        
    }
    
    
    func endVideoRecording() {
        UIApplication.shared.isIdleTimerDisabled = false
        statusLabel?.text = "0:00"
        recordButton.tintColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        
        progressView.updateProgress(0.0)
        vision.endVideoCapture()
        recordButton.isSelected = false
        
    }
    
  
    
    @IBAction func actionBtnRecord(_ sender: UIButton) {
        ISMessages.hideAlert(animated: true)
        
        switch PermissionScope().statusCamera() {
        case .authorized:
            
            if sender.isSelected {
                
                btnAudio.isEnabled = true
                self.endVideoRecording()
                
            }
            else{
                // start video
                sender.isSelected = true
                btnAudio.isEnabled = false
                vision.startVideoCapture()
                recordButton.tintColor = UIColor(red:0.61, green:0.00, blue:0.00, alpha:1.0)
                UIApplication.shared.isIdleTimerDisabled = true
                
                progressView.updateProgress(1.0, animated: true, initialDelay: 0, duration: maxCaptureDuration, completion: {
                    
                    if sender.isSelected == true {
                        
                        self.vision.endVideoCapture()
                    }
                    
                })
            }

            
        default:
            Alerts.shared.show(alert: .error, message: "Permission requied for camera", type: .error)
            return
        }
        
    }
    
    func focusPressed(sender: UITapGestureRecognizer)
    {
        
        let adjustPoint = sender.location(in: self.view)
        
        
        self.focusView?.alpha = 0.0
        self.focusView?.center = adjustPoint
        self.focusView?.backgroundColor = UIColor.clear
        self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.addSubview(self.focusView!)
        view.bringSubview(toFront: focusView!)
        PBJVision.sharedInstance().focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustPoint)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseIn,
                                   animations: {
                                    self.focusView!.alpha = 1.0
                                    self.focusView!.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(finished) in
            self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.focusView!.removeFromSuperview()
        })
    }


}

extension CameraViewController : PBJVisionDelegate {
    
    
    
    func setupPreview() {
        previewView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0) )
        previewView?.backgroundColor = UIColor.darkGray
        let frame = self.view.bounds
        previewView?.frame = frame
        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = frame
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView?.layer.addSublayer(previewLayer)
    }
    
    
    
    func initailize() {
        vision.cameraMode = .video
        vision.delegate = self
        vision.cameraOrientation = .portrait
        vision.focusMode = .continuousAutoFocus
        vision.outputFormat = .preset
        //vision.videoRenderingEnabled = true
        vision.exposureMode = .continuousAutoExposure
        //vision.additionalCompressionProperties = [AVVideoProfileLevelKey: AVVideoProfileLevelH264Baseline30]
        vision.defaultVideoThumbnails = true
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        vision.additionalVideoProperties = [AVVideoWidthKey : NSNumber(value:Double(width)),AVVideoHeightKey : NSNumber(value:Double(height)), AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill]
        vision.autoFreezePreviewDuringCapture = false
        self.focusView   = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        let focusImg = UIImageView(image: UIImage(named: "ic_focus") )
        self.focusView?.addSubview(focusImg)
    
        vision.captureSessionPreset = AVCaptureSessionPreset640x480
        
    }
    
    
    func setupCamera() {
        paths = []
        initailize()
        vision.cameraDevice = .back
        vision.maximumCaptureDuration = CMTimeMakeWithSeconds(maxCaptureDuration, 600)
        vision.stopPreview()
        vision.startPreview()
    
    }
    
    func visionSessionDidStart(_ vision: PBJVision) {
        if previewView?.superview == nil {
            viewCamera.addSubview(previewView!)
        }
      
    }
    

    
    func vision(_ vision: PBJVision, didCaptureVideoSampleBuffer sampleBuffer: CMSampleBuffer) {
        
        let min = Int(vision.capturedVideoSeconds / 60)
        let sec = Int(vision.capturedVideoSeconds.truncatingRemainder(dividingBy: 60))
        let s = String(format: "%02d:%02d", min, sec)
        statusLabel.text = s
        if vision.capturedVideoSeconds >= maxCaptureDuration - 1 {
    
             progressView.updateProgress(0.0)
            statusLabel?.text = "0:00"
            vision.endVideoCapture()
        }
    }
    

    
    
    func vision(_ vision: PBJVision, capturedVideo videoDict: [AnyHashable : Any]?, error: Error?) {
        
        
        if !isPalyerStopByUser {
            statusLabel?.text = "0:00"
            return
        }

        
        if error != nil  && videoDict == nil{
            // UtilityFunctions.showAlert(error?.localizedDescription, message: error?.localizedRecoveryOptions?.first, viewController: self)
            return
        }

        let urlStr = NSURL(fileURLWithPath: videoDict?["PBJVisionVideoPathKey"] as! String)
        recordingDone(recordedUrl: urlStr as URL, thumb: (videoDict?["PBJVisionVideoThumbnailKey"] as? UIImage))
        
//        let player = AVPlayerViewController(nibName: nil, bundle: nil)
//        player.player = AVPlayer(url: urlStr as URL )
//        self.present(player, animated: true, completion: nil)
        
    }
    
    
    override func recordingDone(recordedUrl : URL?, thumb: UIImage?){
        
        print(recordedUrl ?? "")
        if let recordedDataUrl = recordedUrl {
            do {
                let mediaData = try Data(contentsOf: recordedDataUrl as URL)
                mediaUploadApi(data: mediaData, type: thumb == nil ?  .audio : .video , thumb: thumb )
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
  
}

 // MARK: - IndicatorInfoProvider

extension CameraViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

extension CameraViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


