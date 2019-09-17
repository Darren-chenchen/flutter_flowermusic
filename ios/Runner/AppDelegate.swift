import UIKit
import Flutter
import AVFoundation
let HOST_URL = "http://chenliang.yishouhaoge.cn/#/"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
  var eventSink: FlutterEventSink?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    let name = "darren.com.example.flutterFlowermusic/mutual"
    let event = "darren.com.example.flutterFlowermusic/event"
    let controller: FlutterViewController = window.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: name, binaryMessenger: controller)
    channel.setMethodCallHandler { (call, result) in
        
        if "share" == call.method {
            self.share(data: call.arguments)
        }
        if "beginPlay" == call.method {
            self.beginPlay(data: call.arguments)
        }
        if "pause" == call.method {
            MusicStreamTool.share.pauseMusic()
        }
        if "resume" == call.method {
            MusicStreamTool.share.playMusic()
        }
        if "seek" == call.method {
            let timer = call.arguments as? Int ?? 0
            MusicStreamTool.share.seekMusic(playOffset: Float(timer))
        }
        if "GoodComment" == call.method { // 好评
            self.goodComment()
        }
    }
    let evenChannal = FlutterEventChannel.init(name: event, binaryMessenger: controller)
    evenChannal.setStreamHandler(self)

    // 注册后台播放
    setupActive()
    
    /// 原生传值给flutter
    setupDataToFlutter()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // 五星好评
    func goodComment() {
        var urlStr = ""
        urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1459852637&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        let url = URL.init(string: urlStr)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func share(data: Any?) {
        let music = data as? [String : Any]
        if music != nil {
            let shareText = "this song is so nice"
            let str = HOST_URL + "chenliang/music/single?id=\(music!["_id"] ?? "")"
            if let url = URL(string: str) {
                let img: UIImage = UIImage(named:"Icon-60") ?? UIImage()
                let shareItems:Array = [shareText, url, img] as [Any]
                let activityVC = UIActivityViewController.init(activityItems: shareItems, applicationActivities: nil)
                let controller: FlutterViewController = window.rootViewController as! FlutterViewController
                controller.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    func setupDataToFlutter() {
        MusicStreamTool.share.currentPlayTimerClouse = { (timer, totalTimer) in
            // 防止服务器没有返回duration
            if (self.eventSink != nil) {
                self.eventSink!("progress" + "&" + "\(timer)+\(totalTimer)")
            }
        }
        MusicStreamTool.share.playStatusClouse = {(state) in
            print("--------------")
            print(state)
            if state == MusicStreamToolState.beginPlay {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "beginPlay")
                }
            }
            if state == MusicStreamToolState.isPlaying {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "isPlaying")
                }
            }
            if state == MusicStreamToolState.isCacheing {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "isCacheing")
                }
            }
            if state == MusicStreamToolState.isPaued {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "playPause")
                }
            }
            // 自然停止，自动播放下一首
            if state == MusicStreamToolState.isEnd {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "playEnd")
                }
            }
            // 点击下一首播放的状态是stop
            if state == MusicStreamToolState.isStoped {
                if (self.eventSink != nil) {
                    self.eventSink!("state" + "&" + "playStop")
                }
            }
            
        }
    }
    
    func setupActive() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            if #available(iOS 11.0, *) {
                try session.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, routeSharingPolicy: AVAudioSessionRouteSharingPolicy.default, options: AVAudioSessionCategoryOptions.init(rawValue: 0))
            } else {
                // Fallback on earlier versions
                try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.init(rawValue: 0))
            }
        } catch {
            print(error)
        }
    }
    
    
    /// ios 给flutter传递数据建立桥梁
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func beginPlay(data: Any?) {
        let music = data as? [String : Any]
        MusicStreamTool.share.model = music ?? ["":""]
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEventType.remoteControl {
            switch event!.subtype {
            case .remoteControlPreviousTrack:
                print("上一首")
                if (self.eventSink != nil) {
                    self.eventSink!("preMusic" + "&" + "111")
                }
            case .remoteControlNextTrack:
                print("下一首")
                if (self.eventSink != nil) {
                    self.eventSink!("nextMusic" + "&" + "111")
                }
            case .remoteControlPlay:
                print(">")
                MusicStreamTool.share.playMusic()
            case .remoteControlPause:
                print("||")
                MusicStreamTool.share.pauseMusic()
            default:
                break
            }
        }
    }
}
