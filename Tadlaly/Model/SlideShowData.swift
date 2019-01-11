//
//  SlideShowData.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON


class SlidShowData: NSObject {
    
   // var img: String
    var imageTitle: String!
    var imageContent: String!
    
    
    init?(dict: [String: JSON]) {
        
       // guard let image = dict["image"]?.imagePath, !image.isEmpty else { return nil }
        
        //self.img = image
        self.imageTitle = (dict["image_title"]?.string)!
        self.imageContent = dict["image_content"]?.string
        
        
        
    }
    
    
    
    
    
    
    
}
