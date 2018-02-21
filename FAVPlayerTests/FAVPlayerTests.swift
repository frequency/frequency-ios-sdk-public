//
//  FAVPlayerTests.swift
//  FAVPlayer-Tests
//
//  Created by clement perez on 2/19/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import XCTest
@testable import FAVPlayer

class FAVPlayerTests: XCTestCase, PlayerEventDelegate {
    
    var player : FAVPlayer
    
    var expOnReady : XCTestExpectation
    var expOnMediaReady : XCTestExpectation
    var expOnProgress : XCTestExpectation
    var expOnStateChange : XCTestExpectation
    var expOnError : XCTestExpectation
    
    override init(){
        player = FAVPlayer.init(apiUrl: "qa-lgi-api.frequency.com", token: "9304eb73-91ad-47c6-830a-34dc41cafa62", deviceId: "58646e77-587b-ebdc")
        
        expOnReady = XCTestExpectation.init()
        expOnMediaReady = XCTestExpectation.init()
        expOnProgress = XCTestExpectation.init()
        expOnStateChange = XCTestExpectation.init()
        expOnError = XCTestExpectation.init()
        
        super.init()
    }
    
    override func setUp() {
        super.setUp()
        
        player = FAVPlayer.init(apiUrl: "qa-lgi-api.frequency.com", token: "9304eb73-91ad-47c6-830a-34dc41cafa62", deviceId: "58646e77-587b-ebdc")
        
        player.jsDelegate = self
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInit() {
        let exp = XCTestExpectation.init()
    }
    
    func testPlay(){
        
        expOnMediaReady = expectation(description: "Wait for onMediaReady to be fired")
        
        player.load(videoId: "6258115882747870065")
        
        waitForExpectations(timeout: 10) { error in
            
        }

    }
    
    /*!
     @method onReady:
     @abstract          The onReady event is fired when the player is initialized and loaded.
     @discussion        All actions sent to the player before onReady are not guaranteed to be taken into account
     */
    func onReady(){
        expOnReady.fulfill()
    }
    
    /*!
     @method onMediaReady:
     @abstract          The onMediaReady event is fired when the player item is ready to be played.
     */
    func onMediaReady(){
        
        expOnMediaReady.fulfill()
    }
    
    /*!
     @method onStateChange:
     @abstract          onStateChange event is fired when the playback state of the player item changes
     @discussion        See PlaybackState for the possible values
     */
    func onStateChange(playbackState: PlaybackState){
        switch playbackState {
        case PlaybackState.error:
            break
        case PlaybackState.unknown:
            break
        case PlaybackState.unstarted:
            break
        case PlaybackState.playing:
            expOnMediaReady.fulfill()
            break
        case PlaybackState.paused:
            break
        case PlaybackState.ended:
            break
        case PlaybackState.buffering:
            break
        case PlaybackState.locked:
            break
        default: break
            
        }
    }
    
    /*!
     @method onProgress:
     @abstract          event is fired when the playback state of the player changes
     @discussion        called every 500ms
     */
    func onProgress(position: Double, duration: Double){
        
    }
    
    /*!
     @method onError:
     @abstract          event is fired when the playback or the Player as encountered an error
     @param             the error description
     */
    func onError(error : String){
        
    }
    
    /*!
     @method onUserAction:
     @abstract          event is fired when the user interacts with the player
     @param             the action label
     @discussion
     */
    func onUserAction(action : String){
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

