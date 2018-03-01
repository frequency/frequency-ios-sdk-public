//
//  File.swift
//  FAVPlayer
//
//  Created by clement perez on 2/27/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import Foundation

public class AdsConfig : NSObject {

    @objc public enum Environment : Int{
        case QA
        case Prod
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
    

    @objc public override init() {
        environment = Environment.Prod
        url = ""
        minBitrate = 0
        maxBitrate = 0
        maxResolution = ""
        minResolution = ""
        deliveryFormat = ""
        deliveryProtocol = ""
        format = ""
        
        super.init()
    }
    
    @objc public convenience init(environment: AdsConfig.Environment,
         minBitrate: Int,
         maxBitrate: Int,
         maxResolution: String?,
         minResolution: String?,
         deliveryFormat: String?,
         deliveryProtocol: String?,
         format: String?) {
        
        self.init()
        
        self.environment = environment
        self.url = ""
        
        switch environment {
        case Environment.QA :
            url = PlayerConstants.adsQaDecisioningUrl
        case Environment.Prod :
            url = PlayerConstants.adsPrdDecisioningUrl
        }
        
        self.minBitrate = minBitrate
        self.maxBitrate = maxBitrate
        self.maxResolution = maxResolution!
        self.minResolution = minResolution!
        self.deliveryFormat = deliveryFormat!
        self.deliveryProtocol = deliveryProtocol!
        self.format = format!
    }
}
