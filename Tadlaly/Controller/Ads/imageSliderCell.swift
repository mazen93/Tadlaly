//
//  imageSliderCell.swift
//  Tadlaly
//
//  Created by mac on 1/11/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher
class imageSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    func setData(facility:String)  {
        
        
        photo.kf.setImage(with:  URL(string: facility))
        
        
        
        
        
        
    }

    
    
}
