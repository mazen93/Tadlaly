//
//  searchCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher


class searchCell: UITableViewCell {

    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var kindCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var distanceCell: UILabel!
    @IBOutlet weak var cityCell: UILabel!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var float: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.imgCell.layer.cornerRadius = 10.0
        self.imgCell.clipsToBounds = true
        self.float.layer.cornerRadius = 10.0
        self.float.clipsToBounds = true
        self.float.layer.shadowOpacity = 0.3
        self.float.layer.shadowRadius = 2
        self.kindCell.layer.cornerRadius = 10.0
        self.kindCell.clipsToBounds = true
    }

    
    var pics: Ad? {
        didSet {
            guard let imgs = pics else { return }
            
            self.imgCell.kf.indicatorType = .activity
            if let url = URL(string: (imgs.mainImg) ) {
                self.imgCell.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])
//                self.imgCell.kf.setImage(with: url, placeholder: nil, options:[.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    

}
