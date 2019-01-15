//
//  AdsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import SVProgressHUD
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON

//need to parse arrayobject of imgs and display it
// pagination
// display selected subName
// recTapped i found it always true


class AdsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionConstant: NSLayoutConstraint!
    @IBOutlet weak var upBtn: UIButton!
    
    @IBOutlet weak var neBtn: CornerButtons!
    @IBOutlet weak var frBtn: CornerButtons!
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    fileprivate let hieght : CGFloat =  115.0
    
    fileprivate var locationManager:CLLocationManager!
     var longTuide = ""
     var latitude = ""
    
    fileprivate var index = ""
    
    
    //var recTapped: Bool? = false
    
    var nearAd = [Ad]()
  //  var sub = [CategoriesDep]()
    var sub = [Ad]()
   
    
    
    // branches
    
    var branchData = [subData]()
    
    
    
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=10
    var offset:Int=0
    var didEndReached:Bool=false
    
    var selectedtitle = ""
    var selectedCity = ""
    var selectedDate = ""
    var selectedPrice = ""
    var selectedContent = ""
    var selectedPhone = ""
    var selectedShare = ""
    var selectedAdId = ""
    var selectedUserId = ""
    var selectedOwner = ""
    var selectedAdvId = ""
    var selectedShPhone = ""
    var selectedTyp = ""
    var selectedImages=[String]()
    var recSubTapped = ""
    var branchName=""
    var mainName=""
  
    override func viewDidAppear(_ animated: Bool) {
        getNearAds()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        branches(id:mainName)
        print("adVC")
        neBtn.setTitle(General.stringForKey(key: "near ads"), for: .normal)
        frBtn.setTitle(General.stringForKey(key: "fresh ads"), for: .normal)
        if let bar  = tabBar.items {
            bar[0].title = General.stringForKey(key: "share")
            bar[1].title = General.stringForKey(key: "home")
            bar[2].title = General.stringForKey(key: "search")
        }
        
        self.upBtn.alpha = 0
        
        if recSubTapped == "selected" {
          self.collectionView.alpha = 1

        } else {
            self.collectionView.alpha = 0
            self.collectionConstant.constant = 0
            view.layoutIfNeeded()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.tabBar.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }

  print("BRANCH NAME \(branchName)")
       getSubAds(BranchName: branchName)
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if helper.getUserData() == false {
          performSegue(withIdentifier: "adUnwind", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
           }
        }
    
    @IBAction func nearBtn(_ sender: Any) {
      
        audioPlayer.play()
        getNearAds()
        
    }
    
 
    
    
    @IBAction func freshBtn(_ sender: Any) {
        audioPlayer.play()
        getFreshAds()
        
    }
    
    
    @IBAction func upBtn(_ sender: Any) {
        
        audioPlayer.play()
        tableView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: 0.2) {
            self.upBtn.alpha = 0
        }
    }
    
    @IBAction func unwindToAds(segue: UIStoryboardSegue) {}
    
    func getNearAds()  {
        
        if helper.getUserData() == true {
        
            
            API.nearAds(completion: { (error: Error?, data:[Ad]?) in
               //SVProgressHUD.show()


                print("near Ads calling with ")
                if data != nil {
                    self.nearAd = data!
                    print("mine",data!)
                    self.tableView.reloadWithAnimation()
                    SVProgressHUD.dismiss()
                }
            })
        } else {
            API.nonUserNearAds(long: longTuide, lati: latitude
                , completion: {(error: Error?, data: [Ad]?) in
                    //SVProgressHUD.show()
                    
                    print(" non near Ads calling with ")
                    if data != nil {
                        self.nearAd = data!
                        print("myData",data!)
                        self.tableView.reloadWithAnimation()
                        SVProgressHUD.dismiss()
                    }
               })
             }
           }
    
    
        func getFreshAds() {
        
             if helper.getUserData() == true {
                API.freshAds(completion: {(error: Error? , data: [Ad]?) in
                    //SVProgressHUD.show()
                    if data != nil {
                        self.nearAd = data!
                        self.tableView.reloadWithAnimation()
                        SVProgressHUD.dismiss()
                    }
                    SVProgressHUD.dismiss()
                })
            } else {
               API.nonUserFreshAds(long: longTuide, lati: latitude, completion: { (error:Error?, data: [Ad]?) in
                //SVProgressHUD.show()
                if data != nil {
                    self.nearAd = data!
                    self.tableView.reloadWithAnimation()
                    SVProgressHUD.dismiss()
                   }
                })
              }
            }
    
    
    

/// sub cate
    func getSubAds(BranchName:String) {
        if helper.getUserData() == true {
            API.nearSubAds(Sub: BranchName, completion: { (error: Error?,data:[Ad]?) in
              //  self.sub = data!
                
     
                print("near sub ads")
                
                
                if data != nil {
                     self.nearAd=data!
                    self.tableView.reloadData()
                }
               // self.sub=data!
                //self.tableView.reloadData()
               // self.collectionView.reloadData()
                //print("data\(data!)")
            })
        } else {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
            API.nonUserSubAds(subName: BranchName, long: longTuide, lati: latitude, completion: { (error: Error?,data:[Ad]?) in
                
                if data != nil{
                 self.nearAd = data!
                 self.tableView.reloadData()
                }
            })
        }
    }
    





