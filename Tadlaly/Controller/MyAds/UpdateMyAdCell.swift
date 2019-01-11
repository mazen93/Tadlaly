//
//  UpdateMyAdCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

protocol deCell {
    
    func removeCell(_ sender: UpdateMyAdCell)
}

class UpdateMyAdCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var remo: UIButton!
    
    override func awakeFromNib() {
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        self.remo.setImage(UIImage(named:"c1"), for: .normal)
        self.remo.setImage(UIImage(named:"c2"), for: .selected)
        
        //self.rem.alpha = 0
    }
    
    var delegate:deCell?
    
    
    @ IBAction func remCell(_ sender: UIButton) {
           delegate?.removeCell(self)
    }
}
