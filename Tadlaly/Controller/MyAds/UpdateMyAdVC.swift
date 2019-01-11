//
//  UpdateMyAdVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import Alamofire
import SwiftyJSON
import ImagePicker


// need to select multi cell and delet
class UpdateMyAdVC: UIViewController {
    
    
    
    
    // outlet for branch+department
    @IBOutlet weak var departmentTF: UITextField!
    @IBOutlet weak var brancheTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    
    
    // array for branch+department
    var categoryData = [CategoriesDep]()
    var branchData = [subData]()
    // var for branch + depart
    var departmentName=""
    var branchName=""
    var typeName = ""

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var content: UITextView!
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phCheck: UIButton!
    @IBOutlet weak var priCheck: UIButton!
    @IBOutlet weak var deBtn: UIButton!
    
    @IBOutlet weak var conByAppLab: UILabel!
    @IBOutlet weak var unDeLab: UILabel!
    
    @IBOutlet weak var adCon: UILabel!
    @IBOutlet weak var adPic: UILabel!
    @IBOutlet weak var mxLab: UILabel!
    @IBOutlet weak var sndBtn: CornerButtons!
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    
    var imgString = [String]()
    
    var sectionTitle = ""
    var branchTitle = ""
    var typeTitle = ""
    
    var showNum = "\(2)"
    
    let main = [CategoriesDep]()
    let typeData = [ "Choose a type", "new", "used","none"]
    
    var recCity = ""
    var recTitle = ""
    var recContent = ""
    var recPrice = ""
    var recDate = ""
    var recNum = ""
    var recImgs = [UIImage]()
    var recId = ""
    
    var recData = [MyAds]()
    var inx = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        let pickerView = UIPickerView()
        pickerView.tag=0
        pickerView.delegate = self
        departmentTF.inputView = pickerView
        
        let pickerViewBranch = UIPickerView()
        pickerViewBranch.tag=1
        pickerViewBranch.delegate = self
        brancheTF.inputView = pickerViewBranch
        
        let pickerViewType = UIPickerView()
        pickerViewType.tag=2
        pickerViewType.delegate = self
        typeTF.inputView = pickerViewType
        
        sub()
    
        self.titleTF.text = recTitle
        self.cityTF.text = recCity
        self.content.text = recContent
        self.priceTF.text = recPrice
        self.phoneTF.text = recNum

        
        unDeLab.text = General.stringForKey(key: "Undefiend")
        titleTF.placeholder = General.stringForKey(key: "ad title")
        cityTF.placeholder = General.stringForKey(key: "city")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        priceTF.placeholder = General.stringForKey(key: "price")
        adCon.text = General.stringForKey(key: "content")
        adPic.text = General.stringForKey(key: "add photo")
        mxLab.text = General.stringForKey(key: "max 6 images.scroll to load more photos")
        sndBtn.setTitle(General.stringForKey(key: "next"), for: .normal)
        
       
        
        
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
        

        
        recImgs = Array.init(repeating: #imageLiteral(resourceName: "logo"), count: 6)
        
        phCheck.setImage(UIImage(named:"che1"), for: .normal)
        phCheck.setImage(UIImage(named:"che2"), for: .selected)
        
        priCheck.setImage(UIImage(named:"che1"), for: .normal)
        priCheck.setImage(UIImage(named:"che2"), for: .selected)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
    
    func sub() {
        
        
        print("looooooad")
        API.categoryDep { (error: Error?, data: [CategoriesDep]?) in
            if data != nil {
                self.categoryData = data!
                // self.cateCollectionView.reloadData()
               // self.nxBtn.alpha = 1.0
                //                self.prevsBtn.alpha = 1.0
                //                SVProgressHUD.dismiss()
            } else {
                print("no data")
            }
        }
    }
    
    func branches(id:String) {
        
        
        
        //
        Alamofire.request(URLs.categoryDep)
            .responseJSON { response in
                switch response.result
                {
                case .failure( _): break
                    
                    
                case .success(let value):
                    
                    
                    self.branchData.removeAll()
                    let json = JSON(value)
                    print(json)
                    
                    print("callllll")
                    print("daaaaaa \(id)")
                    
                    
                    if let dataArr = json.array
                    {
                        
                        for dataArr in dataArr {
                            
                            
                            
                            let mainId=dataArr["main_department_id"].string
                            
                            print("main \(String(describing: mainId))")
                            
                            
                            
                            if  id == mainId  {
                                print("ss id \(id)")
                                
                                
                                if let dataArr = dataArr["sub_depart"].array
                                {
                                    print("inside")
                                    
                                    for dataArr in dataArr {
                                        
                                        
                                        let id = dataArr ["sub_department_id"].string
                                        
                                        let name = dataArr ["sub_department_name"].string
                                        let icon = dataArr ["sub_department_image"].string
                                        print("it is \(id!)")
                                        
                                        // create Ream Object
                                        self.branchData.append(subData(subName: name!, subImage: icon!, subId: id!))
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                            }}
                    }
                    
                }
                
                
        }
        
        
        //
        
        
        
        
        
        //
    }
    
    
    @IBAction func baaackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func phoneCheckBtn(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.showNum = "\(2)"
            self.audioPlayer.play()
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.showNum = "\(1)"
                self.audioPlayer.play()
            }, completion: nil)
        }
    }
    
