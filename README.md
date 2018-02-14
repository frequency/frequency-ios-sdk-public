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
var f = FAVPlayer.init(apiUrl: "https://prd-freq.frequency.com", token: "TOKEN_ID", deviceId: "DEVICE_ID")
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

