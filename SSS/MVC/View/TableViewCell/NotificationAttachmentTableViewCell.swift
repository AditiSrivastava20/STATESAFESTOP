//
//  NotificationAttachmentTableViewCell.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationAttachmentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var imageViewThumb: UIImageView!
    @IBOutlet weak var imageViewType: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var objNotification:NotificationData? {
        
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
//        labelTitle.text = 
//        labelSubTitle.text =
        imageViewUser.kf.setImage(with: URL(string: /objNotification?.sender_image), placeholder: Image(asset: .icProfile), options: nil, progressBlock: nil, completionHandler: nil)
        
        let mediaType = MediaType(rawValue: /objNotification?.media_type ) ?? .none
        
        switch mediaType {
        case .audio:
            imageViewType.image = Image(asset: .icRecordingPlay)
            imageViewThumb.image = UIImage.blankImage()
            imageViewThumb.backgroundColor = colors.loaderColor.color()
        
        case .video:
            imageViewType.image = Image(asset: .icVideoPlay)
            imageViewThumb.kf.setImage(with: URL(string: /objNotification?.thumbnail_url), placeholder: Image.blankImage(), options: nil, progressBlock: nil, completionHandler: nil)
            
        default:
            print("none")
        }
        
        
    }
    
    

}
