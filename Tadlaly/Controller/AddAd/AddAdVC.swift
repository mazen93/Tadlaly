//
//  AddAdVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import SVProgressHUD
import Alamofire
import SwiftyJSON
import ImagePicker
import Lightbox
class AddAdVC: UIViewController{
    
      var array:[UIImage]=[]
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
    @IBOutlet weak var contentTF: UITextView!

    @IBOutlet weak var showPh: UIButton!
    @IBOutlet weak var showPrice: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleBtn: UIButton!
    @IBOutlet weak var nxBtn: CornerButtons!
    @IBOutlet weak var phLab: UILabel!
    @IBOutlet weak var priLab: UILabel!
    
    @IBOutlet weak var adConLab: UILabel!
    @IBOutlet weak var addPicLab: UILabel!
    @IBOutlet weak var maxLab: UILabel!
    
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
   fileprivate var locationManager:CLLocationManager!
    
    
    
    
       var longTuide = ""
       var latitude = ""
    
            var images = [UIImage]()
            var imgString = [String]()
    
    
            var ti = ""
            var city = ""
            var phn = ""
            var pric = ""
            var cntnt = ""    
            var showNum = "\(2)"
    
            let main = [CategoriesDep]()
            let typeData = ["Select Type", "new", "used","none"]
    
            var indx = [Int]()
    
    
    
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
        
        typeTF.placeholder = General.stringForKey(key: "type")
        departmentTF.placeholder = General.stringForKey(key: "department")
        brancheTF.placeholder = General.stringForKey(key: "branch")
        priLab.text = General.stringForKey(key: "Undefiend")
        titleTF.placeholder = General.stringForKey(key: "ad title")
        cityTF.placeholder = General.stringForKey(key: "city")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        priceTF.placeholder = General.stringForKey(key: "price")
        adConLab.text = General.stringForKey(key: "content")
        addPicLab.text = General.stringForKey(key: "add photo")
        maxLab.text = General.stringForKey(key: "max 6 images.scroll to load more photos")
        nxBtn.setTitle(General.stringForKey(key: "next"), for: .normal)
        

        
        self.contentTF.layer.cornerRadius = 10.0
        self.contentTF.clipsToBounds = true


     
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
        
        showPh.setImage(UIImage(named:"che1"), for: .normal)
        showPh.setImage(UIImage(named:"che2"), for: .selected)
        
        showPrice.setImage(UIImage(named:"che1"), for: .normal)
        showPrice.setImage(UIImage(named:"che2"), for: .selected)
        
        images = Array.init(repeating: #imageLiteral(resourceName: "logo"), count: 6)

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        
    }
   
    
    
    func sub() {
        print("looooooad")
        API.categoryDep { (error: Error?, data: [CategoriesDep]?) in
            if data != nil {
                self.categoryData = data!
               // self.cateCollectionView.reloadData()
                self.nxBtn.alpha = 1.0
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
                    print("main cate id is \(id)")
                  
                    
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
                        
                        self.collectionView.reloadData()
                       }
                    }}
                  }
                }
             }
        
    }
    
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "uploadUnwind", sender: self)
        
    }
    
    
    @IBAction func showPhoBtn(_ sender: UIButton) {
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
    
    
    @IBAction func priceBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.priceTF.text = ""
            self.priceTF.isUserInteractionEnabled = true
            self.audioPlayer.play()
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
    
    
    @IBAction func getPicBtn(_ sender: Any) {
     //   audioPlayer.play()
          //  getImage()
        let config = Configuration()
        config.doneButtonTitle = "Finish"
        
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 6
        imagePicker.delegate = self
       
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    

    
    
    @IBAction func nextBtn(_ sender: Any) {
        audioPlayer.play()
        guard let tit = titleTF.text, !tit.isEmpty,
              let cit = cityTF.text, !cit.isEmpty,
              let ph = phoneTF.text, !ph.isEmpty,
              let pri = priceTF.text, !pri.isEmpty,
              let cnt = contentTF.text, !cnt.isEmpty ,
        
        let dep=departmentTF.text,!dep.isEmpty,
        let bran=brancheTF.text ,!bran.isEmpty,
        let typ = typeTF.text ,!typ.isEmpty
        
        
        else {
              SVProgressHUD.show(UIImage(named: "er.png")!, status: "make sure that all fields not empty")
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.5)
                 return
            
        }
        print("countttt \(imgString.count)")
        
             self.ti = tit
             self.city = cit
             self.phn = ph
             self.pric = pri
             self.cntnt = cnt
             self.departmentName = dep
             self.branchName = bran
             self.typeName = typ
        
            performSegue(withIdentifier: "ContractSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContractSegue" {
            let ag = segue.destination as? ContractVC
              ag?.recLa = latitude
              ag?.recLo = longTuide
              ag?.recImgs = array
              ag?.recShPh = showNum
              ag?.recMa = branchName
              ag?.recDe = departmentName
              ag?.recTyp = typeName
              ag?.recPh = phn
              ag?.recTitle = ti
              ag?.recPri = pric
              ag?.recCon = cntnt
              ag?.recCity = city
            
            
            
            
            
        }
    }
    
    

    
    
    
    
    

}

extension AddAdVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
     //self.priceTF.isUserInteractionEnabled = false
        //self.priceTF.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //self.priceTF.isUserInteractionEnabled = false
        //self.priceTF.resignFirstResponder()
        
        return true
    }
}
//extension AddAdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                if let imgEdited = info[.editedImage] as? UIImage {
//                    self.pickedImg = imgEdited
//                } else if let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    self.pickedImg = orignalImg
//                }
//                picker.dismiss(animated: true, completion: nil)
//    }
//
//}
extension AddAdVC: CLLocationManagerDelegate {
    
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





extension AddAdVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
        if (pickerView.tag == 0) {
            return categoryData.count
        }else if (pickerView.tag == 1){
           return branchData.count
        } else if (pickerView.tag == 2) {
            return typeData.count
        }
         return 1
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if pickerView.tag == 0 {
            return categoryData[row].depName
        }else if pickerView.tag == 1{
            return branchData[row].subName
        }  else if pickerView.tag == 2 {
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

extension AddAdVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCell", for: indexPath) as! AddAdCell
        
        cell.adImg.image = array[indexPath.row]
        
        cell.removee.layer.setValue(indexPath.row, forKey: "index")
        cell.removee.addTarget(self, action: #selector(deleteUser(sender:)), for: UIControl.Event.touchUpInside)
       // cell.delegate = self
        
        return cell
    }
    @objc func deleteUser(sender:UIButton) {
        
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        array.remove(at: i)
         collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/3
        
        return CGSize.init(width: width, height: width)
    }
    
   
    
}
//extension AddAdVC: deleteCell {
//
//    func remove(_ sender: AddAdCell) {
//        self.audioPlayer.play()
//        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
//         print(tappedIndexPath.row)
//        let cell = collectionView.cellForItem(at: tappedIndexPath) as! AddAdCell
//          let s  = cell.rem!
//        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//               s.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        }) { (success) in
//            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//                s.isSelected = !sender.isSelected
//                s.transform = .identity
//                self.indx.append(tappedIndexPath.row)
//            }, completion: nil)
//        }
//    }
//
//
//
//
//
//}








extension AddAdVC:ImagePickerDelegate {
    // MARK: - ImagePickerDelegate
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
        array.append(contentsOf: images)
        collectionView.reloadData()
        
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
  
}



