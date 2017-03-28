//
//  SafelistCell.swift
//  SSS
//
//  Created by Sierra 4 on 27/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import M13Checkbox

class SafelistCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var checkBoxContact: M13Checkbox!
    @IBOutlet weak var imageViewStaticPhone: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var objSafeuser: Safelist? {
        didSet{
            setupCell()
        }
    }
    
    func setupCell() {
        lblName?.text = /objSafeuser?.fullname
        lblPhone?.text = /objSafeuser?.phone
        
        if objSafeuser?.isSelected == 1 {
            checkBoxContact.checkState = .checked
        } else {
            checkBoxContact.checkState = .unchecked
        }
      
    }

}


