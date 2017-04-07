//
//  RecordingTableViewCell.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Kingfisher

class RecordingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var btnActionSheet: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewType: UIImageView!
    @IBOutlet weak var imageViewUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var objRecording:Recording? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        labelName.text = /objRecording?.media_content
        
        let mediaType = MediaType(rawValue: /objRecording?.media_type ) ?? .none
        
        switch mediaType {
        case .audio:
            imageViewType.image = Image(asset: .icAudioWhite )
            imageViewUser.image = Image.blankImage()
            imageViewUser.backgroundColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
            
        case .video:
            imageViewUser.kf.setImage(with: URL(string: /objRecording?.thumbnail_url ))
            
        case .none:
            imageViewUser.backgroundColor = UIColor(red:0.99, green:0.86, blue:0.18, alpha:1.0)
        }
        
    }
    

}
