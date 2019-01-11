//
//  helper.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    
    class func restartApp() {
        
    guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if getUserData() == false {
            vc = sb.instantiateInitialViewController()!
        } else {
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
    
    class func saveApiToken(token: String) {
        let def = UserDefaults.standard
        
        def.setValue(token, forKey: "user_id")
        def.synchronize()
        
        restartApp()
        
    }
    
    class func saveSubDepart(subName: String) {
        let def = UserDefaults.standard
        def.setValue(subName, forKey: "sub_name")
        def.synchronize()
    }
    
    class func setUserData(user_id : Int,user_email:String,user_name:String,user_phone:String,user_photo:String,user_city:String,​user_pass: String){
        
        
        
        print("user id from setUserData \(user_id)")
        let def = UserDefaults.standard
        def.setValue(user_id, forKey: "user_id")
        def.setValue(user_city, forKey: "user_city")
        def.setValue(user_email, forKey: "user_email")
        def.setValue(user_name, forKey: "user_name")
        def.setValue(user_phone, forKey: "user_phone")
        def.setValue(user_photo, forKey: "user_photo")
        def.setValue(​user_pass, forKey: "​user_password")
        def.synchronize()
        restartApp()
    }
    
    class func saveMsg(message: String){
        let defa = UserDefaults.standard
        defa.setValue(message, forKey: "message" )
        defa.synchronize()
    }
    
    class func getMsg() -> String {
        let def = UserDefaults.standard
        return (def.object(forKey: "message") as! String)
    }
    
    class func getSubDepart() -> Int {
         let def = UserDefaults.standard
         return (def.object(forKey: "sub_name") as! Int)
        
    }
    
    class func getApiToken() -> Int {
        let def = UserDefaults.standard
        return (def.object(forKey: "user_id") as! Int)
    }
    
    class func getUserData()->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_email") as? String) != nil
    }
    
    class func getUserPhone()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_phone") as! String)
    }
    
    class func getData()->Dictionary<String,String>{
        let def = UserDefaults.standard
        let data:[String:String] = [
            "user_email":def.object(forKey: "user_email") as!String ,
            "user_name":def.object(forKey: "user_name")as!String,
            "user_photo":def.object(forKey: "user_photo") as!String,
            //"user_pass":def.object(forKey: "user_pass") as! String
            ]
        return data
    }
    
    class func deletUserDefaults() {

        UserDefaults.standard.removeObject(forKey: "user_email")
        restartApp()
        
    }
    
   class func saveInputs(input: String) {
        let defa = UserDefaults.standard
        defa.set(input, forKey: "inputsArray")
        UserDefaults.standard.synchronize()
        
    }
    
    
    class func setToken(token:String){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "token")
    }
    
    class func getToken()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "token") as? String)!
    }
    
    
    
    
    
    
    
    
    
    
    
}
