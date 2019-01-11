//
//  AddAdCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

//protocol deleteCell {
//    func remove(_ sender: AddAdCell)
//}

class AddAdCell: UICollectionViewCell {
    
    @IBOutlet weak var adImg: UIImageView!
    @IBOutlet weak var removee: UIButton!
    
    
    override func awakeFromNib() {
        self.adImg.layer.cornerRadius = 10.0
        self.adImg.clipsToBounds = true
//        self.rem.setImage(UIImage(named:"c1"), for: .normal)
//        self.rem.setImage(UIImage(named:"c2"), for: .selected)
        
        //self.rem.alpha = 0
    }
    
   // var delegate:deleteCell?
    
//    @IBAction func removeBtn(_ sender: UIButton) {
//        delegate?.remove(self)
//    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                self.rem.alpha = 0
//            } else {
//               self.rem.alpha = 1
//            }
//        }
//    }
    
    
}
