//
//  FAVPlayer.swift
//  FAVplayer
//
//  Created by clement perez on 12/5/17.
//  Copyright © 2017 com.frequency. All rights reserved.
//
import Foundation
import AVKit

/**
 * This protocol defines the actions expected by the controller
 */
@objc public protocol AdDelegate {
    
    /*!
     @method onAdReady:
     @abstract          The onAdReady event is fired when the player got an ad and is ready to be played.
     @param             title : the ad title
     @param             duration: the ad duration
     @param             skipOffset: the ad afterWhich it can be skipped
     */
    func onAdReady(title: String, duration: Double, skipOffset: Double)
    
    /*!
     @method onAdSkippable:
     @abstract          onAdSkippable event is fired when the playback of the ad has reach the point after which the ad is skippable.
     @discussion        if the ad isn't skippable this callback will never be fired
     */
    func onAdSkippable()
    
    /*!
     @method onAdEnded:
     @abstract          onAdEnded event is fired when the playback as ended or it has been skipped.
     */
    func onAdEnded()
}

/**
 Exposed functions
 */
@objc protocol PlayerInterface : JSPlayerInterface {
    init(apiUrl: String, token: String, deviceId: String)
    init(apiUrl: String, token: String, deviceId: String, conviva: ConvivaConfig?, adsConfig: AdsConfig?)
}

public class FAVPlayer : AVQueuePlayer, JS2SwiftPlayerInterface, PlayerInterface{
    
    internal var timeObserverToken : Any?
    internal var playerItemContext : UnsafeMutablePointer<Any>?
    weak internal var playerServiceForDestroy : PlayerService?
    internal var jsDelegate : PlayerEventDelegate?
    internal var javascriptService : JSPlayerInterface?
    var adDelegate : AdDelegate?
    
    internal var itemIsAd = false // not sure if the player should care about it
    internal var isLocked = false
    
    override init(){
        playerItemContext = UnsafeMutablePointer.init(bitPattern: 32)
        super.init()
        self.actionAtItemEnd = AVPlayerActionAtItemEnd.pause
        self.addPlayerObservers()
        self.addPeriodicTimeObserver()
    }
    
    required public convenience init(apiUrl: String, token: String, deviceId: String){
        self.init(apiUrl: apiUrl, token: token, deviceId: deviceId, conviva: nil, adsConfig: nil)
    }
    
    required public init(apiUrl: String, token: String,deviceId: String, conviva: ConvivaConfig?, adsConfig: AdsConfig?){
        playerItemContext = UnsafeMutablePointer.init(bitPattern: 32)
        super.init()
        self.actionAtItemEnd = AVPlayerActionAtItemEnd.pause
        self.addPlayerObservers()
        self.addPeriodicTimeObserver()
        
        playerServiceForDestroy = PlayerService.init(
            baseUrl: apiUrl,
            authToken: token,
            deviceId: deviceId,
            convivaConfig: conviva,
            adsConfig: adsConfig,
            player: self)
        
        jsDelegate = playerServiceForDestroy
        javascriptService = playerServiceForDestroy
    }
    
    deinit {
        print("######################################## deinit FAVPLAYER ########################################")
    }
    
    func destroy(){
        
        removeObservers()
        timeObserverToken = nil
        playerItemContext = nil
        jsDelegate = nil
        playerServiceForDestroy?.destroy()
        javascriptService = nil
    }
    
    public func setSession(authToken: String, deviceId: String){
        javascriptService?.setSession(authToken: authToken, deviceId: deviceId)
    }
    
