//
//  RulesVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/27/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RulesVC: UIViewController {

    @IBOutlet weak var txt: UITextView!
    @IBOutlet weak var titl: UILabel!
    
    @IBOutlet weak var navi: UINavigationBar!
    
    var recMenu = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recMenu == "menu" {
        self.navi.alpha = 1.0
        } else {
        self.navi.alpha = 0
        }

       self.title = "Terms and condtions"
        
        getRules()
        
        
        self.txt.layer.cornerRadius = 10.0
        self.txt.clipsToBounds = true
        self.txt.layer.shadowColor = UIColor.darkGray.cgColor
        self.txt.layer.shadowRadius = 4
        self.txt.layer.shadowOpacity = 0.8
        self.txt.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        self.titl.layer.cornerRadius = 10.0
        self.titl.clipsToBounds = true
        self.titl.layer.shadowColor = UIColor.darkGray.cgColor
        self.titl.layer.shadowRadius = 4
        self.titl.layer.shadowOpacity = 0.8
        self.titl.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
    }


    @IBAction func bkBtn(_ sender: Any) {
        performSegue(withIdentifier: "ruleUnwind", sender: self)
    }
    
    func getRules() {
        Alamofire.request(URLs.rules).responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                self.titl.text = jsonData["title"].string
                self.txt.text = jsonData["content"].string
            } else{
                print("faild")
            }
        }
    }
    
   

}
