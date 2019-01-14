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


class HomeVC: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    @IBOutlet weak var cateCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    var categoryData = [CategoriesDep]()
    var branchData = [subData]()
    
    var branchNameSelect = ""
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var slider: ImageSlideshow!
    @IBOutlet weak var offerTitleLab: UILabel!
    @IBOutlet weak var offerContentLabel: UILabel!
 
   
    @IBOutlet weak var nxBtn: UIButton!
    @IBOutlet weak var prevsBtn: UIButton!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
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
  
        configSWrevealBtn()
        
        LogInVC.shared.hudStart()
        self.title = General.stringForKey(key: "home")
        if let bar  = tabBar.items {
          bar[0].title = General.stringForKey(key: "share")
          bar[1].title = General.stringForKey(key: "all")
          bar[2].title = General.stringForKey(key: "search")
        }
        
        
        self.nxBtn.alpha = 0
        self.prevsBtn.alpha = 0
        
       
        
        slid()
        sub()
        branches(id:"1")
        
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
    
    
    
    
    
    func configSWrevealBtn () {
        if revealViewController() != nil {
            self.revealViewController()?.delegate = self
            if self.revealViewController() != nil {
                menuBtn.target = self.revealViewController()
                menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

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







