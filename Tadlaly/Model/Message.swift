//
//  Message.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON

//{
//    "from_id" : "1",
//    "from_image" : "5b0dfb5178557.jpg",
//    "content_message" : "ahmed",
//    "to_id" : "18",
//    "from_phone" : "01009428727",
//    "time_message" : "2018\/12\/30 07:06 PM",
//    "id_message" : "33",
//    "from_name" : "adel beeh"
//}

class Message: NSObject {

    
    var messageId: String
    var fromId: String
    var toId: String
    var MsgContent: String
    var msgTime: String
    var fromName: String
    var fromNum :String
    var fromImg: String
    
    init?(dic:[String:JSON]) {
        
        guard let image = dic["from_image"]?.imagePath, !image.isEmpty else { return nil }
        self.fromImg = image
        self.messageId = (dic["id_message"]?.object as? String)!
        self.fromId = (dic["from_id"]?.object as? String)!
        self.toId = (dic["to_id"]?.object as? String)!
        self.msgTime = (dic["time_message"]?.object as? String)!
        self.fromNum = (dic["from_phone"]?.object as? String)!
        self.MsgContent = dic["content_message"]?.object as! String
        self.fromName = dic["from_name"]?.object as! String
        
    }

    
    
    
}
