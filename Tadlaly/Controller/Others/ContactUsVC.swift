//
//  ContactUsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ContactUsVC: UIViewController {

    @IBOutlet weak var namTF: UITextField!
    @IBOutlet weak var emaiTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var subjecTF: UITextField!
    @IBOutlet weak var msgTf: UITextView!
    
    @IBOutlet weak var maBtn: UIButton!
    @IBOutlet weak var wtsBtn: UIButton!
    @IBOutlet weak var senBtn: CornerButtons!
    
    
    var watsapp = ""
    var email = ""
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maBtn.alignText()
        wtsBtn.alignText()
        wtsBtn.setTitle(General.stringForKey(key: "connect through whatsapp"), for: .normal)
        maBtn.setTitle(General.stringForKey(key: "connect trough e-mail"), for: .normal)
        senBtn.setTitle(General.stringForKey(key: "send"), for: .normal)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//        try? AVAudioSession.sharedInstance().setActive(true)
        
        getData()
        
        self.msgTf.layer.cornerRadius = 10.0
        self.msgTf.clipsToBounds = true

    }

    
    @IBAction func bkBtn(_ sender: Any) {
        audioPlayer.play()
        if helper.getUserData() == false {
       performSegue(withIdentifier: "conntactUnwind", sender: self)
        }
      else {
          self.dismiss(animated: true, completion: nil)
         }
    }
    
    
    @IBAction func SendBtn(_ sender: Any) {
        audioPlayer.play()
        guard let name = namTF.text, !name.isEmpty,
            let email = emaiTF.text, !email.isEmpty,
            let phoneNum = phoneTF.text , !phoneNum.isEmpty,
            let message = msgTf.text, !message.isEmpty,
            let subj = subjecTF.text, !subj.isEmpty
            else{ return AlertPopUP(title: "Error!", message: "You have to fill all fields")}
        API.ContactUS(name: name, email: email, subject: subj, message: message, phone: phoneNum) { (error: Error?, success: Bool) in
            if success {
                self.AlertPopUP(title: "Success👍🏻", message: "Your message has been sent")
                self.namTF.text = ""
                self.emaiTF.text = ""
                self.phoneTF.text = ""
                self.msgTf.text = ""
                self.subjecTF.text = ""
            } else {
                self.AlertPopUP(title: "Connection Faild‼️", message: "Please try again")
            }
        }
    }
    
    @IBAction func emailBtn(_ sender: Any) {
        audioPlayer.play()
        let url = NSURL(string: "mailto:\(self.email)")
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func whatsAppBtn(_ sender: Any) {
        audioPlayer.play()
        let urlWhats = "whatsapp://send?phone=\(self.watsapp)?text=hello"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                }
                else {
                    AlertPopUP(title: "Error!", message: "You have to install whatsapp")
                }
            }
        }
        
    }
    
    
    
    func getData() {
        Alamofire.request(URLs.contactUs) .responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                self.watsapp = jsonData["whatsapp"].object as! String
                self.email = jsonData["email"].object as! String
            } else {
                print("faild")
            }
        }
    }
    
    func AlertPopUP(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
extension UIButton {
    
    func alignText(spacing: CGFloat = 12.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}


