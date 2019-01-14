//
//  RegisterVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import CoreLocation
import SVProgressHUD


class RegisterVC: UIViewController {

   
    @IBOutlet weak var pro: UIImageView!
    @IBOutlet weak var userNamTF: ImageInsideTextField!
    @IBOutlet weak var phoneTF: ImageInsideTextField!
    @IBOutlet weak var emailTf: ImageInsideTextField!
    @IBOutlet weak var locationTf: ImageInsideTextField!
    @IBOutlet weak var passwordTf: ImageInsideTextField!
    @IBOutlet weak var rePasswordTF: ImageInsideTextField!

    @IBOutlet weak var reBtn: UIButton!
    @IBOutlet weak var creBtn: CornerButtons!
    @IBOutlet weak var nav: UINavigationBar!
    

   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()

    
    
     fileprivate  var locationManager:CLLocationManager!
     fileprivate var longTuide = ""
     fileprivate var latitude = ""
     fileprivate var imgString = ""
     fileprivate var isSelect = false
    

    
     var recNav = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if recNav == "menu" {
            self.nav.alpha  = 1.0
        } else {
            self.nav.alpha = 0
        }

        
        userNamTF.placeholder = General.stringForKey(key: "userName")
        phoneTF.placeholder = General.stringForKey(key: "(+country key)phone")
        emailTf.placeholder = General.stringForKey(key: "E-mail")
        locationTf.placeholder = General.stringForKey(key: "city")
        passwordTf.placeholder = General.stringForKey(key: "Password")
        rePasswordTF.placeholder = General.stringForKey(key: "re-password")
        creBtn.setTitle(General.stringForKey(key: "Create account"), for: .normal)
        reBtn.setTitle(General.stringForKey(key: "approve the terms and conditions"), for: .normal)
        
        
        
        self.userNamTF.delegate = self
        self.phoneTF.delegate = self
        self.emailTf.delegate = self
        self.passwordTf.delegate = self
        self.rePasswordTF.delegate = self
        self.locationTf.delegate = self

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
            


        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }


   }


    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        self.navigationController?.isNavigationBarHidden = false
//        //self.navigationController?.setNavigationBarHidden(false, animated: true)
//        
//    }
//

    @IBAction func CreateBtn(_ sender: Any) {

          audioPlayer.play()
          LogInVC.shared.hudStart()
     guard  let Name = userNamTF.text?.trimmed, !Name.isEmpty ,
            let phoneNum = phoneTF.text?.trimmed, !phoneNum.isEmpty,
            let email = emailTf.text?.trimmed, !email.isEmpty,
            let password = passwordTf.text , !password.isEmpty ,
            let passwordAgain = rePasswordTF.text , !passwordAgain.isEmpty,
            let location = locationTf.text, !location.isEmpty
            else {
                SVProgressHUD.dismiss()
                return AlertPopUp(title: "Error!", message: "You have to fill all fields")
            }
        guard password == passwordAgain else {
            SVProgressHUD.dismiss()
            return AlertPopUp(title: "Error!", message: "Make sure you wrote same password")
        }
       if isSelect == true {
            print("Go ahead")
        API.register(firstName: Name, lastName: Name, phoneNum: phoneNum, email: email, fullName: Name, password: password, location: location, latitude: latitude, longtuide: longTuide, userTokenId: "", image: imgString, completion: { (error: Error?, success:Bool) in
            if success {
//              let msg = helper.getMsg()
//                self.AlertPopUp(title: "Status❓🤔", message: msg)
            } else {
                SVProgressHUD.dismiss()
                self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
                  }
                })
            } else  {
             SVProgressHUD.dismiss()
            AlertPopUp(title: "Error‼️", message: "You have to select agree ✔️ for terms")
                }
               }


    @IBAction func pickImgBtn(_ sender: Any) {

        audioPlayer.play()
         getImage()

    }


    
    @IBAction func chekBtn(_ sender: UIButton) {

            audioPlayer.play()
        if let image = UIImage(named: "che2") {
            sender.setImage(image,  for: .normal)
        }
        sender.isUserInteractionEnabled = false
           self.isSelect = true
    }


    @IBAction func rulesBtn(_ sender: Any) {
        performSegue(withIdentifier: "RulesSegue", sender: self)
    }
    
    @IBAction func unwindBtn(_ sender: Any) {
        performSegue(withIdentifier: "regUnwind", sender: self)
    }
    

    func getImage() {
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
            pickAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(pickAlert, animated: true, completion: nil)

        picker.delegate = self

    }


    var pickedImg: UIImage? {
        didSet {
            guard let image = pickedImg else {return}
            pro.image = image
            imgString  = base64(from: image)!
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



    func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


}






extension RegisterVC: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.userNamTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.emailTf.resignFirstResponder()
        self.passwordTf.resignFirstResponder()
        self.rePasswordTF.resignFirstResponder()
        self.locationTf.resignFirstResponder()

        return (true)
    }
}


extension RegisterVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation :CLLocation = locations[0] as CLLocation

        self.longTuide = "\(userLocation.coordinate.longitude)"
        self.latitude = "\(userLocation.coordinate.latitude)"
        print(self.longTuide)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                //print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

               
                self.locationTf.text = placemark.administrativeArea!

                  }
                }

        locationManager.stopUpdatingLocation()
              }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }


}




extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

