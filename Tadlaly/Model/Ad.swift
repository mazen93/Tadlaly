//
//  Ad.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON

//[
//  {
//   "id_advertisement": "30",
//   "google_lat": "24.5869027",
//   "google_long": "46.6314688",
//   "advertisement_user": "11",
//   "is_sold": "0",
//   "advertisement_code": "110",
//   "main_department_fk": "1",
//   "sub_department_fk": "4",
//   "advertisement_title": "hhcc",
//   "advertisement_content": "رز زتر\nَو\nJbbhh ",
//   "advertisement_price": "500",
//   "advertisement_type": "1",
//   "advertisement_date": "03/08/2018",
//   "city": "رتنت",
//   "phone": "+969053240758",
//   "show_phone": "1",
//   "view_count": "4",
//   "share_count": "0",
//   "publisher": "2",
//   "approved": "1",
//   "advertisement_owner": "mostafa kamel",
//   "advertisement_image": [
//                       {
//                       "photo_name": "5b645dd0877b6.jpg"
//                          "id_photo": "196"
//                         },
//                         {
//                      "photo_name": "5b645dd0889b7.jpg"
//                           "id_photo": "166"
//                                },
//                              {
//                      "photo_name": "5b645dd089575.jpg"
//                              "id_photo": "166"
//                              }
//                          ],
//   "distance": 1677.799999999999954525264911353588104248046875
//       "total_items": 10,
//         "current_page": 1
//              "main_image": "5c221a2a1a370.jpg",

//    },


class Ad: NSObject {
  
    var phots:[String]=[]
   // var image = [imgs]
    var mainImg: String = ""
    var date: String = ""
    var adeTitle: String = ""
    var adePrice: String = ""
    var city: String = ""
   // var kind: String = ""
    var phone: String = ""
    var content: String = ""
    var distance: String = ""
    var viewShare: String = ""
    var adId: String = ""
    var userId: String = ""
    var userName: String = ""
    var adverId = ""
    var showPhone = ""
    var typ = ""
    
    init?(dic:[String:JSON]) {
        
    guard let imge = dic["main_image"]?.imagePath, !imge.isEmpty else { return nil}
                    self.mainImg = imge
        if dic["advertisement_title"]?.string != nil {
            self.adeTitle = (dic["advertisement_title"]?.string)!
        }
        self.content = (dic["advertisement_content"]?.string)!
        self.adePrice = (dic["advertisement_price"]?.string)!
        self.city = (dic["city"]?.string)!
        if let s = dic["distance"]?.double  {
            self.distance = "\(s)"
        }
        self.date = (dic["advertisement_date"]?.string)!
        self.phone = (dic["phone"]?.string)!
        self.viewShare = (dic["share_count"]?.string)!
        self.adId = (dic["advertisement_code"]?.string)!
        self.userId = (dic["advertisement_user"]?.string)!
        self.userName = (dic["advertisement_owner"]?.string)!
        self.adverId = (dic["id_advertisement"]?.string)!
        self.showPhone = (dic["show_phone"]?.string)!
        self.typ = (dic["advertisement_type"]?.string)!
        
        
        
        
        
        let photos=dic["advertisement_image"]?.array
        let url=URLs.image
        for photo in photos! {
            
            let image=photo["photo_name"].string
            phots.append( url+image!)
            
        }

        
        
        
        
        
        
//            if dic["advertisement_type"]?.string != nil {
//              self.kind = (dic["​advertisement_type​"]?.string)!
//        }
//
        //self.kind = (dic["​advertisement_type​"]?.object as? String)!
        
        
        
        
        
        
        
        }
    
}

class gallary{
    var photo:String?
}

//    struct imgs {
//        var pic: String
//        init?(dic: [String: Any]) {
//            guard let image = (dic["photo_name"]?.imagePath, !image.isEmpty else { return nil}
//            self.pic = image
//
//        }
//    }


















