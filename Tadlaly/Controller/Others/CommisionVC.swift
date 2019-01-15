//
//  CommisionVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/29/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD


class CommisionVC: UIViewController {

    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var adIdTF: UITextField!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var seBtn: UIButton!
    @IBOutlet weak var bankTF: UITextField!
    
    var bankArray = [BankAccounts]()
    var stringImg = ""
    var bank = ""
    var date = ""
    
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.tag=0
        pickerView.delegate = self
        bankTF.inputView = pickerView
        
        
        bankTF.placeholder = General.stringForKey(key: "Bank")
        NameTF.placeholder = General.stringForKey(key: "userName")
        amountTF.placeholder = General.stringForKey(key: "amount")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        adIdTF.placeholder = General.stringForKey(key: "adId")
        seBtn.setTitle(General.stringForKey(key: "send"), for: .normal)
        
         accountdata()
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
    
                         }

    
    @IBAction func bkButton ( _ sender: Any ) {
       performSegue(withIdentifier: "payUnwind", sender: self)
       
    }
    
    
           @IBAction func dateBtn(_ sender: UIDatePicker) {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMM dd, YYYY"
               date = dateFormatter.string(from: sender.date)
               print(date)
                       }
    
    
            @IBAction func getPicBtn(_ sender: Any) {
              audioPlayer.play()
              getImage()
              }
    
    
          @IBAction func sendBtn(_ sender: Any) {
        
            audioPlayer.play()
            LogInVC.shared.hudStart()
            guard let userName = NameTF.text, !userName.isEmpty ,
                let amount = amountTF.text, !amount.isEmpty,
                let adCode = adIdTF.text, !adCode.isEmpty ,
                let transferFrom = phoneTF.text, !transferFrom.isEmpty,
                let bnk = bankTF.text, !bnk.isEmpty
                else {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "you must fill all fields")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 3.0)
                    return
                        }
            
            API.transferPayment(userName: userName, amount: amount, bank: bank, date: date, person: transferFrom, code: adCode, image: stringImg) { (error: Error?, success: Bool) in
                if success {
                      } else {
                    SVProgressHUD.dismiss()
                    self.AlertPopUP(title: "Connection Weak☹️", message: "Please try again later")
                  }
               }
            }
    
    
    
    
    func accountdata(){
        API.BankAccountsApi{(error :Error?, data: [BankAccounts]?) in
            if data != nil {
            self.bankArray = data!
            //self.pickerView.reloadAllComponents()
            } else {
                print("no data")
                
            }
         }
      
    }
    
    
    
    func getImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        let pickAlert = UIAlertController(title: "Add Picture", message:"Please choose📸" , preferredStyle: .alert)
        pickAlert.addAction(UIAlertAction(title: "Take A Picture", style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        pickAlert.addAction(UIAlertAction(title: "Select From Library", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker , animated: true, completion: nil)
        }))
        pickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(pickAlert, animated: true, completion: nil)
        
        picker.delegate = self
        
    }
    
    
        var pickImg: UIImage? {
               didSet {
                   guard let image = pickImg else {return}
                   pic.image = image
                   stringImg = base64(from: image)!
                   print(base64(from: image)!)
                     }
                  }
    
    
        func base64(from image: UIImage) -> String? {
            let imageData = image.pngData()
              if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
            return imageString
                }
                return nil
             }
    
    

    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
         }
    
    
}


extension CommisionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return bankArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             let nameAcc = bankArray[row].account_bank_name
        return nameAcc
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          bankTF.text = bankArray[row].account_bank_name
          bank = bankArray[row].account_bank_name
        
             }
    
    

    
}
extension CommisionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgEdited = info[.editedImage] as? UIImage {
            self.pickImg = imgEdited
        } else if let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickImg = orignalImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

