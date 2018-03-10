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
    
    var url: String
    var minBitrate: Int?
    var maxBitrate: Int?
    var maxResolution: String?
    var minResolution: String?
    var deliveryFormat: String?
    var deliveryProtocol: String?
    var format: String?
    
    
    @objc public override init() {
        url = PlayerConstants.adsPrdDecisioningUrl
        super.init()
    }
    
    @objc public convenience init(environment: AdsConfig.Environment) {
        
        self.init()
        
        self.url = ""
        
        switch environment {
        case Environment.QA :
            url = PlayerConstants.adsQaDecisioningUrl
        case Environment.Prod :
            url = PlayerConstants.adsPrdDecisioningUrl
        }
    }
    
    @objc public convenience init(environment: AdsConfig.Environment,
         minBitrate: NSNumber?,
         maxBitrate: NSNumber?,
         maxResolution: String?,
         minResolution: String?,
         deliveryFormat: String?,
         deliveryProtocol: String?,
         format: String?) {
        
        self.init(environment: environment)
        
        self.minBitrate = minBitrate?.intValue
        self.maxBitrate = maxBitrate?.intValue
        self.maxResolution = maxResolution!
        self.minResolution = minResolution!
        self.deliveryFormat = deliveryFormat!
        self.deliveryProtocol = deliveryProtocol!
        self.format = format!
    }
    
    internal func getStringConfig() -> String{
        
        let adsConfigStr = """
            ['Ads',
            {
            url: '\(self.url)'
            \((self.minBitrate != nil) ? ", minBitrate: '\( self.minBitrate ?? 0)'" : "")
            \((self.maxBitrate != nil) ? ", maxBitrate: '\( self.maxBitrate ?? 0)'" : "")
            \((self.maxResolution != nil) ? ", maxResolution: '\( self.maxResolution ?? "")'" : "")
            \((self.minResolution != nil) ? ", minResolution: '\( self.minResolution ?? "")'" : "")
            \((self.deliveryFormat != nil) ? ", deliveryFormat: '\( self.deliveryFormat ?? "")'" : "")
            \((self.deliveryProtocol != nil) ? ", deliveryProtocol: '\( self.deliveryProtocol ?? "")'" : "")
            \((self.format != nil) ? ", format: '\( self.format ?? "")'" : "")
            }]
            """
        
        return adsConfigStr
    }
}



