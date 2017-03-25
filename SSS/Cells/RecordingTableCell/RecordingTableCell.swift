//
//  RecordingTableCell.swift
//  SSS
//
//  Created by Sierra 4 on 25/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Kingfisher

class RecordingTableCell: UITableViewCell {
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblRecordingTitle: UILabel!
    
    var cellData:[String: String]? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard cellData != nil else {
            return
        }
        print("cell updating ..")
        
        imgThumbnail.image = UIImage(named: /cellData?["image"])
        lblRecordingTitle.text = /cellData?["title"]
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
