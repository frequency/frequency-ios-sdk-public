//
//  ConvivaConfig.swift
//  FAVPlayer
//
//  Created by clement perez on 2/6/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import Foundation

@objc public class ConvivaConfig: NSObject {
    var customerKey : String = ""
    var gatewayUrl : String = ""
    var tags : [String]
    
    @objc public init(customerKey: String, gatewayUrl: String, tags: [String]){
        self.customerKey = customerKey
        self.gatewayUrl = gatewayUrl
        self.tags = tags
        super.init()
    }
    
    internal func getStringConfig() -> String{
        
        let adsConfigStr = """
        ['Conviva',
        {
        customer_key: '\(self.customerKey)',
        gateway_url: '\(self.gatewayUrl)',
        tags: {
            tag1: '\(self.tags[0])',
            tag2: '\(self.tags[1])'
        }
        }]
        """
        
        return adsConfigStr
    }
    
}
