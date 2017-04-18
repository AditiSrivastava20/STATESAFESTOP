//
//  TutorialCollectionViewCell.swift
//  
//
//  Created by Sierra 4 on 15/04/17.
//
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewTut: UIImageView!
    @IBOutlet weak var labelTut: UILabel!
    
    override func awakeFromNib() {
        if UIScreen.main.bounds.width > 320 {
            labelTut?.font = UIFont.HelveticaNeue(type:.Bold  , size: 15)
            
        }else {
            
             labelTut?.font = UIFont.HelveticaNeue(type:.Bold  , size: 13)
        }
        
    }
}
