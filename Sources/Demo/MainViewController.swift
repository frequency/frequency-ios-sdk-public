//
//  ViewController.swift
//  FAVplayer
//
//  Created by clement perez on 12/5/17.
//  Copyright © 2017 com.frequency. All rights reserved.
//

import UIKit
import AVKit

class MainViewController: UIViewController {
    
    var playerVC : AVPlayerViewController?
    
    @IBOutlet weak var playerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer(videoId: PlayerConstants.videoIds[Int(arc4random_uniform(UInt32(PlayerConstants.videoIds.count)))])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAVPlayer.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPlayer(){
        
        playerVC = AVPlayerViewController()
        
        playerVC?.player = FAVPlayer.init(
            apiUrl: "https://prd-freq.frequency.com",
            token: "d3f20479-1d63-4d5d-a634-a02bee408473",
            deviceId: "5828aad7-d813-d339")
        
        playerVC?.view.frame = playerView.frame
        
        self.view.addSubview(playerVC!.view)
    }
    
    func initPlayer(videoId: String){
        initPlayer()
        
        (playerVC?.player as! FAVPlayer).load(videoId: videoId)
    }
    
    func initPlayer(channelId: String){
        initPlayer()
        
        (playerVC?.player as! FAVPlayer).load(channelId: channelId)
    }
    
    func initPlayerNative(url: String){
        playerVC = AVPlayerViewController()
        
        playerVC?.player = AVPlayer.init(url: URL.init(string: url)!)
        
        playerVC?.player?.playImmediately(atRate: 1)
        
        playerVC?.view.frame = playerView.frame
    }
    
    func destroyPlayer(){
        
        (playerVC?.player as! FAVPlayer).destroy()
        playerVC?.view.removeFromSuperview()
        playerVC?.player = nil
        playerVC = nil
    }
    
    @IBAction func f1(_ sender: AnyObject) {
        initPlayerNative(url: PlayerConstants.videoUrls[Int(arc4random_uniform(UInt32(PlayerConstants.videoUrls.count)))])
    }
    
    @IBAction func f2(_ sender: AnyObject) {
        
        initPlayer(videoId: PlayerConstants.videoIds[Int(arc4random_uniform(UInt32(PlayerConstants.videoIds.count)))])
    }
    
    @IBAction func f3(_ sender: AnyObject) {
        
    }
    
    @IBAction func f4(_ sender: AnyObject) {
        
        destroyPlayer()
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        let id = PlayerConstants.videoIds[Int(arc4random_uniform(UInt32(PlayerConstants.videoIds.count)))]
        
        if(playerVC == nil){
            initPlayer(videoId : id)
        }else{
            (playerVC?.player as! FAVPlayer).load(videoId: id)
        }
    }
    
    @IBAction func playChannel(_ sender: AnyObject) {
        let id = PlayerConstants.channelIds[Int(arc4random_uniform(UInt32(PlayerConstants.channelIds.count)))]
        
        if(playerVC == nil){
            initPlayer(channelId : id)
        }else{
            (playerVC?.player as! FAVPlayer).load(channelId: id)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        print("Video Finished")
    }
}

