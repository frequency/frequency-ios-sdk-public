//
//  File.swift
//  FAVPlayer
//
//  Created by clement perez on 2/27/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import Foundation

public class AdsConfig : NSObject {
    
    enum Environment : String{
        case QA = "qa"
        case Prod = "prd"
    }
    
    var environment: Environment
    var url: String
    var minBitrate: Int
    var maxBitrate: Int
    var maxResolution: String
    var minResolution: String
    var deliveryFormat: String
    var deliveryProtocol: String
    var format: String
    
    init(environment: AdsConfig.Environment,
         minBitrate: Int? = PlayerConstants.adsMinBitrate,
         maxBitrate: Int? = PlayerConstants.adsMaxBitrate,
         maxResolution: String? = PlayerConstants.adsMaxResolution,
         minResolution: String? = PlayerConstants.adsMinResolution,
         deliveryFormat: String? = PlayerConstants.adsDeliveryFormat,
         deliveryProtocol: String? = PlayerConstants.adsDeliveryProtocol,
         format: String? = PlayerConstants.adsFormat) {
        
        self.environment = environment
        self.url = ""
        
        switch environment {
        case Environment.QA :
            url = PlayerConstants.adsQaDecisioningUrl
        case Environment.Prod :
            url = PlayerConstants.adsPrdDecisioningUrl
        default:
            url = PlayerConstants.adsPrdDecisioningUrl
        }
        
        self.minBitrate = minBitrate!
        self.maxBitrate = maxBitrate!
        self.maxResolution = maxResolution!
        self.minResolution = minResolution!
        self.deliveryFormat = deliveryFormat!
        self.deliveryProtocol = deliveryProtocol!
        self.format = format!
        
        super.init()
    }
}