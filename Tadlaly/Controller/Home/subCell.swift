//
//  SubCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 11/13/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class SubCell: UICollectionViewCell {
    
    @IBOutlet weak var subNm: UILabel!
    
    override func awakeFromNib() {
        self.subNm.layer.cornerRadius = 10.0
        self.subNm.clipsToBounds = true
    }
    
    
    
}
