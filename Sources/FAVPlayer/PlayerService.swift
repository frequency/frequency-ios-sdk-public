//
//  PlayerService.swift
//  Frequency-NativePlayerSDK
//
//  Created by clement perez on 11/30/17.
//  Copyright © 2017 com.frequency.native-player-sdk. All rights reserved.
//

import Foundation
import JavaScriptCore

enum PlayerEvent : String {
    case onReady = "onReady"
    case onMediaReady = "onMediaReady"
    case onStateChange = "onStateChange"
    case onProgress = "onProgress"
    case onError = "onError"
    case onUserAction = "onUserAction"
}

class PlayerService : NSObject, PlayerEventDelegate, JSPlayerInterface, JSCallbackInterface{

    var isReady : Bool
    var functionQueue : [String]
    
    var events = [PlayerEvent: [String]]()
    var javascriptView : EJJavaScriptView?
    
    init(player : JS2SwiftPlayerInterface) {
        isReady = false
        functionQueue = []
        
        events[PlayerEvent.onReady] = [String]()
        events[PlayerEvent.onMediaReady] = [String]()
        events[PlayerEvent.onStateChange] = [String]()
        events[PlayerEvent.onProgress] = [String]()
        events[PlayerEvent.onError] = [String]()
        events[PlayerEvent.onUserAction] = [String]()
        javascriptView = EJJavaScriptView.init()
        
        super.init()
        
        let bool = false
        let loadLocal = bool || bool // to silence the warning
        
        let scriptPath = loadLocal ? Bundle(for: PlayerService.self).resourcePath! + "/" + "index.js" : PlayerConstants.playerURL
        
        do {
            let script = loadLocal ? try String.init(contentsOfFile: scriptPath, encoding: String.Encoding.utf8) :
                try String.init(contentsOf: URL.init(string: PlayerConstants.playerURL)!, encoding: String.Encoding.utf8)
            
            print("loading player located : " + scriptPath)
            _ = javascriptView?.evaluateScript(script ,sourceURL:scriptPath)
            
            let context = JSContext.init(jsGlobalContextRef: self.javascriptView?.jsGlobalContext)
            context?.exceptionHandler = { context, exception in
                print("JS Error: \(exception?.description ?? "unknown error")")
                self.onError(error: (exception?.description)!)
            }
            context?.setObject(player, forKeyedSubscript: "FAVPlayer" as NSCopying & NSObjectProtocol)
            context?.setObject(self, forKeyedSubscript: "JavascriptCallbackInterface" as NSCopying & NSObjectProtocol)
            
        } catch {
            print("failed downloading script located : " + scriptPath)
        }
    }
    
    deinit{
        print("######################################## deinit PLAYERSERVICE ########################################")
    }
    
    func destroy(){
        javascriptView?.removeFromSuperview()
        javascriptView = nil
    }
    
    convenience init(baseUrl: String, authToken: String, deviceId: String, player: JS2SwiftPlayerInterface){
        self.init(baseUrl: baseUrl, authToken: authToken, deviceId: deviceId, convivaConfig: nil, player: player)
    }
    
    convenience init(baseUrl: String, authToken: String, deviceId: String, convivaConfig : ConvivaConfig?, player: JS2SwiftPlayerInterface){
        self.init(player: player)
        
            let context = JSContext.init(jsGlobalContextRef: self.javascriptView?.jsGlobalContext)
        
            let apiConfigStr = """
                api_url: '\(baseUrl)'
                """
            let eventConfigStr = """
                events: {}
                """
            let sessionConfigStr = """
                session: {
                'x-frequency-auth': '\(authToken)',
                'x-frequency-deviceid': '\(deviceId)'
                }
                """
            let convivaConfigStr = """
                conviva: {
                    customer_key: '\(convivaConfig?.customerKey ?? "")',
                    gateway_url: '\(convivaConfig?.gatewayUrl ?? "")',
                    tags: {
                        tag1: "\(convivaConfig?.tags[0] ?? "")",
                        tag2: "\(convivaConfig?.tags[1] ?? "")"
                    }
                }
            """
        
            let adsConfigStr = """
                    ['Ads',
                    {
                        url: 'https://qa-freq-ad-decision.frequency.com',
                        minBitrate: 100,
                        maxBitrate: 5000,
                        maxResolution: '720p',
                        minResolution: '720p',
                        deliveryFormat: 'progressive',
                        deliveryProtocol: 'https',
                        format: 'video/mp4'
                    }]
            """
        
            let playerStr = """
                window.player = new Frequency.Player({
                    \(apiConfigStr),
                    \(sessionConfigStr),
                    \(eventConfigStr),
                    plugins: [
                        \(adsConfigStr)
                        \(convivaConfig == nil ? "" : "," + convivaConfigStr)
                    ]
                })
            """
            print(playerStr)
            _ = context?.evaluateScript(playerStr)
            
            _ = context?.evaluateScript("""
                window.player.on('ready', () => {
                    JavascriptCallbackInterface.onServiceReady();
                });
            """)
            
            _ = context?.evaluateScript("""
                window.player.on('ad', (title, duration, offset) => {
                    FAVPlayer.onAdWithTitleDurationOffset(title, duration, offset);
                });
            """)
    }
    
