//
//  BankAccounts.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/29/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON


class BankAccounts: NSObject {
    
    
    var account_bank_name :String = ""
    
    init?(dic:[String:JSON]) {
        
        self.account_bank_name = dic["account_bank_name"]?.object as! String
        
        
          }
    
    
    
}



