//
//  Download.swift
//  SSS
//
//  Created by Sierra 4 on 06/04/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import Photos


class Download {
    
    static let shared = Download()
    
    //MARK: -  Download media
    func downloadMediaFrom(url :String?){
        
        
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
