//
//  MyAdsCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

protocol myAdDelegate {
    
    func updateTapped(_ sender: MyAdsCell)
    func deletTapped(_ sender: MyAdsCell)
    
}

class MyAdsCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var floatView: UIView!
    
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var delet: UIButton!
    
   
    
    override func awakeFromNib() {
        
        self.kind.layer.cornerRadius = 10.0
        self.floatView.layer.cornerRadius = 10.0
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        self.kind.clipsToBounds = true
        self.floatView.layer.shadowOpacity = 0.3
        self.floatView.layer.shadowRadius = 2
       
       
    }
    
    
//    var pics: Ad? {
//        didSet {
//            guard let imgs = pics else { return }
//            
//            self.img.kf.indicatorType = .activity
//            if let url = URL(string: (imgs.image) ) {
//                self.img.kf.setImage(with: url, placeholder: nil, options:[.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
//            }
//        }
//    }
    
    
    
    var delegate: myAdDelegate?
    
    @IBAction func updateBtn(_ sender: UIButton) {
    delegate?.updateTapped(self)
    }
    @IBAction func deletBtn(_ sender: UIButton) {
        delegate?.deletTapped(self)
    }
   
    
    
    
    
    
    
    
    
}
