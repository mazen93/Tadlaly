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
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var msgVi: UIVisualEffectView!
    
    
    @IBOutlet weak var slodCheck: UIButton!
    @IBOutlet weak var dontCheck: UIButton!
    
    @IBOutlet weak var deletLab: UILabel!
    @IBOutlet weak var soldLab: UILabel!
    @IBOutlet weak var dontLab: UILabel!
    @IBOutlet weak var dnBtn: UIButton!
    @IBOutlet weak var canclBtn: UIButton!
    
    
    
    
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
        
        self.bgView.alpha = 0
        self.msgVi.alpha = 0
        msgVi.layer.cornerRadius = 20.0
        msgVi.clipsToBounds = true
        seg.setTitle(General.stringForKey(key: "current"), forSegmentAt: 0)
        seg.setTitle(General.stringForKey(key: "last"), forSegmentAt: 1)
        
        
        deletLab.text = General.stringForKey(key: "delet")
        soldLab.text = General.stringForKey(key: "sold item")
        dontLab.text = General.stringForKey(key: "don't sell anymore")
        dnBtn.setTitle(General.stringForKey(key: "done"), for: .normal)
        canclBtn.setTitle(General.stringForKey(key: "cancel"), for: .normal)
        
        self.slodCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.slodCheck.setImage(UIImage(named:"che2"), for: .selected)
        self.dontCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.dontCheck.setImage(UIImage(named:"che2"), for: .selected)
        
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
        performSegue(withIdentifier: "myAdsUnwind", sender: self)
    }
    
    @IBAction func segBtn(_ sender: Any) {
        
        if seg.selectedSegmentIndex == 0 {
           self.current()
            
            } else {
           self.last()
        }
    }
    
    @IBAction func soldCheckBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.audioPlayer.play()
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.dele = "\(2)"
                self.audioPlayer.play()
            }, completion: nil)
        }
    }
    
    @IBAction func dontCheckBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.audioPlayer.play()
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.dele = "\(2)"
                self.audioPlayer.play()
            }, completion: nil)
        }
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        
        // delet ad here
        
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.bgView.alpha = 0.0
        self.msgVi.alpha = 0.0
    }
    
    
    @IBAction func unwindToMyAds(segue : UIStoryboardSegue ) {}
    
    func current() {
        API.myCurAds(completion: { (error: Error?, data:[MyAds]?) in
            if data != nil {
            self.myAds = data!
            self.tableView.reloadWithAnimation()
                print("myAds", data!)
            }
        })
    }


    func last() {

        API.myOldAds(completion: { (errpr: Error?, data: [MyAds]?) in
            if data != nil {
                self.myAds = data!
             self.tableView.reloadWithAnimation()
            }
        })

    }
    
    /// Mark:- delet imgs from here by sending id
    
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
    
    
    
   
    func updateTapped(_ sender: MyAdsCell) {
         //guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
          //let cel = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
           performSegue(withIdentifier: "UpdateMyAdSegue", sender: self)
    }
    
    func deletTapped(_ sender: MyAdsCell) {
        
    guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
       // let cell = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
        print(tappedIndexPath)
        
        
        self.bgView.alpha = 1.0
        self.msgVi.alpha = 1.0
         self.msgVi.transform = CGAffineTransform(scaleX: 0.3, y: 1)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options:.curveEaseOut, animations: {
            
            self.msgVi.transform = .identity
        }, completion: nil)
    }
    
    
    
    
    
    
}









