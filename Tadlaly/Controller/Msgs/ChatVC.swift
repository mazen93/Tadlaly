//
//  ChatVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import DZNEmptyDataSet

class ChatVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTF: UITextView!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var pupBtn: UIButton!
    @IBOutlet weak var viewHieght: NSLayoutConstraint!
    //@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    fileprivate var msgs = [Message]()
    
    var recToUser = ""
    var recName = ""
    var recNum = ""
    var recShPh = ""
    
    var ids = [String]()
    
    
    var textHeightConstraint: NSLayoutConstraint!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMsgs()

        msgTF.isScrollEnabled = false
        
        self.textHeightConstraint = msgTF.heightAnchor.constraint(equalToConstant: 44)
        self.textHeightConstraint.isActive = true
        self.adjustTextViewHeight()

        
        self.userNameLab.layer.cornerRadius = 10.0
        self.pupBtn.layer.cornerRadius = 10.0
        self.pupBtn.clipsToBounds = true
        self.userNameLab.clipsToBounds = true
        self.msgTF.layer.cornerRadius = 10.0
        
        
        self.userNameLab.text = recName
        self.msgTF.resignFirstResponder()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = .none
        msgTF.delegate = self
       // self.tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.reloadWithAnimation()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        textViewDidChange(msgTF)
        self.msgTF.delegate = self
    
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func callUserBtn(_ sender: Any) {
        if recShPh == "1" {
            if let url = URL(string: "tel://\(recNum)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else {
            SVProgressHUD.show(UIImage(named: "er.png")!, status: "No Number found")
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.0)
        }
    }
    
    
    
    @IBAction func SendBtn(_ sender: Any) {
        
        audioPlayer.play()
        guard let txt = msgTF.text, !txt.isEmpty else
        {
            SVProgressHUD.show(UIImage(named: "emp.png")!, status: "message empty")
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.0)
         return
        }
        
           self.send(id: recToUser, conv: txt)
        
    }
    
    
    
    @IBAction func deletChat(_ sender: Any) {
            deletBetWeen()
      //  audioPlayer.play()
        AlertPopUP(title: "Delet Chat🗑❓", message: "You are about to delet your chat")
    }
    
    func send(id: String, conv: String) {
        
        API.sendMsg(toUserId: id , message: conv) { (error: Error?, success: Bool) in
            if success {
                self.getMsgs()
                self.tableView.reloadWithAnimation()
            } else {
                SVProgressHUD.show(UIImage(named: "noWifi.png")!, status: "Connection Weak!")
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
    }
    
    func getMsgs() {
        
        
        print("in chat get msg")
        if helper.getUserData() == true {
            API.getChat(toUserId: recToUser) { (error: Error?, data:[Message]?) in
                if data != nil {
                    //DispatchQueue.main.async {
                      self.msgs = data!
                      self.tableView.reloadWithAnimation()
                      print(data!)
                    //}
                } else{
                    SVProgressHUD.show(UIImage(named: "empInbx.png")!, status: "No chat found")
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.dismiss(withDelay: 2.0)
                  }
                }
            } else{
               }
             }
    
    func deletBetWeen()  {
        API.deletBetweenMsgs(toUserId: recToUser) { (error: Error?, success: Bool) in
            if success {
            self.msgs.removeAll()
            self.tableView.reloadWithAnimation()
            } else {
                SVProgressHUD.show(UIImage(named: "er.png")!, status: "Connection Weak!.try again later")
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
    }
    
    
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.deletBetWeen()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func adjustTextViewHeight() {
        let fixedWidth = msgTF.frame.size.width
        let newSize = msgTF.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 100 {
            msgTF.isScrollEnabled = true
        }
        else {
            msgTF.isScrollEnabled = false
            textHeightConstraint.constant = newSize.height
            viewHieght.constant = newSize.height
            }
        self.view.layoutIfNeeded()
        }
   
}
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.userName.text = msgs[indexPath.row].fromName
        cell.msgContent.text = msgs[indexPath.row].MsgContent
        cell.time.text = msgs[indexPath.row].msgTime
        
        tableView.beginUpdates()
        //tableView.endUpdates()
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indx = msgs[indexPath.row].messageId
            //let inx = tableView.indexPathForSelectedRow
            self.ids.append(indx)
            API.deletAllMsgs(idsMsgs: indx, completion: { (error:Error?, success:Bool?) in
                if success! {
                    self.msgs.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                     self.tableView.reloadWithAnimation()
                } else {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "Connection Weak!.try again later")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
   
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
       
    }
    
    
}
extension ChatVC: UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.msgTF.resignFirstResponder()
        self.view.layoutIfNeeded()
        print("threee done")
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }

}
extension ChatVC: DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emp.png")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Inbox Empty"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "connect with seller and make awsome deal"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}



