//
//  AdCollectionCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class AdCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.subLabel.layer.cornerRadius = 10.0
        self.subLabel.clipsToBounds = true
        
    }

    override var isSelected: Bool {
        didSet {
            if  isSelected {
                self.subLabel.backgroundColor = UIColor.darkGray
                self.subLabel.textColor = UIColor.white
            } else {
                let bg = UIColor(red: 173.0/255.0, green: 0.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                self.subLabel.backgroundColor = bg
                self.subLabel.textColor = UIColor.white
            }
        }
    }
    
}
