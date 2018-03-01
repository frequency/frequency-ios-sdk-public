//
//  ConvivaConfig.swift
//  FAVPlayer
//
//  Created by clement perez on 2/6/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import Foundation

public class ConvivaConfig: NSObject {
    var customerKey : String = ""
    var gatewayUrl : String = ""
    var tags : [String]
    
    @objc public init(customerKey: String, gatewayUrl: String, tags: [String]){
        self.customerKey = customerKey
        self.gatewayUrl = gatewayUrl
        self.tags = tags
        super.init()
    }
}
