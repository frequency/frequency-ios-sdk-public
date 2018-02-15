//
//  PlayerInterface.swift
//  FAVplayer
//
//  Created by clement perez on 1/10/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation
import JavaScriptCore


/*!
 @potocol This interface exposes the Swift player functions to the Javascript SDK
 */
@objc internal protocol JS2SwiftPlayerInterface : JSExport{
    
    /*!
     @method load:
     @abstract          Loads a mediaUrl in the player
     @param             mediaUrl
     @discussion        Use this method to load a specified mediaUrl in the player
     The video playback will play automatically once the player item is loaded and ready to be played
     */
    func load(mediaUrl: String) // will be called loadWithMediaUrl in javascript
    
    /*!
     @method play:
     @abstract          Starts or resume the playback of the video
     */
    func play()
    
    /*!
     @method pause:
     @abstract          Pauses the playback of the video
     */
    func pause()
    
    /*!
     @method seekTo:
     @abstract          Changes to progress of the playback of the video to the specified time in millisecond
     @param             progressInMs
     */
    func seekTo(progressInMs: Double) // will be called seekToWithProgressInMs
    
    /*!
     @method getCurrentTime:
     @abstract          Get the current progress of the playback of the video in millisecond
     @param             progressInMs
     @return            The progress in millisecond
     */
    func getCurrentTime() -> Double
    
    /*!
     @method getDuration:
     @abstract          Get the duration of the video in millisecond
     @return            The duration in millisecond
     */
    func getDuration() -> Double // in ms
    
    /*!
     @method getState:
     @abstract          Get the current state of the playback
     @return            The string value of the PlaybackState
     */
    func getState() -> String
    
    /*!
     @method lock:
     @abstract          Prevents the player from being paused or seeked
     */
    func lock()
    
    /*!
     @method unlock:
     @abstract          Allows the player to be paused or seeked
     */
    func unlock()
    
    /*!
     @method adCanSkip:
     @abstract          Method called when the ad has reach the offset after wich it can be skipped
     
    func adCanSkip()
    */
    
    /*!
     @method add:
     @abstract          Allows to subscribe to a eventListner and specify a javascript function to be called back when the event is fired
     @param             eventListener
     @param             callback
     */
    func add(eventListener: String, callback : String) // will be called addWithEventListenerCallback
    
    /*!
     @method remove:
     @abstract          Allows to remove the subscribed eventListner
     @param             eventListener
     @param             callback
     */
    func remove(eventListener: String, callback : String)
    
    /*!
     @method onAd:
     @abstract          onAd event is fired when an ad related event occurs
     @discussion        See AdEvents for the possible values
     */
    func onAd(title: String, duration: String, offset: String)
}


/*!
 @potocol This interface is exposes methods of the PlayerService to the javascript code.
 */
@objc protocol JSCallbackInterface : JSExport{
    
    /*!
     @method onServiceReady:
     @abstract          Callback to inform the player that the service is loaded and initialized
     @discussion        No function to the service should be called before the service is ready.
     */
    func onServiceReady()
}
