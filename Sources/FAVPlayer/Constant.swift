//
//  PlayerConstants.swift
//  FAVplayer
//
//  Created by clement perez on 1/4/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation

public struct PlayerConstants {
    static let apiURL = "https://prd-freq.frequency.com"
    static let playerURL = "https://static.frequency.com/player/3.1.0/playerEmbed.js"
    
    public static let adsPrdDecisioningUrl = "https://prd-freq-ad-eu.frequency.com"
    public static let adsQaDecisioningUrl = "https://qa-freq-ad-decision.frequency.com"
    public static let adsMinBitrate = 100
    public static let adsMaxBitrate = 5000
    public static let adsMaxResolution = "720p"
    public static let adsMinResolution = "720p"
    public static let adsDeliveryFormat = "progressive"
    public static let adsDeliveryProtocol = "https"
    public static let adsFormat = "video/mp4"
    
}
