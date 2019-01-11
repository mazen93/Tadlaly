//
//  ForgetPasswordVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation


class ForgetPasswordVC: UIViewController {

    
   
    @IBOutlet weak var userNameTF: ImageInsideTextField!
    @IBOutlet weak var emailTF: ImageInsideTextField!
    @IBOutlet weak var labl: UILabel!
    @IBOutlet weak var reBtn: CornerButtons!
    
    
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.placeholder = General.stringForKey(key: "userName")
        emailTF.placeholder = General.stringForKey(key: "E-mail")
        labl.text = General.stringForKey(key: "recover your account.we will send you a link to change your password")
        reBtn.setTitle(General.stringForKey(key: "rest Password"), for: .normal)
        
        self.userNameTF.delegate = self
        self.emailTF.delegate = self
        
            do {
               audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
               } catch {
                  print("faild to load sound")
               }

        
    }
    
//    override func didMove(toParentViewController parent: UIViewController?) {
//        super.didMove(toParentViewController: parent)
//
//        if parent == nil{
//            print("Back Button pressed.")
//          audioPlayer.play()
//        }
//
//    }
    
    @IBAction func resetBtn(_ sender: Any) {
        audioPlayer.play()
        guard let userName = userNameTF.text, !userName.isEmpty,
            let email = emailTF.text, !email.isEmpty
            else { return AlertPopUp(title: "Error!", message: "You have to fill fields")}
        
        API.resetPass(user_Name: userName, user_email: email) { (error: Error?, _ success: Bool) in
            if success {
                self.AlertPopUp(title: "Request Sent📤", message:"We will send you a link in a message")
                self.userNameTF.text = ""
                self.emailTF.text = ""
            } else {
                self.AlertPopUp(title: "Faild‼️", message: "Connection weak.Please try again later")
            }
        }
    }
        
    
   fileprivate func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    
}



extension ForgetPasswordVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        
        return (true)
    }
    
}
