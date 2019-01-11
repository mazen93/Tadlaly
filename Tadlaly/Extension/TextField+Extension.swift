//
//  TextField+Extension.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/22/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation


extension String {
    
    var trimmed : String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
