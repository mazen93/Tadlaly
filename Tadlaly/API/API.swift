
//  API.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class API: NSObject {
    
    
    
    class func logIn(email: String , password: String, completion: @escaping (_ error: Error? , _ success: Bool)-> Void) {
        let url = URLs.login
        let parameters = [
            "user_name": email ,
            "user_pass": password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                      print(error)
                      completion(error, false)
            case .success(let value):
                      print(value)
                let data = JSON(value)
                      if (data["success"].int == 1) {
                        let user_id = Int(data["user_id"].string!)!
                        let user_name = data["user_name"].string
                        let user_phone = data["user_phone"].string
                        let user_email = data["user_email"].string
                        let user_photo = data["user_photo"].string
                        let user_city = data["user_city"].string
                        let user_pass = data["user_pass"].string
                        let message = data["message"].string
                        
                        helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!, user_photo: user_photo!, user_city: user_city!, ​user_pass: user_pass!)
                        //helper.saveMsg(message: message!)
                        SVProgressHUD.show(UIImage(named: "vic.png")!, status: message!)
                        SVProgressHUD.setShouldTintImages(false)
                        SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                        SVProgressHUD.dismiss(withDelay: 2.0)
                        print("myData",data)
                        completion(nil,true)
                      } else if (data["success"].int == 0) {
                        let msg = data["message"].string
                        //helper.saveMsg(message: msg!)
                        SVProgressHUD.show(UIImage(named: "er.png")!, status: msg!)
                        SVProgressHUD.setShouldTintImages(false)
                        SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                        SVProgressHUD.dismiss(withDelay: 2.0)
                }
            }
        }
    }
    
    //Register
    class func register (firstName: String,lastName: String, phoneNum: String, email: String,fullName: String, password: String, location: String, latitude: String, longtuide: String,userTokenId: String, image: String ,completion: @escaping (_ error: Error?, _ success: Bool)->Void ) {
        
        let url = URLs.register
        let paramaters = [
            "user_name": firstName,
            "user_pass": password,
            "user_phone": phoneNum,
            "user_email": email,
            "user_google_lat": latitude,
            "user_google_long": longtuide,
            "user_city": location,
            "user_full_name": fullName,
            "user_token_id": userTokenId,
            "user_photo": image
        ]
        Alamofire.request(url, method: .post, parameters: paramaters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, false)
                print(error)
                
            case .success(let value):
                let data = JSON(value)
                print(data)
                if (data["success"].int == 1) {
                    let user_id = Int(data["user_id"].string!)!
                    let user_name = data["user_name"].string
                    let user_phone = data["user_phone"].string
                    let user_email = data["user_email"].string
                    let user_photo = data["user_photo"].string
                    let user_city = data["user_city"].string
                    let user_pass = data["user_pass"].string
                    let msg = data["message"].string
                    print("user it is \(user_id)")
                    helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!, user_photo: user_photo!, user_city: user_city!, ​user_pass: user_pass!)
                    //helper.saveMsg(message: msg!)
                    SVProgressHUD.show(UIImage(named: "jump.png")!, status: msg!)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("welcome",data)
                    completion(nil,true)
                } else if (data["success"].int == 2) {
                    let message = data["message"].string
//                    SVProgressHUD.show(UIImage(named: "er.png")!, status: message!)
//                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
//                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
//                    SVProgressHUD.setShouldTintImages(false)
//                    SVProgressHUD.dismiss(withDelay: 2.0)
                    //helper.saveMsg(message: message!)
                }
        }
      }
    }
    //Rest Password
    class func resetPass (user_Name: String, user_email: String, completion: @escaping(_ error: Error?,_ succes: Bool)-> Void) {
        
        let url = URLs.resetPass
        let parameters = [
            "user_name": user_Name,
            "user_email": user_email
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case.failure(let error):
                completion(error, false)
                print(error)
                
            case.success(let value):
                completion(nil, true)
                print(value)
            }
        }
    }
    
    
    // ​{user_id return from login }
    class func updateProfile (userName: String, userPhone: String, email: String, image: String,fullName: String ,lon: String , lat: String , city: String,completion: @escaping(_ error: Error?,_ success: Bool)-> Void )  {
        
        let url = URLs.updateProfile+"\(helper.getApiToken())"
        let parameters = [
            "user_name": userName,
            "user_phone": userPhone,
            "user_email": email,
            "user_photo": image,
            "user_full_name": fullName,
            "user_google_lat": lat,
            "user_google_long" : lon,
            "user_city": city
        ]
        
        Alamofire.request(url, method: .post , parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON {  (response) in
            
            switch response.result {
            case.failure(let error):
                completion(error, false)
                print("error to update prfoile",error)
            case.success(let value):
                let data = JSON(value)
                print(data)
                if (data["success"].int == 1) {
                    let user_id = Int(data["user_id"].string!)!
                    let user_name = data["user_name"].string
                    let user_phone = data["user_phone"].string
                    let user_email = data["user_email"].string
                    let user_photo = data["user_photo"].string
                    let user_city = data["user_city"].string
                    let user_pass = data["user_pass"].string
                    
                    //print("user name is \(String(describing: user_name))")
                    print("user id is \(user_id)")
                
                    helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!, user_photo: user_photo!, user_city: user_city!, ​user_pass: user_pass!)
                    print("my new data",data)
                    completion(nil,true)
                }
            }
        }
    }
    
    /// updatePassword {"user_old_pass" "user_new_pass"} & user id at url
    class func updatePass (user_old_pass: String, user_new_pass: String, completion: @escaping(_ error: Error?,_ success:Bool?)-> Void )  {
        
        let url = URLs.updatePass+"\(helper.getApiToken())"
        let parameters = [
            "user_old_pass": user_old_pass,
            "user_new_pass": user_new_pass
        ]
        
        Alamofire.request(url, method: .post , parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON {  (response) in
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
                print(error)
            case .success(let value):
                let data = JSON(value)
                print(data)
                if (data["success"].int == 1) {
                    let user_id = Int(data["user_id"].string!)!
                    let user_name = data["user_name"].string
                    let user_phone = data["user_phone"].string
                    let user_email = data["user_email"].string
                    let user_photo = data["user_photo"].string
                    let user_city = data["user_city"].string
                    let user_pass = data["user_pass"].string
                    let msg = data["message"].string
                    
                    helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!, user_photo: user_photo!, user_city: user_city!, ​user_pass: user_pass!)
                    //helper.saveMsg(message: msg!)
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: msg!)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("Password UPDATED",data)
                    completion(nil,true)
                } else if (data["success"].int == 0) {
                    let message = data["message"].string
                    //helper.saveMsg(message: message!)
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: message!)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
            }
        }
    }
    
 
     class func userTokenId(id: String, completion: @escaping (_ error: Error?,_ success: Bool)->Void) {

        
        //let url = URLs.userTokenId+"\(helper.getApiToken())"
        let url = "http://tdlly.com/Api/UpdateTokenId/\(helper.getApiToken())"
        let parameters = [
           "user_token_id": id
        ]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in

                switch response.result {
                case .failure(let error):
                    completion(error, false)
                    print("faild upload user token",error)
                case .success(let success):
                           print(success)
                        completion(nil, true)

           }
        }
    }
    
    
    class func logOut(completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
       // let url = URLs.logOut+"\(helper.getApiToken())"
        let url = "http://tdlly.com/Api/Logout/\(helper.getApiToken())"
        Alamofire.request(url, method: .post, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result
                {
                case .failure( let error):
                    print(error)
                    completion(error , false)
                case .success(let value):
                    let data = JSON(value)
                    print(data)
                    if  (data["success"].int == 1) {
                        helper.deletUserDefaults()
                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////////
    
    //-----Contact US
    class func ContactUS(name:String ,email: String, subject: String , message: String, phone: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void ) {
        
        let url = URLs.contactUs
        let paramaters = [
            "name": name,
            "email": email,
            "subject": subject ,
            "message": message,
            "phone": phone
        ]
        
        Alamofire.request(url, method: .post, parameters: paramaters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, false)
                print(error)
            case .success(let value):
                completion(nil, true)
                
                print(value)
            }
        }
    }
    
    
    //---> Bank ACC
    class func BankAccountsApi(completion:@escaping (_ error:Error?, _ data:[BankAccounts]?)->Void){
        Alamofire.request(URLs.bank).responseJSON{response in
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
                var Accounts = [BankAccounts]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = BankAccounts.init(dic: data) {
                        Accounts.append(result)
                    }
                }
                completion(nil,Accounts)
            }
        }
    }
    
    
    // commision
    class func transferPayment (userName: String, amount: String,bank: String, date: String,person: String, code: String,image: String, completion: @escaping(_ error: Error?,_ succes: Bool)-> Void )  {
        
             let url = URLs.payment
           let parameters = [
               "user_name": userName,
               "amount": amount,
               "bank": bank,
               "date": date,
               "transform_person": person,
               "advertisement_code": code,
               "transform_image": image
                     ]
        Alamofire.request(url, method: .post , parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON {  (response) in
            LogInVC.shared.hudStart()
            switch response.result {
            case.failure(let error):
                SVProgressHUD.dismiss(withDelay: 2.0)
                completion(error, false)
                print(error)
            case.success(let value):
                let json = JSON(value)
                print(json)
                if  (json["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: "sent successfully")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 3.0)
                } else if (json["success"].int == 2) {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "your data is not completed")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 3.0)
                } else if (json["success"].int == 0) {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "your data is not right")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 3.0)
                }
            }
        }
    }
    
    
    
    
//    class func share() {
//        //let url = URLs.appShare
//        let url = "http://tdlly.com/Api/AppShare/\(helper.getApiToken())/ios"
//        Alamofire.request(url , method: .post , parameters: nil, encoding: URLEncoding.default , headers: nil).responseJSON(completionHandler: { (response) in
//            switch response.result  {
//            case.success(let success):
//                print("success share app",success)
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }

    class func share(completion: @escaping(_ error: Error? , _ success: Bool?)-> Void) {
        
        let url = "http://tdlly.com/Api/AppShare/\(helper.getApiToken())/ios"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                print(value)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}







