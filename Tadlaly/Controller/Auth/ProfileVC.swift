//
//  ProfileVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/27/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import Kingfisher
import SVProgressHUD

//cant display the password
class ProfileVC: UIViewController {

    
    @IBOutlet weak var prof: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var cityView: UIView!
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    fileprivate var imgString = ""
 
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.placeholder = General.stringForKey(key: "userName")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        emailTF.placeholder = General.stringForKey(key: "E-mail")
        passTF.placeholder = General.stringForKey(key: "password")
        cityTF.placeholder = General.stringForKey(key: "city")
        navigationItem.title = General.stringForKey(key: "profile")
        
        
        
        nameTF.delegate = self
        emailTF.delegate = self
        cityTF.delegate = self
        passTF.delegate = self
        phoneTF.delegate = self
        
//        nameTF.resignFirstResponder()
//        emailTF.resignFirstResponder()
//        cityTF.resignFirstResponder()
//        passTF.resignFirstResponder()
//        phoneTF.resignFirstResponder()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
    
        self.nameView.floatView()
        self.phoneView.floatView()
        self.emailView.floatView()
        self.passView.floatView()
        self.cityView.floatView()
        
        userData()
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        if helper.getUserData() == false {
            self.performSegue(withIdentifier: "profileUnwind", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func picBtn(_ sender: Any) {
        audioPlayer.play()
        getImage()
    }
    @IBAction func nameBtn(_ sender: Any) {
        audioPlayer.play()
        self.nameTF.isUserInteractionEnabled = true
    }
    @IBAction func phoneBtn(_ sender: Any) {
        audioPlayer.play()
        self.phoneTF.isUserInteractionEnabled = true
    }
    @IBAction func emailBtn(_ sender: Any) {
        audioPlayer.play()
        self.emailTF.isUserInteractionEnabled = true
    }
    @IBAction func passBtn(_ sender: Any) {
        audioPlayer.play()
        self.passTF.isUserInteractionEnabled = true
    }
    @IBAction func cityBtn(_ sender: Any) {
        audioPlayer.play()
        self.cityTF.isUserInteractionEnabled = true
        getLocation()
    }
    
    
    
    

    
         fileprivate func getImage() {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
        
                 let pickAlert = UIAlertController(title: "Add Picture", message:"Please Select " , preferredStyle: .alert)
                 pickAlert.addAction(UIAlertAction(title: "Take A Picture", style: .default, handler: { (action) in
                    picker.sourceType = .camera
                    self.present(picker, animated: true, completion: nil)
                   }))
                 pickAlert.addAction(UIAlertAction(title: "Select From Library", style: .default, handler: { (action) in
                   picker.sourceType = .photoLibrary
                   self.present(picker , animated: true, completion: nil)
                 }))
                 pickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                   pickAlert .dismiss(animated: true, completion: nil)
                }))
                   self.present(pickAlert, animated: true, completion: nil)
        
                  picker.delegate = self
        
                }
    
    
          fileprivate var pickedImg: UIImage? {
               didSet {
                guard let image = pickedImg else {return}
                    imgString  = base64(from: image)!
                       print(base64(from: image)!)
                    API.updateProfile(userName: "", userPhone: "", email: "", image: imgString, fullName: "", lon: "", lat: "", city: "") { (error: Error?, success:Bool?) in
                        if success! {
                            //prof.image = image
                        } else {
                            SVProgressHUD.show(UIImage(named: "er.png")!, status: "Connection Weak‼️. try again later")
                            SVProgressHUD.setShouldTintImages(false)
                            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                            SVProgressHUD.dismiss(withDelay: 3.0)

                                }
                           }
                        }
                       }
    
    
             fileprivate func base64(from image: UIImage) -> String? {
                let imageData = image.pngData()
                       if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
                        return imageString
                         }
                      return nil
                       }
    
    
    
    
 fileprivate func  getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
   fileprivate func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
               }
    

    
   fileprivate func userData() {
        if helper.getUserData() == true {
            let da = helper.getData()
            let urlString = URLs.image+da["user_photo"]!
            let url = URL(string: urlString)
            prof.kf.indicatorType = .activity
            prof.kf.setImage(with: url)
            self.nameTF.text = (UserDefaults.standard.object(forKey: "user_name") as! String)
            self.emailTF.text = (UserDefaults.standard.object(forKey: "user_email") as! String)
            self.cityTF.text = (UserDefaults.standard.object(forKey: "user_city") as! String)
            self.passTF.text = (UserDefaults.standard.object(forKey: "user_password") as! String)
            self.phoneTF.text = (UserDefaults.standard.object(forKey: "user_phone") as! String)
             } else {
           }
        }
    
 
    
    
    
    

}

