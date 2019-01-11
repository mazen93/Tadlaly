//
//  AdCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

class AdCell: UITableViewCell {

    
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var distanceLab: UILabel!
    @IBOutlet weak var cityLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var card: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImg.layer.cornerRadius = 10.0
        self.cellImg.clipsToBounds = true
        self.card.layer.cornerRadius = 10.0
        //self.card.clipsToBounds = true
        self.card.layer.shadowOpacity = 0.3
        self.card.layer.shadowRadius = 2
        self.kindLabel.layer.cornerRadius = 10.0
        self.kindLabel.clipsToBounds = true
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var pics: Ad? {
        didSet {
            guard let imgs = pics else { return }
            self.cellImg.kf.indicatorType = .activity
            if let url = URL(string: (imgs.mainImg) ) {
               self.cellImg.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])

            }
        }
    }
    


}
