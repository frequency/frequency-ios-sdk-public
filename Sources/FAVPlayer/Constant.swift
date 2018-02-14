//
//  PlayerConstants.swift
//  FAVplayer
//
//  Created by clement perez on 1/4/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation

struct PlayerConstants {
    static let apiURL = ""
    static let playerURL = "https://static.frequency.com/player/4.0.0-alpha/playerEmbed.js"
    
    // for test purposes
    static var videoUrls : [String] = ["https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8",
                                "https://media.frequency.com/videos/6344656055616671213/E_yXFDYFT1a0.mp4"]
    
    static var videoIds : [String] = ["6356613982931577798","6356608034434546966","6356262258689322911", "6355140893651178139", "6355128029100885154","6354879620827599610", "6354762708258818148","6354425543578513096","6354014086716695427", "6353629088590573692"]
    
    static var videoIdsQA : [String] = [ "6265340815828208309","6258117143109717905", "6258115883622406860", "6258115882747870065", "6258172601488591315","6262440469185442090","6265000359597920256", "6258114621029955640","6258100798024359275"]
    
    static var channelIds : [String] = ["4370567","6247199154777346044","6247207377266876157"]
}
