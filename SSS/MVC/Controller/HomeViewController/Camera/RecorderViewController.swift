//


import UIKit
import AVFoundation
import PermissionScope
import NVActivityIndicatorView
import EZSwiftExtensions

class RecorderViewController: BaseViewController {
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
  
    @IBOutlet var recordBtn: UIButton!
    
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var statusLabel: UILabel!
    

    
    var meterTimer:Timer!
    
    var soundFileURL:URL!
    
    var login:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isUserInteractionEnabled = false
        playButton.isUserInteractionEnabled = false
        setSessionPlayback()
        askForNotifications()
        checkHeadphones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationDidEnterBackground , object: nil)
        
        if let _ = UserDataSingleton.sharedInstance.loggedInUser {
            login = UserDataSingleton.sharedInstance.loggedInUser
        } else {
            return
        }
        
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if (statusLabel.text?.isEqual("01:00"))! {
            
            stop(stopButton)
            
        } else {
            
            if recorder?.isRecording == true {
                print(recorder.currentTime)
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                statusLabel.text = s
                recorder.updateMeters()
                // if you want to draw some graphics...
                //var apc0 = recorder.averagePowerForChannel(0)
                //var peak0 = recorder.peakPowerForChannel(0)
            }

            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    override func appMovedToBackground() {
        
        self.stop(stopButton)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        stop(stopButton)
    }
    
    @IBAction func removeAll(_ sender: AnyObject) {
        deleteAllRecordings()
    }
    
    @IBAction func record(_ sender: UIButton) {
        
        if player != nil && player.isPlaying {
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            playButton.isUserInteractionEnabled = true
            stopButton.isUserInteractionEnabled = true
            recordWithPermission(true)
            setButtonBackground()
            recordBtn.backgroundColor = colors.appColor.color()
            return
        }
        
       else if recorder.isRecording == false {
                
            UIApplication.shared.isIdleTimerDisabled = true
                
            print("recording")
            setButtonBackground()
            recordBtn.backgroundColor = colors.appColor.color()
            playButton.isUserInteractionEnabled = true
            stopButton.isUserInteractionEnabled = true
                
            recorder.record()
            recordWithPermission(false)
            
        }
    }
    
    @IBAction func actionBtnPause(_ sender: Any) {
        
        
        if recorder != nil && recorder.isRecording {
            
            recorder.pause()
            setButtonBackground()
          stopButton.backgroundColor = colors.appColor.color()
            
        }
        
        
        
    }
    
   func setButtonBackground(){
    
    stopButton.backgroundColor = UIColor.clear
    playButton.backgroundColor = UIColor.clear
    recordBtn.backgroundColor = UIColor.clear
    
    }
    
    @IBAction func stop(_ sender: UIButton) {
        print("stop")
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        setButtonBackground()
        playButton.backgroundColor = colors.appColor.color()
        
        recorder?.stop()
        player?.stop()
        
       
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.isUserInteractionEnabled = false
            stopButton.isUserInteractionEnabled = false
            recordBtn.isUserInteractionEnabled = true
            
            //api hit
            
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        ez.dispatchDelay(0.1) {
            
            self.playButton.backgroundColor = colors.appColor.color()
        }
        
        
        
        //recorder = nil
    }
    
    @IBAction func play(_ sender: UIButton) {
        setSessionPlayback()
        play()
    }
    
    func play() {
        
        var url:URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            stopButton.isUserInteractionEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        
    }
    
    
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.startTimer()
                   
                } else {
                    print("Permission to record not granted")
                    Alerts.shared.show(alert: .alert, message: /permissions.microphone.rawValue, type: .error)
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func startTimer(){
        
        
        self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                               target:self,
                                               selector:#selector(RecorderViewController.updateAudioMeter(_:)),
                                               userInfo:nil,
                                               repeats:true)
        
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func deleteAllRecordings() {
        let docsDir =
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileManager = FileManager.default
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: docsDir)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix("m4a")
            })
            for i in 0 ..< recordings.count {
                let path = docsDir + "/" + recordings[i]
                
                print("removing \(path)")
                do {
                    try fileManager.removeItem(atPath: path)
                } catch let error as NSError {
                    NSLog("could not remove \(path)")
                    print(error.localizedDescription)
                }
            }
            
        } catch let error as NSError {
            print("could not get contents of directory at \(docsDir)")
            print(error.localizedDescription)
        }
        
    }
    
    func askForNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecorderViewController.background(_:)),
                                               name:NSNotification.Name.UIApplicationWillResignActive,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecorderViewController.foreground(_:)),
                                               name:NSNotification.Name.UIApplicationWillEnterForeground,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecorderViewController.routeChange(_:)),
                                               name:NSNotification.Name.AVAudioSessionRouteChange,
                                               object:nil)
    }
    
    func background(_ notification:Notification) {
        print("background")
    }
    
    func foreground(_ notification:Notification) {
        print("foreground")
    }
    
    
    func routeChange(_ notification:Notification) {
        print("routeChange \((notification as NSNotification).userInfo)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
        
    }
    
    func checkHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
    @IBAction
    func trim() {
        if self.soundFileURL == nil {
            print("no sound file")
            return
        }
        
        print("trimming \(soundFileURL!.absoluteString)")
        print("trimming path \(soundFileURL!.lastPathComponent)")
        let asset = AVAsset(url:self.soundFileURL!)
        exportAsset(asset, fileName: "trimmed.m4a")
    }
    
    func exportAsset(_ asset:AVAsset, fileName:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
        print("saving to \(trimmedSoundFileURL.absoluteString)")
        
        
        
        if FileManager.default.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
            print("sound exists, removing \(trimmedSoundFileURL.absoluteString)")
            do {
                if try trimmedSoundFileURL.checkResourceIsReachable() {
                    print("is reachable")
                }
                
                try FileManager.default.removeItem(atPath: trimmedSoundFileURL.absoluteString)
            } catch let error as NSError {
                NSLog("could not remove \(trimmedSoundFileURL)")
                print(error.localizedDescription)
            }
            
        }
        
        print("creating export session for \(asset)")
        
        //FIXME: this is failing. the url looks ok, the asset is ok, the recording settings look ok, so wtf?
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileTypeAppleM4A
            exporter.outputURL = trimmedSoundFileURL
            
            let duration = CMTimeGetSeconds(asset.duration)
            if (duration < 5.0) {
                print("sound is not long enough")
                return
            }
            // e.g. the first 5 seconds
            let startTime = CMTimeMake(0, 1)
            let stopTime = CMTimeMake(5, 1)
            exporter.timeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
            
            //            // set up the audio mix
            //            let tracks = asset.tracksWithMediaType(AVMediaTypeAudio)
            //            if tracks.count == 0 {
            //                return
            //            }
            //            let track = tracks[0]
            //            let exportAudioMix = AVMutableAudioMix()
            //            let exportAudioMixInputParameters =
            //            AVMutableAudioMixInputParameters(track: track)
            //            exportAudioMixInputParameters.setVolume(1.0, atTime: CMTimeMake(0, 1))
            //            exportAudioMix.inputParameters = [exportAudioMixInputParameters]
            //            // exporter.audioMix = exportAudioMix
            
            // do it
            exporter.exportAsynchronously(completionHandler: {
                print("export complete \(exporter.status)")
                
                switch exporter.status {
                case  AVAssetExportSessionStatus.failed:
                    
                    if let e = exporter.error as? NSError {
                        print("export failed \(e)")
                        switch e.code {
                        case AVError.Code.fileAlreadyExists.rawValue:
                            print("File Exists")
                            break
                        default: break
                        }
                    } else {
                        print("export failed")
                    }
                case AVAssetExportSessionStatus.cancelled:
                    print("export cancelled \(exporter.error)")
                default:
                    print("export complete")
                }
            })
        } else {
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
        
    }
    
    @IBAction
    func speed() {
        let asset = AVAsset(url:self.soundFileURL!)
        exportSpeedAsset(asset, fileName: "trimmed.m4a")
    }
    
    func exportSpeedAsset(_ asset:AVAsset, fileName:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
        
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
            print("sound exists")
        }
        
        print("creating export session for \(asset)")
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileTypeAppleM4A
            exporter.outputURL = trimmedSoundFileURL
            
            
            //             AVAudioTimePitchAlgorithmVarispeed
            //             AVAudioTimePitchAlgorithmSpectral
            //             AVAudioTimePitchAlgorithmTimeDomain
            exporter.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmVarispeed
            
            
            
            
            let duration = CMTimeGetSeconds(asset.duration)
            if (duration < 5.0) {
                print("sound is not long enough")
                return
            }
            // e.g. the first 5 seconds
            //            let startTime = CMTimeMake(0, 1)
            //            let stopTime = CMTimeMake(5, 1)
            //            let exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
            //            exporter.timeRange = exportTimeRange
            
            // do it
            exporter.exportAsynchronously(completionHandler: {
                switch exporter.status {
                case  AVAssetExportSessionStatus.failed:
                    print("export failed \(exporter.error)")
                case AVAssetExportSessionStatus.cancelled:
                    print("export cancelled \(exporter.error)")
                default:
                    print("export complete")
                }
            })
        }
    }
    
    
}

