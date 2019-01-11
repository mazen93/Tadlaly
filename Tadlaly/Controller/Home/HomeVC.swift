//
//  HomeVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
import CoreLocation
import Alamofire
import SwiftyJSON
import ImageSlideshow
import SVProgressHUD
import UPCarouselFlowLayout
import Alamofire
import SwiftyJSON

//display arrayobject at sec Collection

// show arrayobject dep depding at sub select at frist collectionView

class HomeVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var cateCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    var categoryData = [CategoriesDep]()
    var branchData = [subData]()
    
    var branchNameSelect = ""
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var slider: ImageSlideshow!
    @IBOutlet weak var offerTitleLab: UILabel!
    @IBOutlet weak var offerContentLabel: UILabel!
 
    @IBOutlet weak var menuCon: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var proImg: UIImageView!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var nxBtn: UIButton!
    @IBOutlet weak var prevsBtn: UIButton!
    
    @IBOutlet weak var lanBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var hoBtn: UIButton!
    @IBOutlet weak var loBtn: UIButton!
    @IBOutlet weak var creaBtn: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var myadBtn: UIButton!
    @IBOutlet weak var msgbTn: UIButton!
    @IBOutlet weak var pcBtn: UIButton!
    @IBOutlet weak var csBtn: UIButton!
    @IBOutlet weak var abBtn: UIButton!
    @IBOutlet weak var terBtn: UIButton!
    
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var slidData = [SlidShowData]()
    
    
    var mainNameSelect=""
     var subAd = [Ad]()
    
     fileprivate var locationManager:CLLocationManager!
     fileprivate var longTuide = ""
     fileprivate var latitude = ""
    
     fileprivate var imgSource = [InputSource]()
     fileprivate var selectedIndexPath = IndexPath()
    
      //var token = helper.getToken()
    
      var selectedSub = ""
    var BRANCHNAME = ""

//    override func viewDidAppear(_ animated: Bool) {
//        if helper.getUserData() == true {
//            updateToken()
//        } else {
//            print("he is a guest")
//        }
//
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
  
        LogInVC.shared.hudStart()
        self.title = General.stringForKey(key: "home")
        if let bar  = tabBar.items {
          bar[0].title = General.stringForKey(key: "share")
          bar[1].title = General.stringForKey(key: "all")
          bar[2].title = General.stringForKey(key: "search")

       }
        lanBtn.setTitle(General.stringForKey(key: "arabic"), for: .normal)
        addBtn.setTitle(General.stringForKey(key: "add ad"), for: .normal)
        hoBtn.setTitle(General.stringForKey(key: "home"), for: .normal)
        loBtn.setTitle(General.stringForKey(key: "Login"), for: .normal)
        creaBtn.setTitle(General.stringForKey(key: "Create a new account"), for: .normal)
        minBtn.setTitle(General.stringForKey(key: "my account"), for: .normal)
        myadBtn.setTitle(General.stringForKey(key: "my ads"), for: .normal)
        msgbTn.setTitle(General.stringForKey(key: "messages"), for: .normal)
        pcBtn.setTitle(General.stringForKey(key: "pay commission"), for: .normal)
        csBtn.setTitle(General.stringForKey(key: "contact us"), for: .normal)
        abBtn.setTitle(General.stringForKey(key: "about"), for: .normal)
        terBtn.setTitle(General.stringForKey(key: "terms and condtions"), for: .normal)
        userNameLab.text = General.stringForKey(key: "visitor")
        
        
        //cateCollectionView.performBatchUpdates(nil, completion: nil)
        self.nxBtn.alpha = 0
        self.prevsBtn.alpha = 0
        
        menuCon.constant = -250
        self.menuView.layer.shadowOpacity = 1
        self.menuView.layer.shadowRadius = 6
        //self.menuView.layer.cornerRadius = 10.0
        
        slid()
        sub()
        branches(id:"1")
        userData()
        
        slider.corner()
        
        cateCollectionView.dataSource = self
        cateCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.delegate = self
        self.tabBar.delegate = self
        self.navigationController?.isNavigationBarHidden = true

             do {
               audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
              } catch {
                 print("faild to load sound")
                }

        
        slider.slideshowInterval = 5.0
        slider.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slider.contentScaleMode = UIView.ContentMode.scaleToFill
        
        slider.pageIndicator = LabelPageIndicator()
        slider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        slider.pageIndicator = pageControl
        
        slider.activityIndicator = DefaultActivityIndicator()
        slider.activityIndicator = DefaultActivityIndicator(style: .gray , color: nil )

        slider.currentPageChanged = { page in
            print("current page:", page)
            let da = self.slidData[page]
            self.offerTitleLab.text = da.imageTitle
            self.offerContentLabel.text = da.imageContent
        }
        
        slider.addSubview(pageControl)
        slider.addSubview(offerTitleLab)
        slider.addSubview(offerContentLabel)
        
        
        //self.currentPage = 0

    //cateCollectionView.selectItem(at: [1], animated: false, scrollPosition: .centeredHorizontally)
        

}
    
