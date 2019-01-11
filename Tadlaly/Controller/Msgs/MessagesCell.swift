//
//  MessagesCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher


class MessagesCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var msg: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
    }

    var pics: Message? {
        didSet {
            guard let imgs = pics else { return }
            
            self.img.kf.indicatorType = .activity
            if let url = URL(string: (imgs.fromImg) ) {
//                self.img.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
                self.img.kf.setImage(with: url,options:[.transition(ImageTransition.fade(0.5))])
            }
        }
    }
}
