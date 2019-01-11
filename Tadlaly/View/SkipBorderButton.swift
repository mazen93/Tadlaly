//
//  SkipBorderButton.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/20/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class SkipBorderButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 10.0
        
       }
    
}
