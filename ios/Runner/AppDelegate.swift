import UIKit
import Flutter
import AVFoundation
let HOST_URL = "http://chenliang.yishouhaoge.cn/#/"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller: FlutterViewController = window.rootViewController as! FlutterViewController
    let userdefault = FlutterMethodChannel(name: "darren.com.example.flutterFlowermusic/mutual", binaryMessenger: controller)
    userdefault.setMethodCallHandler { (call, result) in
        if "GoodComment" == call.method { // 好评
            self.goodComment()
        }
        if "share" == call.method {
            self.share(data: call.arguments)
        }
    }
    
    // 注册后台播放
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
}
