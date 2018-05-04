//
//  ViewController.swift
//  FAVplayer
//
//  Created by clement perez on 12/5/17.
//  Copyright © 2017 com.frequency. All rights reserved.
//

import UIKit
import AVKit

class MainViewController: UIViewController, AdDelegate{
    
    var playerVC : AVPlayerViewController?
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var destroyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = DemoConstants.videoIdsQA[Int(arc4random_uniform(UInt32(DemoConstants.videoIdsQA.count)))]
        initPlayer()
        (playerVC?.player as! FAVPlayer).load(videoId: id)
        
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
        let adsConfig = AdsConfig.init(environment: AdsConfig.Environment.QA)
        
        playerVC = AVPlayerViewController()
        playerVC?.player = FAVPlayer.init(apiUrl: "https://qa-lgi-api.frequency.com",
                                          token: "e9045653-68c6-4ad1-a04d-76fdae7c8d6b",
                                          deviceId: "58955ef1-8e5f-626d",
                                          conviva: nil,
                                          adsConfig: adsConfig
        )
        
        playerVC?.view.frame = playerView.frame
        
        self.view.addSubview(playerVC!.view)
        destroyButton.isEnabled = true
    }
    
    func destroyPlayer(){
        
        if(playerVC != nil){
            (playerVC?.player as! FAVPlayer).destroy()
            playerVC?.view.removeFromSuperview()
            playerVC?.player = nil
            playerVC = nil
        }
        destroyButton.isEnabled = false
    }
    
    @IBAction func f1(_ sender: AnyObject) {
    
    }
    
    @IBAction func f2(_ sender: AnyObject) {
        
    }
    
    @IBAction func f3(_ sender: AnyObject) {
        
    }
    
    @IBAction func f4(_ sender: AnyObject) {
        destroyPlayer()
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        let id = DemoConstants.videoIdsQA[Int(arc4random_uniform(UInt32(DemoConstants.videoIdsQA.count)))]
        
        if(playerVC == nil){
            initPlayer()
        }
        (playerVC?.player as! FAVPlayer).load(videoId: id)
    }
    
    @IBAction func playChannel(_ sender: AnyObject) {
        let id = DemoConstants.channelIds[Int(arc4random_uniform(UInt32(DemoConstants.channelIds.count)))]
        
        if(playerVC == nil){
            initPlayer()
        }
        
        (playerVC?.player as! FAVPlayer).load(channelId: id)
    }
    
    @IBAction func skipAd(_ sender: AnyObject) {
        (playerVC?.player as! FAVPlayer).skipAd()
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        print("Video Finished")
    }
    
    func onAdReady(title: String, duration: Double, skipOffset: Double) {
        print("Playing ad : " + title + " duration : " + String.init(duration) + " skippable after : " + String.init(skipOffset))
        skipButton.isEnabled = false
    }
    
    func onAdSkippable() {
        skipButton.isEnabled = true
    }
    
    func onAdEnded() {
        skipButton.isEnabled = false
    }
}

