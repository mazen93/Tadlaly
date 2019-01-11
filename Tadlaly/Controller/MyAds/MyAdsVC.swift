//
//  MyAdsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

// need to parse imgs [[String:Any]]
// select multi cell
//show & hide visual inside cell at protocol
// check selection for buttons inside cell

class MyAdsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var msgLabel: UILabel!
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    var myAds = [MyAds]()
    fileprivate var selectedCell = ""
    
    fileprivate var dele = "\(1)"
    fileprivate var ids = [String]()
    fileprivate var rowHieght: CGFloat = 153.0
    
    var selectedtitle = ""
    var selectedCity = ""
    var selectedDate = ""
    var selectedPrice = ""
    var selectedContent = ""
    var selectedPhone = ""
    var selectedShare = ""
    var selectedAdId = ""
    var selectedUserId = ""
    var selectedDis = ""
    var selectedTyp = ""
    var selectedImgs = [UIImage]()
    var selectedCode = ""
    var selectedIndex = ""
    var indxPath: IndexPath = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        seg.setTitle(General.stringForKey(key: "current"), forSegmentAt: 0)
        seg.setTitle(General.stringForKey(key: "last"), forSegmentAt: 1)
        
        
        self.msgLabel.alpha = 0
        tableView.dataSource = self
        tableView.delegate = self
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        current()
        
    }

   
    @IBAction func unwindBtn(_ sender: Any) {
        if helper.getUserData() == false {
        performSegue(withIdentifier: "myAdsUnwind", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func segBtn(_ sender: Any) {
        
        if seg.selectedSegmentIndex == 0 {
           self.current()
            
            } else {
           self.last()
        }
    }
    
    
    
    @IBAction func unwindToMyAds(segue : UIStoryboardSegue ) {}
    
    func current() {
        API.myCurAds(completion: { (error: Error?, data:[MyAds]?) in
            if data != nil {
            self.myAds = data!
            self.tableView.reloadWithAnimation()
                print("myAds", data!)
            }
            self.msgLabel.alpha = 1
        })
    }


    func last() {

        API.myOldAds(completion: { (errpr: Error?, data: [MyAds]?) in
            if data != nil {
                self.myAds = data!
             self.tableView.reloadWithAnimation()
            }
            self.msgLabel.alpha = 1
        })

    }
    
    
//    func deletAd(reas: String,id: Array<Any>) {
//
//        API.deletAd(reason: reas, idsAdvertisement: id) { (error: Error?, success: Bool) in
//            if success {
//                //self.myAds.remove(at: indxPath)
//                //self.tableView.deleteRows(at: [self.indxPath], with: .automatic)
//              } else {
//                print("didnt delet")
//            }
//        }
//    }
    
    
    
    
    

}
extension MyAdsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAds.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdCell", for: indexPath) as! MyAdsCell
        
           // cell.pics = myAds[indexPath.item]
          cell.title.text = myAds[indexPath.row].Advtitle
          cell.date.text = myAds[indexPath.row].advertisement_date
          cell.city.text = myAds[indexPath.row].city
          cell.price.text = myAds[indexPath.row].advertisement_price
          
        let advType = myAds[indexPath.row].advertisement_type
        if advType == "1"
        {
            cell.kind.text = "New"
        }else if advType == "2"{
            cell.kind.text = "used"
            cell.kind.backgroundColor = UIColor.gray
        } else {
            cell.kind.text = "none"
            cell.kind.backgroundColor = UIColor.gray
        }
        
        
            cell.delegate = self
            cell.tag = indexPath.row
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHieght
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let  selected = myAds[indexPath.row]
        
        self.selectedCell = "\(selected)"
        //waiting for imgs
        selectedCity = myAds[indexPath.row].city
        selectedPhone = myAds[indexPath.row].phone
        selectedtitle = myAds[indexPath.row].Advtitle
        selectedContent = myAds[indexPath.row].content
        selectedPrice = myAds[indexPath.row].advertisement_price
        selectedCode = myAds[indexPath.row].advertisement_code
        selectedTyp = myAds[indexPath.row].advertisement_type
        selectedAdId = myAds[indexPath.row].adId
        selectedShare = myAds[indexPath.row].share
        
        performSegue(withIdentifier: "MyAdContentSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyAdContentSegue" {
            let con = segue.destination as? AdContentVC
            con?.recPrice = selectedPrice
            con?.recNum = selectedPhone
            con?.recContent = selectedContent
            con?.recCity = selectedCity
            con?.recTitle = selectedtitle
            con?.recAdId = selectedAdId
            con?.recCode = selectedCode
            con?.recShare = selectedShare
            con?.recTyp = selectedTyp
            con?.recPage = "myAdsPage"
               
        } else if segue.identifier == "UpdateMyAdSegue" {
            let updateAd = segue.destination as? UpdateMyAdVC
            
            updateAd?.recCity = selectedCity
            updateAd?.recPrice = selectedPrice
            updateAd?.recTitle = selectedtitle
            updateAd?.recContent = selectedContent
            
        }
    }
    
   
    
    
    
    
}

extension MyAdsVC: myAdDelegate {
    
    func soldTapped(_ sender: MyAdsCell) {
        
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("soldCheck", sender, tappedIndexPath)
        let cell = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
        let s = cell.soldCheck!
          UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            s.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.audioPlayer.play()
            }) { (success) in
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                    s.isSelected = !sender.isSelected
                    s.transform = .identity
                    self.dele = "\(2)"
                    self.audioPlayer.play()
                    }, completion: nil)
                }
    }
    
    func dontSellTapped(_ sender: MyAdsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
         print("dontsoldCheck", sender, tappedIndexPath)
        //let s = myAds[tappedIndexPath.row].id_advertisement
        let ce = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
        let bu = ce.dontSellCheck!
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                    bu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.audioPlayer.play()
                }) { (success) in
                    UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                        bu.isSelected = !sender.isSelected
                        bu.transform = .identity
                        self.dele = "\(2)"
                        self.audioPlayer.play()
                    }, completion: nil)
                }
        
    }
    
    func updateTapped(_ sender: MyAdsCell) {
         //guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
          //let cel = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
           performSegue(withIdentifier: "UpdateMyAdSegue", sender: self)
    }
    
    func deletTapped(_ sender: MyAdsCell) {
        
        // show visual here
    guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let cell = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
        print(tappedIndexPath)
//        let hi = cell.delet!
//        hi.alpha = 1.0
        cell.visual.alpha = 1.0
        
    
    }
    
    func doneTapped(_ sender: MyAdsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let indx = myAds[tappedIndexPath.row].id_advertisement
        self.ids.append(indx)
        //self.selectedIndex = "\(tappedIndexPath)"
        API.deletAd(reason: dele, idsAdvertisement: ids) { (error: Error?, success: Bool) in
            if success {
                //self.myAds.remove(at: self.indxPath.row)
                self.myAds.remove(at: tappedIndexPath.row)
                self.tableView.deleteRows(at: [tappedIndexPath], with: .automatic)
            } else {
                SVProgressHUD.show(UIImage(named: "er.png")!, status: "Connection Weak.try again later")
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
    }
    
    func cancelTapped(_ sender: MyAdsCell) {
    //hide visual here
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print(tappedIndexPath)
        let cell = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
//        let sh = cell.visual!
//           sh.alpha = 0
        //cell.visual.alpha = 0
        cell.visual.alpha = 0.0
    }
    
    
}









