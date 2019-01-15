//
//  AboutUsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class AboutUsVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var text: UITextView!
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }

        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        self.img.layer.shadowColor = UIColor.darkGray.cgColor
        self.img.layer.shadowOpacity = 0.5
        self.img.layer.shadowRadius = 4
        
        text.layer.cornerRadius = 10
        text.layer.shadowColor = UIColor.darkGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0, height: 0)
        text.layer.shadowOpacity = 0.5
        text.layer.shadowRadius = 4
    
        Alamofire.request(URLs.aboutUs) .responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                self.text.text = (jsonData["about_app"].object as! String)
            } else {
                print("faild")
            }
        }
        
        
    }

    @IBAction func back(_ sender: Any) {
        audioPlayer.play()
        performSegue(withIdentifier: "aboutUnwind", sender: self)
       
    }
    
    

   

}
