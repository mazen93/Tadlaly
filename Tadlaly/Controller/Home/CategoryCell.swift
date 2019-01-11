//
//  CategoryCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher


class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categroyImg: UIImageView!
    //@IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cateName: UILabel!
   
    
    
    
    
    
    var title:CategoriesDep?{
        didSet {
            guard let titl=title  else {
                return
            }
            
            
            self.cateName.text=titl.depName
        }
        
        
        
        
        
       
    }
    var pics: CategoriesDep? {
        didSet {
            guard let imgs = pics else { return }

            self.categroyImg.kf.indicatorType = .activity
            if let url = URL(string: (imgs.depImage)) {
                self.categroyImg.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])
            
            }
        }
    }

    
    
}
