//
//  ComplaintTableViewCell.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Kingfisher

class ComplaintTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewBox: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var objComplaint:Complaint? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        if let login = UserDefaults.standard.value(forKey: "login") as? [String: String] {
            imageViewUser.kf.setImage(with: URL(string: /login["image_url"]))
        }
        
        labelTitle.text = /objComplaint?.title
        labelSubTitle.text = /objComplaint?.complaintDescription
        labelTime.text = /objComplaint?.created_at
        
    }
    

}