extension ProfileVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
        self.longTuide = "\(userLocation.coordinate.longitude)"
        self.latitude = "\(userLocation.coordinate.latitude)"
        print(self.longTuide)
        locationManager.stopUpdatingLocation()
        
           }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
           }


}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgEdited = info[.editedImage] as? UIImage {
            self.pickedImg = imgEdited
        } else if let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImg = orignalImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


extension ProfileVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            guard let nam = nameTF.text, !nam.isEmpty else {return}
            API.updateProfile(userName: nam, userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                  self.nameTF.isUserInteractionEnabled = false
                } else {
                    self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                }
            })
           self.nameTF.isUserInteractionEnabled = false
        } else if textField.tag == 2 {
            guard let pho = phoneTF.text, !pho.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: pho, email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                self.phoneTF.isUserInteractionEnabled = false
                } else {
                    self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                }
            })
            self.phoneTF.isUserInteractionEnabled = false
        } else if textField.tag == 3 {
            guard let mail = emailTF.text, !mail.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: "", email: mail, image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.emailTF.isUserInteractionEnabled = false
                } else {
                    self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                }
            })
            self.emailTF.isUserInteractionEnabled = false
        } else if textField.tag == 5 {
            guard let pass = passTF.text, !pass.isEmpty else {return}
            API.updatePass(user_old_pass: pass, user_new_pass: pass, completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.passTF.isUserInteractionEnabled = false
                } else {
                    self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                }
            })
            self.passTF.isUserInteractionEnabled = false
        } else if textField.tag == 6 {
            guard let loca = cityTF.text, !loca.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: loca, completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.cityTF.isUserInteractionEnabled = false
                } else {
                    self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                }
            })
            self.cityTF.isUserInteractionEnabled = false
        }
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.nameTF.isUserInteractionEnabled = false
            if let nam = nameTF.text, !nam.isEmpty {
                API.updateProfile(userName: nam, userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success:Bool?) in
                    if success! {
                       self.nameTF.isUserInteractionEnabled = false
                    } else {
                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                    }
                })
            } else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
        } else if textField.tag == 2 {
            self.phoneTF.isUserInteractionEnabled = false
            if let pho = phoneTF.text, !pho.isEmpty {
                API.updateProfile(userName: "", userPhone: pho, email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                    if success! {
                        self.phoneTF.isUserInteractionEnabled = false
                    } else {
                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                    }
                })
            }
            else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
        } else if textField.tag == 3 {
            self.emailTF.isUserInteractionEnabled = false
            if let mail = emailTF.text, !mail.isEmpty {
                API.updateProfile(userName: "", userPhone: "", email: mail, image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success:Bool?) in
                    if success! {
                      self.emailTF.isUserInteractionEnabled = false
                    } else {
                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                    }
                })
            } else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
        } else if textField.tag == 5 {
            if let pass = passTF.text, !pass.isEmpty {
                self.passTF.isUserInteractionEnabled = false
                API.updatePass(user_old_pass: pass, user_new_pass: pass, completion: { (error: Error?, success:Bool?) in
                    if success! {
                     self.passTF.isUserInteractionEnabled = false
                    } else {
                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                    }
                })
            } else {
                AlertPopUp(title: "Error!", message: "You must fill field")}
        } else if textField.tag == 6 {
            self.cityTF.isUserInteractionEnabled = false
            if let loca = cityTF.text, !loca.isEmpty {
                API.updateProfile(userName: "", userPhone: "", email: "", image: "", fullName: "", lon: longTuide, lat: latitude, city: loca, completion: { (error: Error?, success:Bool?) in
                    if success! {
                      self.cityTF.isUserInteractionEnabled = false
                    } else {
                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                    }
                })
             } else { AlertPopUp(title: "Error!", message: "You mus fill field")}
           }
        
        return true
    }
    
    
    
    
}
extension UIView {
    
    func floatView() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
    }
    
}






