//
//  Swift2JSService.swift
//  FAVplayer
//
//  Created by clement perez on 1/23/18.
//  Copyright © 2018 com.frequency. All rights reserved.
//

import Foundation

@objc public protocol JSPlayerInterface {
    func addEventListener(eventName: String, callback : String)
    func removeEventListener(eventName: String, callback : String)
    func setSession(authToken: String, deviceId : String)
    func load(videoId: String)
    func load(channelId: String)
    func setApiUrl(apiUrl : String)
    func skipAd()
}
