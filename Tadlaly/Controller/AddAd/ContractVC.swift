//
//  ContractVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class ContractVC: UIViewController {
    
    @IBOutlet weak var Seg: UISegmentedControl!
    @IBOutlet weak var segTwo: UISegmentedControl!
    @IBOutlet weak var segTh: UISegmentedControl!
    
    @IBOutlet weak var SeBtn: CornerButtons!
    var isSelectedOne = false
    var isSelectedTwo = false
    var isSelectedThree = false
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    var recTitle = ""
    var recMa  = ""
    var recDe = ""
    var recPri = ""
    var recCon = ""
    var recTyp = ""
    var recCity = ""
    var recPh = ""
    var recShPh = ""
    var recLo = ""
    var recLa = ""
   // var recImgs = [String]()
 var recImgs = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        

    }
    

    @IBAction func segOneBtn(_ sender: Any) {
        audioPlayer.play()
        if Seg.selectedSegmentIndex == 0 {
            self.isSelectedOne = false
        } else {
            self.isSelectedOne = true
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        audioPlayer.play()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func segTwoBtn(_ sender: Any) {
        audioPlayer.play()
        if segTwo.selectedSegmentIndex == 0 {
            self.isSelectedTwo = false
        } else {
            self.isSelectedTwo = true
        }
    }
    
    
    @IBAction func SegThirdBtn(_ sender: Any) {
        audioPlayer.play()
        if segTh.selectedSegmentIndex == 0 {
            self.isSelectedThree = false
        } else {
            self.isSelectedThree = true
        }
    }
    
    
    @IBAction func imgTappedBtn(_ sender: Any) {
        audioPlayer.play()
        if let url = URL(string: URLs.ekhaa ) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func agrementBtn(_ sender: Any) {
        audioPlayer.play()
        // Waiting for the link
        
    }
    
    @IBAction func SendBtn(_ sender: Any) {
      audioPlayer.play()
        LogInVC.shared.hudStart()
        if isSelectedTwo && isSelectedTwo && isSelectedThree == true {
            
            
            
            
            
            
            
            
            print(recTitle)
            print(recMa)
            print(recDe)
            print(recPri)
            print(recCon)
            print(recTyp)
            print(recCity)
            print(recPh)
            print( recShPh)
            print(recLo)
            print(recLa)
            print(recImgs.count)
    
            
        
            
            
        
            
            
    API.addAde(advertisementTitle: recTitle, mainDepartment: recMa, subDepartment: recDe, advertisementPrice: recPri, advertisementContent: recCon, advertisementType: recTyp, city: recCity, phone: recPh, showPhone: recShPh, googleLong: recLo, googleLat: recLa, image: recImgs) { (error:Error?, success: Bool?) in
        if success! {
            
            
            print("sucess")
            
           } else {
            SVProgressHUD.show(UIImage(named: "noWifi.png")!, status: "Connection Weak!")
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.0)
               }
            }
        } else {
            SVProgressHUD.show(UIImage(named: "er.png")!, status: "you must select agree about our rules")
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.5)
        }
    }
    
    
    
    
    
}