    private func addPlayerObservers(){
        
        self.addObserver(self, forKeyPath: "playbackBufferEmpty", options:NSKeyValueObservingOptions(), context: &playerItemContext)
        self.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options:NSKeyValueObservingOptions(), context: &playerItemContext)
        self.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions(), context: &playerItemContext)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAVPlayer.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.currentItem)
    }
    
    override public func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        
        super.addObserver(observer, forKeyPath: keyPath, options:options, context: context)
    }
    
    private func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken =
            self.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
                [weak self] time in
                let currentTimeMs = CMTimeGetSeconds(time)*1000
                
                let durationMs = CMTimeGetSeconds((self?.currentItem?.duration)!)*1000
                
                self?.jsDelegate?.onProgress(position: currentTimeMs, duration:durationMs)
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            self.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    private func removePlayerItemObserver(){
        self.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &playerItemContext)
    }
    
    private func removePlayerObservers(){
        self.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: &playerItemContext)
        self.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: &playerItemContext)
        self.removeObserver(self, forKeyPath: "loadedTimeRanges", context: &playerItemContext)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.currentItem)
    }
    
    private func removeObservers(){
        removePlayerObservers()
        removePlayerItemObserver()
        removePeriodicTimeObserver()
    }
    
    internal func load(mediaUrl: String) {
        itemIsAd = false // reset the state
        
        print("loadWith " + mediaUrl)
        let item = AVPlayerItem.init(url: URL.init(string: mediaUrl)!)
        
        item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &self.playerItemContext)
        
        self.replaceCurrentItem(with: item)
        
        self.playImmediately(atRate: 1.0)
    }
    
    override public func play() {
        super.play()
        jsDelegate?.onStateChange(playbackState: PlaybackState.playing)
    }
    
    override public func pause() {
        super.pause()
        jsDelegate?.onStateChange(playbackState: PlaybackState.paused)
    }
    
    override public func seek(to date: Date){
        if(!isLocked){
            super.seek(to: date)
        }
    }
    override public func seek(to date: Date, completionHandler: @escaping (Bool) -> Swift.Void){
        if(!isLocked){
            super.seek(to: date )
        }
    }
    
    override public func seek(to time: CMTime){
        if(!isLocked){
            super.seek(to : time)
        }
    }
    
    override public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime){
        if(!isLocked){
            super.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter:toleranceAfter)
        }
    }
    
    override public func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Swift.Void){
        if(!isLocked){
            super.seek(to: time, completionHandler: completionHandler)
        }
    }
    
    override public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Swift.Void){
        if(!isLocked){
            super.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler)
        }
    }
    
    internal func seekTo(progressInMs: Double) {
        print("seekTo = " + String(progressInMs))
        self.seek(to: CMTime.init(seconds: progressInMs/1000, preferredTimescale: 100))
    }
    
    internal func getCurrentTime() -> Double {
        let currentTimeInMs = CMTimeGetSeconds((self.currentTime()))*1000
        print("getCurrentTime currentTimeInMs = " + String(currentTimeInMs))
        return currentTimeInMs
    }
    
    internal func getDuration() -> Double {
        let durationInMs = CMTimeGetSeconds((self.currentItem?.duration)!)*1000
        print("getDuration durationInMs = " + String(durationInMs))
        return durationInMs
    }
    
    func getState() -> String {
        let avStatus = self.currentItem?.status
        var playbackStatus : String
        
        switch avStatus {
        case .readyToPlay?:
            playbackStatus = PlaybackState.unstarted.rawValue
        case .failed?:
            playbackStatus = PlaybackState.error.rawValue
        case .unknown?:
            playbackStatus = PlaybackState.unknown.rawValue
        case .none:
            playbackStatus = PlaybackState.unknown.rawValue
        }
        
        return playbackStatus
    }
    
    public func skipAd(){
        itemIsAd = false
        javascriptService?.skipAd()
    }
    
    internal func lock() {
        isLocked = true
    }
    
    internal func unlock() {
        isLocked = false
        adDelegate?.onAdSkippable()
    }
    
    internal func onAd(title: String, duration: String, offset: String){
        itemIsAd = true
        adDelegate?.onAdReady(title: title, duration: Double.init(duration)!, skipOffset: Double.init(duration)!)
    }
    
    override  public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                print("Player item is ready to play.")
                
                jsDelegate?.onMediaReady()
                jsDelegate?.onStateChange(playbackState: PlaybackState.unstarted)
                break
            case .failed:
                print("Player item failed. See error." + (self.currentItem?.error.debugDescription)!)
                
                jsDelegate?.onStateChange(playbackState: PlaybackState.error)
                jsDelegate?.onError(error: (self.currentItem?.error.debugDescription)!)
                break
            case .unknown:
                print("Player item is not yet ready.")
                
                jsDelegate?.onStateChange(playbackState: PlaybackState.error)
                break
            }
        }
        if keyPath == "playbackBufferEmpty" {
            
            jsDelegate?.onStateChange(playbackState: PlaybackState.buffering)
        }
        
        if keyPath == "playbackLikelyToKeepUp" {
            //   print("Change at keyPath = \(String(describing: keyPath))")
        }
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        print("Video Finished")
        if(itemIsAd){
            adDelegate?.onAdEnded()
        }
        itemIsAd = false
        jsDelegate?.onStateChange(playbackState: PlaybackState.ended)
    }
    
    public func addEventListener(eventName: String, callback: String) {
        //self.javascriptService?.addEventListener(eventName: eventName, callback: callback)
    }
    
    public func removeEventListener(eventName: String, callback: String) {
        //self.javascriptService?.removeEventListener(eventName: eventName, callback: callback)
    }
    
    public func load(videoId: String) {
        self.javascriptService?.load(videoId: videoId)
    }
    
    public func load(channelId: String) {
        self.javascriptService?.load(channelId: channelId)
    }
    
    public func setApiUrl(apiUrl: String) {
        self.javascriptService?.setApiUrl(apiUrl: apiUrl)
    }
    
    internal func add(eventListener: String, callback: String) {
        javascriptService?.addEventListener(eventName: eventListener, callback: callback)
    }
    
    internal func remove(eventListener: String, callback: String) {
        javascriptService?.removeEventListener(eventName: eventListener, callback: callback)
    }
}

