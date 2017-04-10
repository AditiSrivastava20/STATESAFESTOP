//
//  NotificationTableViewCell.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var btnGoToMaps: UIButton!
    @IBOutlet weak var btnGoToMapsHeight: NSLayoutConstraint!
    
    
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
        
        labelTitle.text = /objNotification?.notification_message
        labelSubTitle.text = /objNotification?.created_at
        imageViewUser.kf.setImage(with: URL(string: /objNotification?.sender_image), placeholder: Image(asset: .icProfile), options: nil, progressBlock: nil, completionHandler: nil)
        
        
    }

    

}
