//
//  SliderTableViewController.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 1/14/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit

class SliderTableViewController: UITableViewController {

    
    @IBOutlet weak var lngBtn: CornerButtons!
    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var addAdLab: UILabel!
    @IBOutlet weak var loginLab: UILabel!
    @IBOutlet weak var regsLab: UILabel!
    @IBOutlet weak var proLab: UILabel!
    @IBOutlet weak var myAdsLab: UILabel!
    @IBOutlet weak var msgsLab: UILabel!
    @IBOutlet weak var payLab: UILabel!
    @IBOutlet weak var contctLab: UILabel!
    @IBOutlet weak var aboutLab: UILabel!
    @IBOutlet weak var termsLab: UILabel!
    @IBOutlet weak var logOutLab: CornerButtons!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        userData()
        
        lngBtn.setTitle(General.stringForKey(key: "arabic"), for: .normal)
        userNameLab.text = General.stringForKey(key: "visitor")
        addAdLab.text = General.stringForKey(key: "add ad")
        loginLab.text = General.stringForKey(key: "Login")
        regsLab.text = General.stringForKey(key: "Create a new account")
        proLab.text = General.stringForKey(key: "my account")
        myAdsLab.text = General.stringForKey(key: "my ads")
        msgsLab.text = General.stringForKey(key: "messages")
        payLab.text = General.stringForKey(key: "pay commission")
        contctLab.text = General.stringForKey(key: "contact us")
        aboutLab.text = General.stringForKey(key: "about")
        termsLab.text = General.stringForKey(key: "terms and condtions")
        logOutLab.setTitle(General.stringForKey(key: "logout"), for: .normal)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
//    if helper.getUserData() == true {
//    API.logOut { (error: Error?, success: Bool?) in
//    if success! {
//    helper.deletUserDefaults()
//    } else {
//
//    self.AlertPopUP(title: "Connection weak!", message: "Please try again later")}
//    }
//    }
    
//    print("language Pressed")
//
//    if General.CurrentLanguage() == "ar"
//    {
//    CheckLanguage.ChangeLanguage(NewLang: "en")
//    }else
//    {
//    CheckLanguage.ChangeLanguage(NewLang: "ar")
//    }
//    helper.restartApp()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termsSegue" {
            let lo =  segue.destination as? RulesVC
            lo?.recMenu = "menu"
        } else if segue.identifier == "registerSegue" {
            let d = segue.destination as? RegisterVC
            d?.recNav = "menu"
        }
        
    }
    
    
    func userData() {
        if helper.getUserData() == true  {
            //userNameLab.text = (UserDefaults.standard.object(forKey: "user_name") as! String)
            let da = helper.getData()
            let urlString = URLs.image+da["user_photo"]!
            let url = URL(string: urlString)
            profileImg.kf.indicatorType = .activity
            profileImg.kf.setImage(with: url)
        } else {
            self.userNameLab.text = "Visitor"
            self.profileImg.image = #imageLiteral(resourceName: "prof")
        }
    }
    
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat
        if indexPath.row == 0 {
            height = 115
        } else {
            height = 44
        }
        if helper.getUserData() == true {
            if indexPath.row == 2 {
                height = 0
            }
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "uploadSegue", sender: self)
        } //else if indexPath.row == 2 {
            // performSegue(withIdentifier: "logSegue", sender: self)
            //}
        else if indexPath.row == 3 {
            performSegue(withIdentifier: "registerSegue", sender: self)
        }else if indexPath.row == 4 {
            performSegue(withIdentifier: "profileSegue", sender: self)
        }else if indexPath.row == 5 {
            performSegue(withIdentifier: "myAdsSegue", sender: self)
        } else if indexPath.row == 6 {
            performSegue(withIdentifier: "msgsSegue", sender: self)
        } else if indexPath.row == 7 {
            performSegue(withIdentifier: "paySegue", sender: self)
        } else if indexPath.row == 8 {
            performSegue(withIdentifier: "contactSegue", sender: self)
        } else if indexPath.row == 9 {
            performSegue(withIdentifier: "aboutSegue", sender: self)
        } else if indexPath.row == 10 {
            performSegue(withIdentifier: "termsSegue", sender: self)
        }
    }
    
    
    // override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    //}
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
}