// MARK: AVAudioRecorderDelegate
extension RecorderViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("finished recording \(flag)")
        stopButton.isUserInteractionEnabled = false
        playButton.isUserInteractionEnabled = false
        recordBtn.isUserInteractionEnabled = true
        setButtonBackground()
        resetTimer()
        recordingDone(recordedUrl: self.recorder.url, thumb: nil)
       
        
        self.recorder = nil
       
    }
    
    //MARK: recodrding done
    func recordingDone(recordedUrl : URL?, thumb: UIImage?){
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        if let recordedDataUrl = recordedUrl {
            do {
                let mediaData = try Data(contentsOf: recordedDataUrl as URL)
                mediaUploadApi(data: mediaData, type: .audio, thumb: Image(asset: .icRecordingPlay))
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    //MARK: - Handle response
    func handle(response : Response) {
        
        HandleResponse.shared.handle(response: response, self, from: .cameraScreen, param: nil)
        
    }
    
    //MARK: - media api
    func mediaUploadApi(data: Data?, type: MediaType?, thumb: UIImage?) {
        
        Loader.shared.start()
     
        APIManager.shared.request(withMedia: LoginEndpoint.shareMedia(accessToken: login?.profile?.access_token, media_type: type?.rawValue), media: data, thumbnail: thumb, completion: { [weak self] (response) in
            
            Loader.shared.stop()
            
            self?.handle(response: response)
            
        })
        
    }
    
    
    
    func resetTimer(){
        
         meterTimer?.invalidate()
          statusLabel?.text = "00:00"
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}

// MARK: AVAudioPlayerDelegate
extension RecorderViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
//        recordBtn.isEnabled = true
//        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}

