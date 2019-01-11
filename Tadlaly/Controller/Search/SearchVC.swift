//
//  SearchVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import DZNEmptyDataSet
import SVProgressHUD

//need to display arrayobject of imgs
// show box of suggestion words
class SearchVC: UIViewController {

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upButn: UIButton!
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    
    fileprivate var receiveData = [Ad]()
    fileprivate var searchTx = ""
    
    
    var selecttitle = ""
    var selectCity = ""
    var selectDate = ""
    var selectPrice = ""
    var selectContent = ""
    var selectPhone = ""
    var selectShare = ""
    var selectAdId = ""
    var selectUserId = ""
    var selectOwner = ""
    var selectAdvId = ""
    var selectShoNum = ""
    var selectTyp = ""
    
    fileprivate let height : CGFloat = 115.0
    
    var filteredData: [String]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxt.placeholder = General.stringForKey(key: "search")
        self.upButn.alpha = 0
        self.searchTxt.frame.size.width = 290.0
        self.searchTxt.autocorrectionType = .no
        self.searchTxt.spellCheckingType = .no
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.searchTxt.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        

         tableView.emptyDataSetDelegate = self
         tableView.emptyDataSetSource = self
  }
    
    


    
    
    @IBAction func bkBtn(_ sender: Any) {
        if helper.getUserData() == false {
        performSegue(withIdentifier: "searchUnwind", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func moveUpBtn(_ sender: Any) {
        
        audioPlayer.play()
        self.upButn.alpha = 0
        tableView.setContentOffset(.zero, animated: true)
        
        
    }
    
    
    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {}
    
    func searchStart(txt: String, lo: String, la: String) {
        if helper.getUserData() == true {
            API.searchByTitle(searchTitle: txt, long: lo, lati: la, userId: "\(helper.getApiToken())" , completion: { (error: Error?, data: [Ad]?) in
                if (data != nil) {
                self.receiveData = data!
                self.tableView.reloadWithAnimation()
                } else {
                    SVProgressHUD.show(UIImage(named: "empg.png")!, status: "no data found")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("no data found")
                }
            })
        } else {
            API.searchByTitle(searchTitle: txt, long: lo, lati: la, userId: "all", completion: { (error: Error?, data: [Ad]?) in
                if (data != nil) {
                self.receiveData = data!
                self.tableView.reloadWithAnimation()
                } else {
                    SVProgressHUD.show(UIImage(named: "empg.png")!, status: "no data found")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("no data found")

                }
            })
        }
    }
    
    
    

    
    
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receiveData.count
        
             }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! searchCell
        
        //cell.pics = receiveData[indexPath.item]
    
        cell.titleCell.text = receiveData[indexPath.row].adeTitle
        cell.cityCell.text = receiveData[indexPath.row].city
        cell.dateCell.text = receiveData[indexPath.row].date
        cell.distanceCell.text = receiveData[indexPath.row].distance
        //cell.kindCell.text = receiveData[indexPath.row].kind
        cell.priceCell.text = receiveData[indexPath.row].adePrice

        return cell
        
          }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectContent = self.receiveData[indexPath.row].content
        selectCity = self.receiveData[indexPath.row].city
        selectDate = self.receiveData[indexPath.row].date
        selecttitle = self.receiveData[indexPath.row].adeTitle
        selectPrice = self.receiveData[indexPath.row].adePrice
        selectPhone = self.receiveData[indexPath.row].phone
        selectUserId = self.receiveData[indexPath.row].userId
        selectShare = self.receiveData[indexPath.row].viewShare
        selectOwner = self.receiveData[indexPath.row].userName
        selectAdId = self.receiveData[indexPath.row].adId
        selectShoNum = self.receiveData[indexPath.row].showPhone
        selectTyp = self.receiveData[indexPath.row].typ
        performSegue(withIdentifier: "SearchContent", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "SearchContent" {
            let adContentVc = segue.destination as? AdContentVC
            adContentVc?.recContent = selectContent
            adContentVc?.recAdId = selectAdId
            adContentVc?.recShare = selectShare
            adContentVc?.recNum = selectPhone
            adContentVc?.recDate = selectDate
            adContentVc?.recPrice = selectPrice
            adContentVc?.recUserId = selectUserId
            adContentVc?.recCity = selectCity
            adContentVc?.recTitle = selecttitle
            adContentVc?.recOwner = selectOwner
            adContentVc?.recIdAdv = selectAdvId
            adContentVc?.recShoPh = selectShoNum
            adContentVc?.recTyp = selectTyp
            adContentVc?.recPage = "searchPage"
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.upButn.alpha = 1
    }
    
    
    
    
    
    
}
extension SearchVC: CLLocationManagerDelegate {
    
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



extension SearchVC: UITextFieldDelegate {


    func textFieldDidEndEditing(_ textField: UITextField) {
        audioPlayer.play()
        self.searchTx = self.searchTxt.text!
        print(searchTx)
        helper.saveInputs(input: searchTx)
        searchStart(txt: searchTx, lo: longTuide, la: latitude)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        audioPlayer.play()
        self.searchTx = self.searchTxt.text!
        print("good,\(searchTx)")
        //helper.saveInputs(input: searchTx)
        self.searchTxt.resignFirstResponder()
        searchStart(txt: searchTx, lo: longTuide, la: latitude)
        
        return true
    }
    
        
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("two",self.searchTxt.text!)
        //self.searchTxt.text! =  UserDefaults.standard.object(forKey: "inputsArray") as! String
      
        
        return true
    }

    
    
    
    
}


extension SearchVC: DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Looking for Something🤔"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "sear.png")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "explore what you need here between awesome items🛒"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
}




















