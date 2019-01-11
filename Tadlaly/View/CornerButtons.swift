//
//  CornerButtons.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/20/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class CornerButtons: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
          layer.cornerRadius = self.frame.height/2
          layer.shadowColor = UIColor.darkGray.cgColor
          layer.shadowRadius = 4
          layer.shadowOpacity = 0.8
          layer.shadowOffset = CGSize(width: 0, height: 0)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        super.touchesBegan(touches, with: event)
    }
    
    
}