//get branches for collectionView

func branches(id:String) {
    
    //
    Alamofire.request(URLs.categoryDep)
        .responseJSON { response in
            switch response.result
            {
            case .failure( _): break
            case .success(let value):
                let json = JSON(value)
                print(json)
                print("callllll")
                print("daaaaaa \(id)")
                
                if let dataArr = json.array
                {
                    for dataArr in dataArr {
                        let mainId=dataArr["main_department_id"].string
                        print("main \(mainId!)")
                        
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
                                self.collectionView.reloadData()
                            }
                            
                        }
                    }}
            }
    }
}


}





extension AdsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
    
        return nearAd.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! AdCell

            cell.pics = nearAd[indexPath.item]
            cell.titleLab.text = nearAd[indexPath.row].adeTitle
            cell.cityLab.text = nearAd[indexPath.row].city
            cell.priceLab.text = nearAd[indexPath.row].adePrice
            cell.dateLab.text = nearAd[indexPath.row].date
           // cell.kindLabel.text = nearAd[indexPath.row].kind
            cell.distanceLab.text = nearAd[indexPath.row].distance
        
        let advType = nearAd[indexPath.row].typ
        if advType == "1"
        {
            cell.kindLabel.text = "New"
        }else if advType == "2"{
            cell.kindLabel.text = "used"
            cell.kindLabel.backgroundColor = UIColor.gray
        } else {
            cell.kindLabel.text = "none"
            cell.kindLabel.backgroundColor = UIColor.gray
        }
        
//        if nearAd[indexPath.row].typ == "2" {
//            cell.kindLabel.backgroundColor = UIColor.gray
//            cell.kindLabel.textColor = UIColor.black
//
//        } else if nearAd[indexPath.row].typ == "1" {
//
//        } else {
//            cell.kindLabel.backgroundColor = UIColor.gray
//            cell.kindLabel.textColor = UIColor.black
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hieght
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = "\(indexPath.row)"
        selectedContent = self.nearAd[indexPath.row].content
        selectedCity = self.nearAd[indexPath.row].city
        selectedDate = self.nearAd[indexPath.row].date
        selectedtitle = self.nearAd[indexPath.row].adeTitle
        selectedPrice = self.nearAd[indexPath.row].adePrice
        selectedPhone = self.nearAd[indexPath.row].phone
        selectedUserId = self.nearAd[indexPath.row].userId
        selectedShare = self.nearAd[indexPath.row].viewShare
        selectedOwner = self.nearAd[indexPath.row].userName
        selectedAdId = self.nearAd[indexPath.row].adId
        selectedAdvId = self.nearAd[indexPath.row].adverId
        selectedShPhone = self.nearAd[indexPath.row].showPhone
        selectedTyp = self.nearAd[indexPath.row].typ
        selectedImages=self.nearAd[indexPath.row].phots
        
        
        
        performSegue(withIdentifier: "ContentSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "ContentSegue" {
            let adContentVc = segue.destination as? AdContentVC
            adContentVc?.recCity = selectedCity
            adContentVc?.recContent = selectedContent
            adContentVc?.recPrice = selectedPrice
            adContentVc?.recTitle = selectedtitle
            adContentVc?.recDate = selectedDate
            adContentVc?.recNum = selectedPhone
            adContentVc?.recShare = selectedShare
            adContentVc?.recAdId = selectedAdId
            adContentVc?.recOwner = selectedOwner
            adContentVc?.recIdAdv = selectedAdvId
            adContentVc?.recShoPh = selectedShPhone
            adContentVc?.recUserId = selectedUserId
            
            adContentVc?.recImgs=selectedImages
            adContentVc?.recTyp = selectedTyp
            adContentVc?.recPage = "adsPage"
                }
             }
    
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.upBtn.alpha = 1
        isDataLoading = false

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                //loadCallLogData(offset: self.offset, limit: self.limit)
                
            }
        }

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == 0) {
            
            self.upBtn.alpha = 0
            
            
        }
    }

}
    
extension AdsVC: CLLocationManagerDelegate {
    
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


extension AdsVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 4) {
            print("1")
            audioPlayer.play()
            if helper.getUserData() == true {
            let activityVC = UIActivityViewController(activityItems: [URLs.appShare], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            } else {
                let activityVC = UIActivityViewController(activityItems: [URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            }
        } else if (item.tag == 5){
            audioPlayer.play()
            if helper.getUserData() == false {
                performSegue(withIdentifier: "adUnwind", sender: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else if (item.tag == 6) {
            audioPlayer.play()
            performSegue(withIdentifier: "SearchSe", sender: self)
            
        }
    }
    

    
}
extension AdsVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return branchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! AdCollectionCell
        
        cell.subLabel.text = branchData[indexPath.row].subName
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/3
        
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let selected  = [indexPath.row]
        
        
        
        let branchNamme=branchData[indexPath.row].subName
        
        
        print("branchreee Name  \(String(describing: branchNamme))")
        getSubAds(BranchName: branchNamme!)
        
        
        
        
        
        
        
        
    }
                   
    
}
extension AdsVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Connection Weak"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {

        return UIImage(named: "empg.png")
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Try again later to explore our awsome ads🛍"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }



}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut , animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
          }
        }


}