//    var currentPage: Int = 0 {
//        didSet {
//            let nam = self.categoryData[currentPage]
//           // self.cateName.text = nam.depName
//            print("page at centre = \(currentPage)")
//        }
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.cateCollectionView.collectionViewLayout as! UPCarouselFlowLayout
//        let de = cateCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: IndexPath(item: currentPage, section: 0))
//        let w = de.frame.size.width
//        let h = de.frame.size.width
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        //currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        //let cell = cateCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: IndexPath(row: currentPage, section: 0))
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.cateCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        audioPlayer.play()
        let visibleItems: NSArray = self.cateCollectionView.indexPathsForVisibleItems as NSArray
        
        
        
        
        
        
        
        
        let currentItem: IndexPath = visibleItems.object(at: 0 ) as! IndexPath
        let nextItem : IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < categoryData.count {
            self.cateCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
            self.selectedIndexPath  = nextItem
            cateCollectionView.performBatchUpdates(nil, completion: nil)
            }
    }
    
    
    @IBAction func prevBtn(_ sender: Any) {
        audioPlayer.play()
        let visibleItems: NSArray = self.cateCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0 ) as! IndexPath
        let nextItem : IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < categoryData.count && nextItem.row >= 0  {
            self.cateCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
            self.selectedIndexPath  = nextItem
            cateCollectionView.performBatchUpdates(nil, completion: nil)
            }
        
    }
    
    
    
    @IBAction func barMenu(_ sender: Any) {
        self.menuCon.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
   

    
    @IBAction func sideMenuBtns(_ sender: UIButton) {
        if sender.tag == 1 {
            if helper.getUserData() == true {
                API.logOut { (error: Error?, success: Bool?) in
                    if success! {
                  helper.deletUserDefaults()
                    } else {
                    self.AlertPopUP(title: "Connection weak!", message: "Please try again later")}
                }
            } else {
              self.AlertPopUP(title: "Error!", message: "you have to logIn ")
            }
        } else if sender.tag == 2 {
            
            if General.CurrentLanguage() == "ar"
            {
                CheckLanguage.ChangeLanguage(NewLang: "en")
            }else
            {
                CheckLanguage.ChangeLanguage(NewLang: "ar")
            }
            helper.restartApp()
        } else if sender.tag == 3 {
            if helper.getUserData() == false {
                self.AlertPopUP(title: "Sorry☹️", message: "you need to be a user to open that page")
            } else {
                performSegue(withIdentifier: "uploadSegue", sender: self)
            }
        } else if sender.tag == 4 {
            self.menuCon.constant = -250
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else if sender.tag == 5 {
            performSegue(withIdentifier: "d", sender: self)
            //for login
                 //let Sb: UIStoryboard = UIStoryboard(name: "main", bundle: nil)
                   // let vc =   Sb.instantiateViewController(withIdentifier: "Main") as! LogInVC
                    //self.navigationController?.pushViewController(vc, animated: true)
           // self.present(vc, animated: true, completion: nil)
        } else if sender.tag == 6 {
           //for register
            
            
            
            
            performSegue(withIdentifier: "toRegister", sender: self)
            
        } else if sender.tag == 7{
            if helper.getUserData() == false {
                //performSegue(withIdentifier: "profileSegue", sender: self)
                self.AlertPopUP(title: "Sorry☹️", message: "you need to be a user to open that page")
            } else {
                performSegue(withIdentifier: "profileSegue", sender: self)
            }
        } else if sender.tag == 8 {
            if helper.getUserData() == false {
                //performSegue(withIdentifier: "myAdsSegue", sender: self)
                self.AlertPopUP(title: "Sorry☹️", message: "you need to be a user to open that page")
            }
            else {
                performSegue(withIdentifier: "myAdsSegue", sender: self)
                self.menuCon.constant = -250
            }
        } else if sender.tag == 9 {
            if helper.getUserData() == false {
                //performSegue(withIdentifier: "msgsSegue", sender: self)
                self.AlertPopUP(title: "Sorry☹️", message: "you need to be a user to open that page")
            } else {
                performSegue(withIdentifier: "msgsSegue", sender: self)
                self.menuCon.constant = -250
            }
        } else if sender.tag == 10 {
            if helper.getUserData() == false {
                //performSegue(withIdentifier: "commisionSegue", sender: self)
                self.AlertPopUP(title: "Sorry☹️", message: "you need to be a user to open that page")
            } else {
                performSegue(withIdentifier: "commisionSegue", sender: self)
                self.menuCon.constant = -250
            }
        } else if sender.tag == 11 {
            if helper.getUserData() == false {
                performSegue(withIdentifier: "contactSegue", sender: self)
            } else {
                performSegue(withIdentifier: "contactSegue", sender: self)
            }
            self.menuCon.constant = -250
        } else if sender.tag == 12 {
            if helper.getUserData() == false {
                performSegue(withIdentifier: "aboutSegue", sender: self)
            } else {
                performSegue(withIdentifier: "aboutSegue", sender: self)
            }
            self.menuCon.constant = -250
        } else if sender.tag == 13 {
            // rules ???
          
            performSegue(withIdentifier: "toRules", sender: self)

        }
    }
    
    @IBAction func hideMenuBtn(_ sender: Any) {
        self.menuCon.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func slid() {
        API.slidShowCate { (error:Error? , data:[SlidShowData]?) in
            if data != nil {
                self.slidData = data!
                for data in data! {
                    self.imgSource.append(KingfisherSource(urlString: data.img)!)
                   }
                self.slider.setImageInputs(self.imgSource)
            } else {
               print("no data")
            }
        }
    }
    
    func sub() {
        API.categoryDep { (error: Error?, data: [CategoriesDep]?) in
            if data != nil {
            self.categoryData = data!
            self.cateCollectionView.reloadData()
            self.nxBtn.alpha = 1.0
            self.prevsBtn.alpha = 1.0
            SVProgressHUD.dismiss()
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
                                          print("name \(name!)")
                                        // create Ream Object
                                        self.branchData.append(subData(subName: name!, subImage: icon!, subId: id!))
                                        
                                       }
                                    self.subCollectionView.reloadData()
                                    }
                                
                                }
                            }}
                          }
                       }
                    }
    
    
    
    
    
    
    
    
    
    
