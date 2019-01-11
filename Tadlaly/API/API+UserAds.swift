//
//  API+UserAds.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import SVProgressHUD

extension API {
    
    class func addAde (advertisementTitle: String, mainDepartment: String, subDepartment: String, advertisementPrice: String, advertisementContent: String, advertisementType: String, city: String, phone: String, showPhone: String, googleLong: String, googleLat: String, image: Array<UIImage>, completion: @escaping (_ error: Error?, _ success: Bool)->Void ) {
        
        
        let url = URLs.addAde
        
        
        let  urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
        let parameters = [
            "advertisement_title": advertisementTitle,
            "main_department": mainDepartment,
            "sub_department": subDepartment,
            "advertisement_content": advertisementContent,
            "advertisement_price": advertisementPrice,
            "advertisement_type": advertisementType,
            "google_lat": googleLat,
            "google_long": googleLong,
            "city": city,
            "phone": phone,
            "show_phone": showPhone
         //   "images[]": image
            
            
            
            
            
            ] as [String : Any]
        // Including a base 64 encoded image is triggering a crash in xcode 6.4
      
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
//                if let imageData = UIImage(named: "emp")!.pngData() {
//                    multipartFormData.append(imageData, withName: "images[]")
//                }
                
                
                // import image to request
                for imageData in image{
                    multipartFormData.append(imageData.pngData()!, withName: "images[]")
                }
                
                
                
                for (key, value) in parameters {
                    multipartFormData.append(key.data(using: .utf8)!, withName: value as! String)
                }
        },
            to:  urlwithPercentEscapes!,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        
                        print("sucess")
                        
                        }
                
                
                case .failure(let encodingError):
                    
                   print(encodingError.localizedDescription)
                }
                
        })
        
        
//
//        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: parameters).responseJSON { (response) in
//
//            switch response.result {
//            case .failure(let error):
//                completion(error, false)
//                print(error)
//            case .success(let value):
//                var json = JSON(value)
//                 print("uploaded,\(json)")
//                if (json["success"].int == 1 ) {
//                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: " your ad has been submitted successfully")
//                    SVProgressHUD.setShouldTintImages(false)
//                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
//                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
//                    SVProgressHUD.dismiss(withDelay: 2.0)
//                }
//                completion(nil, true)
//            }
//        }
    }
    
    
    
    // update my ad needs  in link > { ​id_advertisement​ }
    class func updateMyAd(adId:String, main: String, sub: String, title: String, content: String, price: String, type: String, lat: String, lon: String, city: String, phone:String,showPH: String, imgs: Array<String>, completion: @escaping(_ error: Error?, _ data:[MyAds]?)-> Void) {
        
        let url = URLs.updateMyAd+adId
        let parameters = [
            "main_department": main,
            "sub_department": sub,
            "advertisement_title": title,
            "advertisement_content": content,
            "advertisement_price": price,
            "advertisement_type": type,
            "google_lat": lat,
            "google_long": lon,
            "city": city,
            "phone": phone,
            "show_phone": showPH,
            "images[]": imgs
            
            ] as [String: Any]
        
        Alamofire.request(url, method: .post
            , parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case.failure(let error):
                    completion(error,nil)
                    print(error)
                case.success(let value):
                    let json = JSON(value)
                    print("my ad,\(json)")
                    guard let dataArr = json.array else{
                        completion(nil , nil)
                        return
                    }
                    var ads = [MyAds]()
                    for data in dataArr {
                        if let data = data.dictionary ,let result = MyAds.init(dic: data) {
                            ads.append(result)
                        }
                       }
                    completion(nil,ads )
                }
             }
           }
    
    
    // my current ad     needs in link > {user_id}

    class func myCurAds(completion: @escaping(_ error: Error?,_ data:[MyAds]?)->Void ){
        let url = URLs.myRecAds+"\(helper.getApiToken())"
        //let url = "http://tadlaly.tansiq.net/Api/CurrentAdvertisement/1"
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [MyAds]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = MyAds.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
            
        }
    }
    
    
    // my old ad       needs in link > {user_id}
    class func myOldAds(completion: @escaping(_ error: Error?,_ data:[MyAds]?)->Void ){
        let url = URLs.myLastAds+"\(helper.getApiToken())"
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [MyAds]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = MyAds.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
          }
    }
    
    class func deletAd(reason: String, idsAdvertisement : Array<Any> , completion: @escaping(_ error: Error?, _ success: Bool)-> Void) {
        
        
        let url = URLs.deletMyAd
        let parameters = [
            "reason": reason,
            "ids_advertisement[]": idsAdvertisement
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,false)
                print(error)
            case.success(let value):
                completion(nil,true)
                print(value)
                let json = JSON(value)
                if (json["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: " Ad deleted ")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                
            }
        }
    }
    
    
    class func deletPic(picId: String, completion: @escaping(_ error: Error?, _ success: Bool)-> Void) {
        
        
        let url = "http://tdlly.com/Api/DeletPhoto/\(helper.getApiToken())"+picId
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,false)
                print(error)
            case.success(let value):
                completion(nil,true)
                print(value)
                let json = JSON(value)
                if (json["success_delete"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: " pic deleted ")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                
            }
        }
    }
    
    
    
    
    
    
}
