//
//  CategoriesDep.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON

//struct subData {
//    var dep: String
//    init(dic: [String: Any]) {
//        if let ds = JSON(dictionaryLiteral: dic[""] as! (String, Any) ) {
//
//        }
//        //self.dep = ((dic["sub_department_name"] as AnyObject).string)!
//    }
//
//}
class CategoriesDep: NSObject {

    var depName: String
    var depImage: String
    var depId: String
    var subCategory = [subData]()

    init?(dict: [String: JSON]) {

        guard let image = dict["main_department_image"]?.imagePath, !image.isEmpty else { return nil }

        self.depImage = image
        self.depName = (dict["main_department_name"]?.string)!
         self.depId = (dict["main_department_id"]?.string)!
        
        
        
        if let dataArr = dict["sub_depart"]?.array
        {
            
            for dataArr in dataArr {
                
                
                let id = dataArr ["sub_department_id"].string
                
                let name = dataArr ["sub_department_name"].string
                let icon = dataArr ["sub_department_image"].string
                print("it is \(String(describing: id))")
                
                // create Ream Object
                subCategory.append(subData(subName: name!, subImage: icon!, subId: id!))

               
            }
            
           
            
        }
        
        
        
        
        
        
        
        
    
    }





}
class subData:NSObject{
    
    var subName: String!
    var subImage: String!
    var subId: String!
     init(subName:String,subImage:String,subId:String) {
        self.subId=subId
        self.subName=subName
        self.subImage=subImage
    }
  
    
  
}