//
//    func getSubAds() {
//        if helper.getUserData() == true {
//            API.nearSubAds(Sub: <#String#>, completion: { (error: Error?,data:[Ad]?) in
//                self.subAd = data!
//            })
//        } else {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            if CLLocationManager.locationServicesEnabled(){
//                locationManager.startUpdatingLocation()
//            }
//            API.nonUserSubAds(subName: <#String#>, long: longTuide, lati: latitude, completion: { (error: Error?,data:[Ad]?) in
//                self.subAd = data!
//               })
//              }
//            }
//
    
    
    
//    func updateToken() {
//        API.userTokenId(id: token) { (error:Error?, success: Bool) in
//            if success {
//                print("success update token")
//            } else {
//                print("error to upload userToken")
//            }
//        }
//    }
    
    
    func shareApp() {
        API.share { (error: Error?, success: Bool?) in
            if success! {
             print("success to share app")
            } else {
              print("error to share app")
            }
        }
    }
    
    func userData() {
        if helper.getUserData() == true  {
            userNameLab.text = (UserDefaults.standard.object(forKey: "user_name") as! String)
            let da = helper.getData()
            let urlString = URLs.image+da["user_photo"]!
            let url = URL(string: urlString)
            proImg.kf.indicatorType = .activity
            proImg.kf.setImage(with: url)
        } else {
            self.userNameLab.text = "Visitor"
            self.proImg.image = #imageLiteral(resourceName: "prof")
        }
    }
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cateCollectionView {
            return categoryData.count

        } else {
            
            return branchData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cateCollectionView {
            let cell = cateCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
             cell.pics = categoryData[indexPath.item]
            cell.title=categoryData[indexPath.row]
            
            
            
           // cell.categoryName.text = categoryData[indexPath.row].depName
           return cell
        } else {
            let cell = subCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! SubCell
            
           cell.subNm.text = branchData[indexPath.row].subName
            return cell
         }
    }
    
    
    
        
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if collectionView == cateCollectionView {
//            if indexPath == selectedIndexPath  {
//                return CGSize(width: 150 , height: 200)
//            } else {
//                return CGSize(width: 100, height: 150)
//            }
//        } else {
//        return CGSize(width:(subCollectionView.cellForItem(at: indexPath)?.frame.size.width)! , height:(subCollectionView.cellForItem(at: indexPath)?.frame.size.height)! )
//        }
//    }
    
    
    
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        cateCollectionView.performBatchUpdates(nil, completion: nil)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cateCollectionView {
            
            
            
            
            let id = categoryData[indexPath.row].depId
            mainNameSelect=id
            print("mainNameSelect \(mainNameSelect)")
            branches(id: id)
            
            
            
        }
      else  if collectionView == subCollectionView {
            
            
            print("select")
            //self.selectedSub =
//            helper.saveSubDepart(subName: "\(SelectedSub)")
            
            branchNameSelect =  mainNameSelect
            print("branchNameSelect \(branchNameSelect)")
            
            
            
            
            BRANCHNAME=branchData[indexPath.row].subName
            performSegue(withIdentifier: "AdSegue", sender: self)
           }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdSegue" {
            
            
            
            
             let homevC = segue.destination as? AdsVC
            print("branchNameSelect \(branchNameSelect)")
            homevC?.recSubTapped =  "selected"
            homevC?.branchName=BRANCHNAME//
            homevC?.mainName=mainNameSelect

        }
    }
    
    
    
}
extension HomeVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {
            print("1")
            audioPlayer.play()
            if helper.getUserData() == true {
            let activityVC = UIActivityViewController(activityItems: [shareApp()], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            } else {
                let activityVC = UIActivityViewController(activityItems: [URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            }
        } else if (item.tag == 2){
           audioPlayer.play()
            performSegue(withIdentifier: "AdSegue", sender: self)
        } else if (item.tag == 3) {
            audioPlayer.play()
            performSegue(withIdentifier: "SearchSegue", sender: self)
            
            }
    
       }

}


extension HomeVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
        self.longTuide = "\(userLocation.coordinate.longitude)"
        self.latitude = "\(userLocation.coordinate.latitude)"
        print(self.longTuide)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in Geocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                //print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}
extension UIView {
    func corner() {
       self.layer.cornerRadius = 10.0
       self.clipsToBounds = true
    }
}







