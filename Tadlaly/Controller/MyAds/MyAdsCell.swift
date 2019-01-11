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
    func soldTapped(_ sender: MyAdsCell)
    func dontSellTapped(_ sender: MyAdsCell)
    func doneTapped(_ sender: MyAdsCell)
    func cancelTapped(_ sender: MyAdsCell)
    
}

class MyAdsCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var floatView: UIView!
    
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var delet: UIButton!
    
    @IBOutlet weak var visual: UIVisualEffectView!
    @IBOutlet weak var soldCheck: UIButton!
    @IBOutlet weak var dontSellCheck: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        
        self.kind.layer.cornerRadius = 10.0
        self.floatView.layer.cornerRadius = 10.0
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        self.kind.clipsToBounds = true
        self.floatView.layer.shadowOpacity = 0.3
        self.floatView.layer.shadowRadius = 2
        self.visual.layer.cornerRadius = 10.0
        self.visual.clipsToBounds = true
        self.visual.alpha = 0
        self.soldCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.soldCheck.setImage(UIImage(named:"che2"), for: .selected)
        self.dontSellCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.dontSellCheck.setImage(UIImage(named:"che2"), for: .selected)
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
    @IBAction func soldChBtn(_ sender: UIButton) {
        delegate?.soldTapped(self)
    }
    
    @IBAction func dontSellChBtn(_ sender: UIButton) {
        delegate?.dontSellTapped(self)
    }
    @IBAction func donBtn(_ sender: UIButton) {
        delegate?.doneTapped(self)
    }
    @IBAction func canBtn(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    
    
    
    
    
    
    
}
