//
//  NotificationAttachmentTableViewCell.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

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

}