    func onServiceReady() {
        
        isReady = true
        
        for function in functionQueue {
            _ = self.evaluateScript(script: function)
        }
        functionQueue = []
    }
    
    func onReady() {
        let jsFunctions : [String] = events[PlayerEvent.onReady]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + ")")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onReady.rawValue])
        }
    }
    
    func onMediaReady() {
        
        let jsFunctions : [String] = events[PlayerEvent.onMediaReady]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + ")")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onMediaReady.rawValue])
        }
    }
    
    func onStateChange(playbackState: PlaybackState) {
        
        switch playbackState {
        case PlaybackState.error:
            break
        case PlaybackState.unknown:
            break
        case PlaybackState.unstarted:
            break
        case PlaybackState.playing:
            break
        case PlaybackState.paused:
            break
        case PlaybackState.ended:
            break
        case PlaybackState.buffering:
            break
        case PlaybackState.locked:
            break
        default: break
            
        }
        
        let jsFunctions : [String] = events[PlayerEvent.onStateChange]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + ")")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onStateChange.rawValue,playbackState.rawValue])
        }
    }
    
    func onProgress(position: Double, duration: Double) {
        print(PlayerEvent.onProgress.rawValue + " " + String.init(position) + " " + String.init(duration))
        let jsFunctions : [String] = events[PlayerEvent.onProgress]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + ")")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onProgress.rawValue, position , duration])
        }
    }
    
    func onError(error : String) {
        print(error)
        let jsFunctions : [String] = events[PlayerEvent.onError]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + ")")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onError.rawValue, error])
        }
    }
    
    func onUserAction(action : String) {
        let jsFunctions : [String] = events[PlayerEvent.onUserAction]!
        for jsFunc in jsFunctions{
            let value : JSValue = self.evaluateScript(script: "(" + jsFunc + "")
            _ = value.invokeMethod("call", withArguments: ["", PlayerEvent.onUserAction.rawValue, action])
        }
    }
    
    func load(videoId: String){
        _ = self.evaluateScript(script: "player.loadVideo('" + videoId + "')")
    }
    
    func load(channelId: String){
        _ = self.evaluateScript(script: "player.loadChannel('" + channelId + "')")
    }
    
    func setApiUrl(apiUrl : String){
        
        _ = self.evaluateScript(script: "player.setApi(" + apiUrl + ")")
    }
    
    func setAdConfig(minBitrate: String, maxBitrate: String, maxResolution: String,minResolution: String,deliveryFormat: String, deliveryProtocol: String, format: String){
        
    }
    
    func setSession(authToken: String, deviceId : String){
        
        _ = self.evaluateScript(script: "player.setSession({'X-Frequency-Auth' : " + authToken + " , 'X-Frequency-DeviceId' : " + deviceId + "})")
    }
    
    func skipAd(){
        
        _ = self.evaluateScript(script: "player.skip()")
    }
    
    func addEventListener(eventName: String, callback: String) {
        
        let event = PlayerEvent(rawValue: eventName)
        
        if(event == nil){
            let errorString = "The event " + eventName + " doesn't exist"
            onError(error: errorString)
            return;
        }
        
        events[event!]?.append(callback)
    }
    
    func removeEventListener(eventName: String, callback: String) {
        
        let event = PlayerEvent(rawValue: eventName)
        
        if(event == nil){
            let errorString = "The event " + eventName + " doesn't exist"
            onError(error: errorString)
        }
        
        if(events[event!] != nil){
            if let index = events[event!]?.index(of: callback){
                events[event!]?.remove(at: index)
            }
        }
    }
    
    private func evaluateScript(script: String) -> JSValue{
        if(isReady){
            print("evaluating script : " + script)
            let context = JSContext.init(jsGlobalContextRef: self.javascriptView?.jsGlobalContext)
            return context!.evaluateScript(script)
        }else{
            print("Queing script until player is ready : " + script)
            functionQueue.append(script)
            return JSValue.init()
        }
    }
}