    @IBAction func priceCheckBtn(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            self.priceTF.text = ""
            self.audioPlayer.play()
            self.priceTF.isUserInteractionEnabled = true
            
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.priceTF.text = "undefined"
                self.priceTF.isUserInteractionEnabled = false
                self.audioPlayer.play()
            }, completion: nil)
        }
        
        
    }
    
    
    @IBAction func getImgBtn(_ sender: Any) {
        
        audioPlayer.play()
        getImage()
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
    guard let tit = titleTF.text, !tit.isEmpty,
          let loc = cityTF.text, !loc.isEmpty,
          let ph = phoneTF.text, !ph.isEmpty,
          let pri = priceTF.text, !pri.isEmpty,
          let con = content.text, !con.isEmpty
        else {
           return self.AlertPopUP(title: "Error!", message: "You must fill all fields")
        }
        
        API.updateMyAd(adId:recId ,main: departmentName, sub: branchName, title: tit, content: con, price: pri, type: typeName, lat: latitude, lon: longTuide, city: loc, phone: ph, showPH: showNum, imgs: imgString) { (error: Error?, data: [MyAds]?) in
            if data != nil {
                self.recData = data!
                
            } else {
                
            }
        }
    }
    
    
    @IBAction func deletBtn (_ sender: Any) {
        
        for inx in inx {
            self.recImgs.remove(at: inx)
            self.imgString.remove(at: inx)
            self.collectionView.reloadData()
           }
        self.collectionView.reloadData()
       
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
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(pickAlert, animated: true, completion: nil)
        
        picker.delegate = self
        
    }
    
    
    var pickedImg: UIImage? {
        didSet {
            guard let image = pickedImg else {return}
            self.recImgs.insert(image, at: 0)
            self.collectionView.reloadData()
            for image in recImgs {
                let result = base64(from: image)
                imgString.append(result!)
                print(result!)
            }
        }
    }
    
    
    func base64(from image: UIImage) -> String? {
        let imageData = image.pngData()
        if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
            return imageString
        }
        return nil
    }
    
    
    
//    func deletAdImg() {
//        API.deletPic(picId: "") { (error: Error?, success: Bool) in
//            if success {
//
//            } else {
//
//            }
//        }
//    }
    
    
    
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    

   

}
extension UpdateMyAdVC: CLLocationManagerDelegate {
    
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
                self.cityTF.text = placemark.administrativeArea!
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}
extension UpdateMyAdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension UpdateMyAdVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if (pickerView.tag == 0) {
            return categoryData.count
        }else if (pickerView.tag == 1){
            return branchData.count
        } else if (pickerView.tag == 2){
            return typeData.count
        }
        return 1
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        if pickerView.tag == 0 {
            return categoryData[row].depName
        }else if pickerView.tag == 1{
            return branchData[row].subName
        } else if pickerView.tag == 2 {
            return typeData[row]
        }
        
        return " "
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            print(categoryData[row].depId)
            brancheTF.alpha=1
            branches(id: categoryData[row].depId)
            print("nnnnnn \(categoryData[row].depId)")
            departmentName=categoryData[row].depName
            departmentTF.text=categoryData[row].depName
        }else if pickerView.tag == 1 {
            branchName=branchData[row].subName
            brancheTF.text=branchData[row].subName
        } else if pickerView.tag == 2 {
            typeName=typeData[row]
            typeTF.text=typeData[row]
        }
        
        
    }
    
    
    
    
}

extension UpdateMyAdVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //self.priceTF.isUserInteractionEnabled = false
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //self.priceTF.isUserInteractionEnabled = false
        
        return true
       }
}
extension UpdateMyAdVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpdateCell", for: indexPath) as! UpdateMyAdCell
        
      cell.img.image = recImgs[indexPath.row]
        
        return cell
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/3
        
        return CGSize.init(width: width, height: width)
    }

}


//extension UpdateMyAdVC: deCell {
    
    
//    func removeCell(_ sender: UpdateMyAdCell) {
//        self.audioPlayer.play()
//        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
//        print(tappedIndexPath.row)
//        let cell = collectionView.cellForItem(at: tappedIndexPath) as! AddAdCell
//       // let s  = cell.rem!
//        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//          //  s.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        }) { (success) in
//            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//                s.isSelected = !sender.isSelected
//                s.transform = .identity
//                self.inx.append(tappedIndexPath.row)
//            }, completion: nil)
//        }
//    }
  
    
//}
