//
//  PlayerEventDelegate.swift
//  FAVplayer
//
//  Created by clement perez on 1/23/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation

/**
 * This protocol defines the actions expected by the controller
 */
protocol PlayerEventDelegate {
    
    /*!
     @method onReady:
     @abstract          The onReady event is fired when the player is initialized and loaded.
     @discussion        All actions sent to the player before onReady are not guaranteed to be taken into account
     */
    func onReady()
    
    /*!
     @method onMediaReady:
     @abstract          The onMediaReady event is fired when the player item is ready to be played.
     */
    func onMediaReady()
    
    /*!
     @method onStateChange:
     @abstract          onStateChange event is fired when the playback state of the player item changes
     @discussion        See PlaybackState for the possible values
     */
    func onStateChange(playbackState: PlaybackState)
    
    /*!
     @method onProgress:
     @abstract          event is fired when the playback state of the player changes
     @discussion        called every 500ms
     */
    func onProgress(position: Double, duration: Double)
    
    /*!
     @method onError:
     @abstract          event is fired when the playback or the Player as encountered an error
     @param             the error description
     */
    func onError(error : String)
    
    /*!
     @method onUserAction:
     @abstract          event is fired when the user interacts with the player
     @param             the action label
     @discussion
     */
    func onUserAction(action : String)
}

/*!
 @enum The enum of all the playback states of a player item
 
 @abstract These constants are returned by the FAVPlayer to indicate the status of the player item's playback
 
 @constant unknown
 Indicates that the player item state is unknown
 @constant unstarted
 Indicates that the player item is loaded and ready to be played
 @constant playing
 Indicates that the player item is currently playing
 @constant paused
 Indicates that the player item is currently paused
 @constant ended
 Indicates that the player item has reached the end of the playback
 @constant buffering
 Indicates that playback has consumed all buffered media and that playback will stall or end
 @constant locked
 Indicates that the player is locked, in this state the user interactions are ignored (play, pause, seekTo)
 @constant error
 Indicates that the player item can no longer be played because of an error.
 */
enum PlaybackState : String {
    case unknown = "unknown"
    case unstarted = "unstarted"
    case playing = "playing"
    case paused = "paused"
    case ended = "ended"
    case buffering = "buffering"
    case seeking = "seeking"
    case seeked = "seeked"
    case locked = "locked"
    case error = "error"
}
