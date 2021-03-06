# FAVplayer

The FAVPlayer is an AVPlayer that let you play Frequency's videos Natively.
Here's the snippet that would let you quickly play a Frequency Video.

## To include this framework to your project:

set up your project with Cocoapods:
```
https://guides.cocoapods.org/using/using-cocoapods
```
Add this line to your Podfile:
```
pod 'FAVPlayer', :git => 'https://github.com/frequency/frequency-ios-sdk-public.git', :tag => '0.0.1'
```
Then in your terminal, at the root of your project, `pod update`

## To play a video

First you'll have to authenticate, then create the player and pass it the token and deviceId.
```
var favPlayer = FAVPlayer.init(apiUrl: "https://prd-freq.frequency.com", token: "TOKEN_ID", deviceId: "DEVICE_ID")
```
Create an avPlayerViewController and assign the newly created favPlayer as its player.
```
var avPlayerViewController = AVPlayerViewController.init()
avPlayerViewController.player = favPlayer
```

Load a videoId provided by a Frequency service
```
favPlayer.load(videoId: "VIDEO_ID")
```
Present the AVPlayerViewController.
```
self.present(avPlayerViewController, animated: true, completion: nil)
```

## Plugins

The Player has some functionnalities that can be added to it.
So far it support Conviva tracking and advertisement.
To enable Conviva tracking or Advertisment you'll have to provide a configuration for the plugin in the constructor.

```
let adsConfig = AdsConfig.init()
let convivaConfig = ConvivaConfig.init(customerKey: "KEY", gatewayUrl: "URL", tags: ["tag1","tag2"])

var favPlayer = FAVPlayer.init(apiUrl: "https://prd-freq.frequency.com",
                                  token: "TOKEN_ID",
                                  deviceId: "DEVICE_ID",
                                  conviva: convivaConfig,
                                  adsConfig: adsConfig)
```

## The Demo App

Open the FAVPlayer.xcodeproj
Insert the token and deviceId in the [Player constructor in the MainViewController](https://github.com/frequency/frequency-ios-sdk-public/blob/master/Sources/Demo/MainViewController.swift#L39)

Launch the app on a device or simulator

A video will play

Note: if you're not using htpps://prd-freq.frequency.com you will need to change the video ids and channel ids in
[DemoConstants](https://github.com/frequency/frequency-ios-sdk-public/blob/master/Sources/Demo/DemoConstants.swift)
