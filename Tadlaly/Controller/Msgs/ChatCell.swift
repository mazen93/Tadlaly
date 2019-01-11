//
//  ChatCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.msgContent.layer.cornerRadius = 10.0
        self.msgContent.clipsToBounds = true
    }

    
}
