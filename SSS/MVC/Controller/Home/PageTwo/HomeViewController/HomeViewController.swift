//
//  HomeViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import PermissionScope
import AVFoundation
import Foundation

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnAudio: UIButton!
    
    var pscope: PermissionScope? {
        didSet {
            pscope?.addPermission(CameraPermission(), message: "We use this to capture Videos")
        }
    }
    
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetMedium
        return s
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        pscope?.show(
            { finished, results in
                print("got results \(results)")
        },
            cancelled: { results in
                print("thing was cancelled")
        }
        )
        
        switch PermissionScope().statusCamera() {
        case .authorized:
//            setupCameraSession()
//            self.cameraPreview.layer.addSublayer(previewLayer)
//            cameraSession.startRunning()
            print("thanks")
        
        case .unknown, .unauthorized, .disabled:
            PermissionScope().requestCamera()
            print("request")

        }
    }
    
    
    @IBAction func btnLocationAction(_ sender: Any) {
    }
    
    
    @IBAction func btnVideoAction(_ sender: Any) {
        btnVideo.setImage( UIImage(asset: .vedioYelow) , for: UIControlState.normal)
        btnAudio.setImage( UIImage(asset: .audioBlack) , for: UIControlState.normal)
    }
    
    @IBAction func btnAudioAction(_ sender: Any) {
        btnAudio.setImage( UIImage(asset: .audioYelow) , for: UIControlState.normal)
        btnVideo.setImage( UIImage(asset: .vedioBlack) , for: UIControlState.normal)
    }
    
    @IBAction func btnComplaintListAction(_ sender: Any) {
        
    }
    
    @IBAction func btnRecordingListAction(_ sender: Any) {
        
    }
    
    @IBAction func btnCaptureAction(_ sender: Any) {
        
    }
    
    
    
}


extension HomeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            cameraSession.beginConfiguration()
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            cameraSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    
    

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you collect each frame and process it
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you can count how many frames are dopped
    }

}

























