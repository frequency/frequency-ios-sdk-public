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
    static let playerURL = "https://static.frequency.com/player/3.1.1/playerEmbed.js"
    
    static let adsPrdDecisioningUrl = "https://prd-freq-ad-eu.frequency.com"
    static let adsQaDecisioningUrl = "https://qa-freq-ad-decision.frequency.com"
    static let adsMinBitrate = 1
    static let adsMaxBitrate = 16
    static let adsMaxResolution = "720p"
    static let adsMinResolution = "340p"
    static let adsDeliveryFormat = "progressive"
    static let adsDeliveryProtocol = "https"
    static let adsFormat = "video/mp4"
    
}


@objc class PlayerConstant: NSObject {
    private override init() {}
    
    class func adsPrdDecisioningUrl() -> String { return PlayerConstants.adsPrdDecisioningUrl }
    class func adsQaDecisioningUrl() -> String { return PlayerConstants.adsQaDecisioningUrl }
    class func adsMinBitrate() -> Int { return PlayerConstants.adsMinBitrate }
    class func adsMaxBitrate() -> Int { return PlayerConstants.adsMaxBitrate }
    class func adsMaxResolution() -> String { return PlayerConstants.adsMaxResolution }
    class func adsMinResolution() -> String { return PlayerConstants.adsMinResolution }
    class func adsDeliveryFormat() -> String { return PlayerConstants.adsDeliveryFormat }
    class func adsDeliveryProtocol() -> String { return PlayerConstants.adsDeliveryProtocol }
    class func adsFormat() -> String { return PlayerConstants.adsFormat }
}

/*
let adsPrdDecisioningUrl = "https://prd-freq-ad-eu.frequency.com"
public let adsQaDecisioningUrl = "https://qa-freq-ad-decision.frequency.com"
public let adsMinBitrate = 100
public let adsMaxBitrate = 5000
public let adsMaxResolution = "720p"
public let adsMinResolution = "720p"
public let adsDeliveryFormat = "progressive"
public let adsDeliveryProtocol = "https"
public let adsFormat = "video/mp4"

@objc class PlayerConstants: NSObject {
    private override init() {}
    
    class func adsPrdDecisioningUrl() -> String { return adsPrdDecisioningUr }
    class func adsQaDecisioningUrl() -> String { return adsQaDecisioningUrl }
    class func adsMinBitrate() -> String { return adsMinBitrate }
    class func adsMaxBitrate() -> String { return adsMaxBitrate }
    class func adsMaxResolution() -> String { return adsMaxResolution }
    class func adsMinResolution() -> String { return adsMinResolution }
    class func adsDeliveryFormat() -> String { return adsDeliveryFormat }
    class func adsDeliveryProtocol() -> String { return adsDeliveryProtocol }
    class func adsFormat() -> String { return adsFormat }
}
*/
