//
//  API+Messages.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

extension API {
    
    // send msg needs in link > {user_id}
    class func sendMsg(toUserId:String ,message: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void ) {
        
        // let url = URLs.sendMessage
        
        print("to user_id =\(toUserId)")
        //print("helper.getApiToken \(helper.getApiToken)")
      //  let url = "http://tdlly.com/Api/SendMessage/\(helper.getApiToken)"
        let url="http://tdlly.com/Api/SendMessage/\(helper.getApiToken())"
        print("send message url is \(url)")
        let paramaters = [
            "to_user_id": toUserId,
            "message_content": message
            ]

        Alamofire.request(url, method: .post, parameters: paramaters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, false)
                print("error\(error)")
            case .success(let value):
                let data = JSON(value)
                print(data)
                if  (data["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: "message Sent")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                } else if (data["success"].int == 0) {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "message not Sent")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                } else if (data["success"].int == 2) {
                    SVProgressHUD.show(UIImage(named: "emp.png")!, status: "message empty")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                completion(nil ,true)
            }
        }
    }
    
    // show chat with user needs in link > {user_id}​/​{ other person id}
    class func getChat(toUserId:String,completion:@escaping (_ error:Error?, _ data:[Message]?)->Void){
        
        let url = URLs.showCon+toUserId
        
        
        print("url of chat is \(url)")
//let url = "http://tdlly.com/Api/BetweenMessage/\(helper.getApiToken())/"+toUserId
       // let url = "http://tdlly.com/Api/BetweenMessage/18/1"
        Alamofire.request(url, method:.post , encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                print("between",json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var msgs = [Message]()
                for data in dataArr {
        if let data = data.dictionary ,let result = Message.init(dic: data) {
                        msgs.append(result)
                    }
                }
                completion(nil,msgs)
            }
            
        }
    }
    
     //              needs in link > {user_id}​/​{ other person id}
    class func deletBetweenMsgs(toUserId:String,completion:@escaping (_ error:Error?, _ success: Bool)->Void){
        
        
        
       let url = "http://tdlly.com/Api/DeleteBetweenMessages/\(helper.getApiToken())/\(toUserId)"
        
    
        
        
        
        print("url delete \(url)")
        Alamofire.request(url).responseJSON{response in
            
            switch response.result {
            case.failure(let error):
                completion(error, false)
                print(error)
            case .success(let value):
                let json = JSON(value)
                if (json["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "emp.png")!, status: "chat has been cleaned")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                completion(nil,true)
            }
        }
    }
    
    
    
    class func showAllMsgs(completion:@escaping (_ error:Error?, _ data:[Message]?)->Void){
        let url = URLs.showAllMsgsUrl
        print("url\(url)")
        Alamofire.request(url, method: .post ,parameters: nil,encoding: URLEncoding.default, headers: nil ).responseJSON { response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
              let json = JSON(value)
                //print("frist",json)
              
                print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var msgs = [Message]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Message.init(dic: data) {
                        msgs.append(result)
                    }
                }
                completion(nil,msgs)
            }
            
        }
    }
    //Array<Any>
    
    
    class func deletAllMsgs(idsMsgs: String ,  completion:@escaping (_ error:Error?, _ success: Bool)->Void){
        
        let url = URLs.deletAllMsgs
        let parameters = [
            "ids_message[]": idsMsgs
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                completion(error, false)
                print(error)
            case .success(let value):
                let json = JSON(value)
                if (json["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "emp.png")!, status: "chat has been cleaned")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                completion(nil, true)
            }
        }
    }
    
    
    
    
    
    
    
    
}
