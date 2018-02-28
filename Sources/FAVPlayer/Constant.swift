//
//  PlayerConstants.swift
//  FAVplayer
//
//  Created by clement perez on 1/4/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation

struct PlayerConstants {
    static let apiURL = "https://prd-freq.frequency.com"
    static let playerURL = "https://static.frequency.com/player/3.1.0/playerEmbed.js"
    
    static let adsPrdDecisioningUrl = "https://prd-freq-ad-eu.frequency.com"
    static let adsQaDecisioningUrl = "https://qa-freq-ad-decision.frequency.com"
    static let adsMinBitrate = 100
    static let adsMaxBitrate = 5000
    static let adsMaxResolution = "720p"
    static let adsMinResolution = "720p"
    static let adsDeliveryFormat = "progressive"
    static let adsDeliveryProtocol = "https"
    static let adsFormat = "video/mp4"
    
}
