//
//  File.swift
//  FAVPlayer
//
//  Created by clement perez on 2/27/18.
//  Copyright © 2018 Frequency Networks. All rights reserved.
//

import Foundation
import AdSupport
import CoreTelephony
import CoreLocation
import UIKit

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
    
    var DNT: Bool{
        let ad = ASIdentifierManager.shared()
        return ad.isAdvertisingTrackingEnabled
    }
    
    var advertisingId: String{
        let ad = ASIdentifierManager.shared()
        return ad.advertisingIdentifier.uuidString
    }
    
    var userAgent: String {
        return "\(appNameAndVersion()) \(deviceName()) \(deviceVersion()) \(CFNetworkVersion()) \(DarwinVersion())"
    }
    
    var manufacturer: String { return "Apple" }
    
    var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return ""
    }
    
    var connectionType: String {
        do{/*
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            do{
                try reachability.startNotifier()
                let status = reachability.currentReachabilityStatus
                if(status == .NotReachable){
                    return ""
                }else if (status == .ReachableViaWiFi){
                    return "Wifi"
                }else if (status == .ReachableViaWWAN){
                    let networkInfo = CTTelephonyNetworkInfo()
                    let carrierType = networkInfo.currentRadioAccessTechnology
                    switch carrierType{
                    case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?: return "2G"
                    case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?: return "3G"
                    case CTRadioAccessTechnologyLTE?: return "4G"
                    default: return ""
                    }
                    
                    
                }else{
                    return ""
                }
            }catch{
                return ""
            }*/
            
        }catch{
            return ""
        }
        return ""
    }
    
    var carrierId: String{
        let netInfo = CTTelephonyNetworkInfo()
        var carrier = netInfo.subscriberCellularProvider
        return carrier == nil ? "unkown" : carrier!.carrierName!
    }
    var countryCode: String{
        let netInfo = CTTelephonyNetworkInfo()
        var carrier = netInfo.subscriberCellularProvider
        return carrier == nil ? "unkown" : carrier!.isoCountryCode!
    }
    var timeZone: String{
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        return localTimeZoneAbbreviation   // "GMT-2"
    }
    var locale: String{
        // returns the app language
        return Locale.current.languageCode!
    }
    var browser: String?
    var language: String{
        // returns the app language
        return Locale.preferredLanguages[0]
    }
    var longitude: String{
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location
        }
        return currentLocation == nil ? "unkown" : "\(currentLocation.coordinate.longitude)"
    }
    var latitude: String{
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location
        }
        return currentLocation == nil ? "unkown" : "\(currentLocation.coordinate.latitude)"
    }
    
    var capability: Array<String>{
        return ["VPAID","VAST","MRAID"]
    }
    
    var category: String{
        if(self.model.contains("iPhone") || self.model.contains("iPod")){
            return "phone"
        }else if (self.model.contains("iPad")) {
            return "tablet"
        }else if (self.model.contains("TV")){
            return "tv"
        }
        return "unkown"
    }
    
    var storeAppId: String?
    var companyDomainUrl: String?
    var storeUrl: String?
    
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
    
    @objc public convenience init(environment: AdsConfig.Environment,
                                  minBitrate: NSNumber?,
                                  maxBitrate: NSNumber?,
                                  maxResolution: String?,
                                  minResolution: String?,
                                  deliveryFormat: String?,
                                  deliveryProtocol: String?,
                                  format: String?,
                                  storeAppId: String?,
                                  companyDomainUrl: String?,
                                  storeUrl: String?) {
        
        self.init(environment: environment)
        
        self.minBitrate = minBitrate?.intValue
        self.maxBitrate = maxBitrate?.intValue
        self.maxResolution = maxResolution!
        self.minResolution = minResolution!
        self.deliveryFormat = deliveryFormat!
        self.deliveryProtocol = deliveryProtocol!
        self.format = format!
        
        self.storeAppId = storeAppId!
        self.companyDomainUrl = companyDomainUrl!
        self.storeUrl = storeUrl!
    }
    
    func DarwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return "Darwin/\(dv)"
    }
    //eg. CFNetwork/808.3
    func CFNetworkVersion() -> String {
        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
        let version = dictionary?["CFBundleShortVersionString"] as! String
        return "CFNetwork/\(version)"
    }
    
    //eg. iOS/10_1
    func deviceVersion() -> String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }
    //eg. iPhone5,2
    func deviceName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    //eg. MyApp/1
    func appNameAndVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let name = dictionary["CFBundleName"] as! String
        return "\(name)/\(version)"
    }
    
    func appName() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let name = dictionary["CFBundleName"] as! String
        return "\(name)/"
    }
    
    internal func getAdStringConfig() -> String{
        
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
    
    internal func getIMAAdsStringConfig() -> String{
        
        let adsConfigStr = """
            ['IMAAds',{
                params : {
                                url: '\(self.url)'
                                \((self.minBitrate != nil) ? ", minBitrate: '\( self.minBitrate ?? 0)'" : "")
                                \((self.maxBitrate != nil) ? ", maxBitrate: '\( self.maxBitrate ?? 0)'" : "")
                                \((self.maxResolution != nil) ? ", maxResolution: '\( self.maxResolution ?? "")'" : "")
                                \((self.minResolution != nil) ? ", minResolution: '\( self.minResolution ?? "")'" : "")
                                \((self.deliveryFormat != nil) ? ", deliveryFormat: '\( self.deliveryFormat ?? "")'" : "")
                                \((self.deliveryProtocol != nil) ? ", deliveryProtocol: '\( self.deliveryProtocol ?? "")'" : "")
                                \((self.format != nil) ? ", format: '\( self.format ?? "")'" : "")
                },
                device: {
                                DNT: '\(self.DNT)',
                                advertisingId: '\(self.advertisingId)',
                                userAgent: '\(self.userAgent)',
                                manufacturer: '\(self.manufacturer)',
                                model: '\(self.model)',
                                connectionType: '\(self.connectionType)',
                                carrierId: '\(self.carrierId)',
                                countryCode: '\(self.countryCode)',
                                timeZone: '\(self.timeZone)',
                                locale: '\(self.locale)',
                                browser: '\(self.browser)',
                                language: '\(self.language)',
                                longitude: '\(self.longitude)',
                                latitude: '\(self.latitude)',
                                capability: '\(self.capability)',
                                category: '\(self.category)',
                },
                application: {
                                name: '\(self.appNameAndVersion())',
                                bundle: '\(self.appName())'
                                \((self.storeAppId != nil) ? ", id: '\( self.storeAppId ?? "")'" : "")
                                \((self.companyDomainUrl != nil) ? ", domain: '\( self.companyDomainUrl ?? "")'" : "")
                                \((self.storeUrl != nil) ? ", storeLocation: '\( self.storeUrl ?? "")'" : "")
                }
            }
            ]
            """
        
        return adsConfigStr
    }
}



