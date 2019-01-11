//
//  JSON+Extension.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    var imagePath: String? {
        
        guard let string = self.string, !string.isEmpty else {return nil}
        
        return URLs.image + string
    }
}





