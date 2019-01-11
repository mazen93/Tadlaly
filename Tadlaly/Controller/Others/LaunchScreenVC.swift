//
//  LaunchScreenVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation



class LaunchScreenVC: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadVideo()

    }
  

    
    
    
    
    
    
    
    
    private func loadVideo() {
        var player: AVPlayer?
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
//        } catch { }
        let path = Bundle.main.path(forResource: "Video", ofType:"MOV")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player?.seek(to: CMTime.zero)
        player?.play()
    }

}







