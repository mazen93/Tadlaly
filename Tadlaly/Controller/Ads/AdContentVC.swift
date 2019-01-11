//
//  AdContentVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/25/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import ImageSlideshow
import Kingfisher
import SVProgressHUD
import Alamofire
import SwiftyJSON

// waiting to recImgs and display it

class AdContentVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    // @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var detailsView: UITextView!
    @IBOutlet weak var float: UIView!
    @IBOutlet weak var floatCard: UIView!
    @IBOutlet weak var codeTF: UILabel!
    @IBOutlet weak var priceTF: UILabel!
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var kindTF: UILabel!
    @IBOutlet weak var titleTF: UILabel!
    @IBOutlet weak var cityTF: UILabel!
    @IBOutlet weak var shareTF: UILabel!
    @IBOutlet weak var bar: UITabBar!
    
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    
    var recCity = ""
    var recTitle = ""
    var recContent = ""
    var recPrice = ""
    var recDate = ""
    var recKind = ""
    var recCode = ""
    var recNum = ""
    var recShare = ""
    var recAdId = ""
    var recUserId = ""
    var recOwner = ""
   // var recImgs = [UIImage]()
    
    
    var recImgs = [String]()
    var recPage = ""
    var recIdAdv = ""
    var recShoPh = ""
    var recTyp = ""
  var array:[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadShare()
        collection.delegate=self
        collection.dataSource=self
        
        
        for images in recImgs{
            array.append(images)
            collection.reloadData()

        }
        
        
        self.titleTF.text = recTitle
        self.cityTF.text = recCity
        self.dateTF.text = recDate
        self.detailsView.text = recContent
        self.priceTF.text = recPrice
        self.shareTF.text = recShare
        self.codeTF.text = recAdId
        
        if recTyp == "1" {
            self.kindTF.text = "new"
        } else if recTyp == "2" {
            self.kindTF.backgroundColor = UIColor.gray
            self.kindTF.text = "used"
        } else {
            self.kindTF.text = "none"
            self.kindTF.backgroundColor = UIColor.gray
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        self.bar.delegate = self
        
     //   self.slideshow.floaat()
        self.detailsView.floaat()
        self.floatCard.floaat()

        self.float.layer.cornerRadius = 10
        self.float.layer.shadowColor = UIColor.clear.cgColor
        self.float.layer.shadowRadius = 5
        self.float.layer.shadowOpacity = 1
        self.float.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.kindTF.layer.cornerRadius = 10
        self.kindTF.layer.shadowColor = UIColor.darkGray.cgColor
        self.kindTF.layer.shadowRadius = 5
        self.kindTF.layer.shadowOpacity = 1
        self.kindTF.layer.shadowOffset = CGSize(width: 0, height: 0)
        
//        slideshow.slideshowInterval = 5.0
//        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
//
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor.black
//        pageControl.pageIndicatorTintColor = UIColor.white
//        slideshow.pageIndicator = pageControl
//
//        slideshow.activityIndicator = DefaultActivityIndicator()
//        slideshow.currentPageChanged = { page in
//            print("current page:", page)
//        }
//
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(AdContentVC.didTap))
//        slideshow.addGestureRecognizer(recognizer)
        
        //slideshow.setImageInputs(recImgs as! [InputSource])
    
     
    }
    
    
    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        if recPage == "adsPage" {
            if helper.getUserData() == false {
                performSegue(withIdentifier: "unwindAds", sender: self)
            } else {
                performSegue(withIdentifier: "unwindAds", sender: self)
                //self.dismiss(animated: true, completion: nil)
            }
        } else if recPage == "searchPage" {
            if helper.getUserData() == false {
                performSegue(withIdentifier: "unwindSearch", sender: self)
            } else {
                performSegue(withIdentifier: "unwindSearch", sender: self)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        else if recPage == "myAdsPage" {
            if helper.getUserData() == false {
                performSegue(withIdentifier: "unwindMyAds", sender: self)
            } else {
                performSegue(withIdentifier: "unwindMyAds", sender: self)
            }
        }
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatSegue" {
            let sb = segue.destination as? ChatVC
            sb?.recNum = recNum
            sb?.recToUser = recUserId
            sb?.recName = recOwner
        }
    }
    
    func uploadShare() {
        API.count(idAdv: recIdAdv , count: "2") { (error: Error?, success: Bool?) in
            if success! {
                print("success share")
            } else {
                print("faild share")
            }
        }
    }

    
        func AlertPopUP(title: String, message: String ) {
        
             let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default,     handler: { (action) in
                 alert.dismiss(animated: true, completion: nil)
              }))
              self.present(alert, animated: true, completion: nil)
                    }
   

}
extension AdContentVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 7) {
         audioPlayer.play()
            if helper.getUserData() == true {
             performSegue(withIdentifier: "ChatSegue", sender: self)
            } else {
                //performSegue(withIdentifier: "ChatSegue", sender: self)
                SVProgressHUD.show(UIImage(named: "er.png")!, status: "you need to login to access")
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 4.0)
            }
            
        } else if (item.tag == 8) {
            audioPlayer.play()
            if recShoPh == "2" {
                self.AlertPopUP(title: "no phone found", message: "user not allow to share phone number")
            } else {
                let msg = "السلام عليكم بخصوص اعلانك علي تطبيق تدللي \(self.recTitle)\(self.recCode)"
                let urlWhats = "whatsapp://send?phone=\(self.recNum)?text=\(msg)"
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
            
        } else if (item.tag == 9) {
            audioPlayer.play()
            if recShoPh == "2" {
        self.AlertPopUP(title: "no phone found", message: "user not allow to share phone number")
            } else {
         if let url = URL(string: "tel://\(recNum)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                  }
                }
              }
           }
    
    
}
extension UIView{
    func floaat() {

        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
}








extension AdContentVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("array \(array.count)")
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "imageSliderCell", for: indexPath) as! imageSliderCell
        
        
        cell.setData(facility: array[indexPath.row])
        return cell
    }
    // size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    
    
    
  
    
    
    
    
}
