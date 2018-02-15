Pod::Spec.new do |s|

  s.name         = "FAVPlayer"
  s.version      = "0.0.1"
  s.summary      = "The FAVPlayer or Frequency AVPlayer is a iOS and tvOS native player which let you easily play Frequency's videos."

  s.description  = <<-DESC
            The FAVPlayer or Frequency AVPlayer is a iOS and tvOS native player which let you easily play Frequency's videos.

            The FAVPlayer encapsulate all the logic required to play a video with advertisement, reporting and beaconing. This project leverage the Javascript Core framework to allow the existing Javascript code of the Javascript Player SDK to be interfaced with Swift and objc. The native part, written in Swift 4, is only responsible for playback and sending/handling events. The Javascript part handles requests to the Frequency API, request to the ad decisioning server, parse the VAST responses, tracks the activity of the player, and sends beacons to the appropriate ad servers.

To play a video

First you'll have to authenticate, then create the player and pass it the token and deviceId.

var f = FAVPlayer.init(apiUrl: "https://prd-freq.frequency.com", token: "TOKEN_ID", deviceId: "DEVICE_ID")

Create an avPlayerViewController and assign the newly created favPlayer as its player.

var avPlayerViewController = AVPlayerViewController.init()
avPlayerViewController.player = favPlayer

Load a videoId provided by a Frequency service

favPlayer.load(videoId: "VIDEO_ID")

Present the AVPlayerViewController.

self.present(avPlayerViewController, animated: true, completion: nil)

                     DESC

  s.homepage     = "https://www.frequency.com/"
  s.license      = { :type => 'BSD' }
  s.author             = { "clementperez" => "clement@frequency.com" }
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.source       = { :git => "https://github.com/frequency/frequency-ios-sdk-public.git", :tag => "#{s.version}" }
  s.source_files  = "Sources", "Sources/**/*.{h,m,swift}"
  s.exclude_files = "Demo" , "Sources/Ejecta/*.{h,m}", "Sources/Ejecta/**/*.{h,m}"
  s.requires_arc = true

  s.subspec 'no-arc' do |sp|
     sp.source_files = "Sources/Ejecta/*.{h,m}", "Sources/Ejecta/**/*.{h,m}"
     sp.requires_arc = false
  end

  s.resources = "Assets/*.js"

end
