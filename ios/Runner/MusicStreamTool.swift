//
//  MusicStreamTool.swift
//  CD_OldMusic
//
//  Created by darren on 2018/7/10.
//  Copyright © 2018年 陈亮陈亮. All rights reserved.
//

import UIKit
import StreamingKit
import AVFoundation

enum MusicStreamToolState {
    case beginPlay
    case isPlaying
    case isPaued
    case isCacheing
    case isStoped
    case isEnd
}

typealias MusicStreamToolCurrentPlayTimerClouse = (Int, Int)->()
typealias MusicStreamToolCurrentPlayProgressClouse = (Float)->()
typealias MusicStreamToolPlayEndClouse = ()->()
typealias MusicStreamToolPlayStateClouse = (MusicStreamToolState)->()

class MusicStreamTool: NSObject {
    static let share = MusicStreamTool()
    
    var playStatus: MusicStreamToolState = MusicStreamToolState.isStoped
    var playStatusClouse: MusicStreamToolPlayStateClouse?
    var currentPlayTimerClouse: MusicStreamToolCurrentPlayTimerClouse?
    var currentPlayProgressclouse: MusicStreamToolCurrentPlayProgressClouse?

    var totalTime: Double = 0
    var currentSong: [String: String] = ["":""]
    
    var playMode = "0"
    
    var audioPlayer: STKAudioPlayer?
    
//    lazy var audioPlayer: STKAudioPlayer = {
//        var options = STKAudioPlayerOptions()
//        options.flushQueueOnSeek = true
//        options.enableVolumeMixer = true
//        let equalizerB: (Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) = (31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 )
//        options.equalizerBandFrequencies = equalizerB
//        let player = STKAudioPlayer(options: options)
//
//        player.meteringEnabled = true
//        player.volume = 1
//        player.equalizerEnabled = true
//        player.delegate = self
//        return player
//    }()
//
    
    //读取播放进度的定时器
    lazy var timer: Timer = {
        let time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(time, forMode: RunLoopMode.defaultRunLoopMode)
        return time
    }()
    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionEvent(notic:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        // 耳机拔出
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(notic:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        // 进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidEnterBackgroundNotification(notic:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    var canResume = false
    // 播放过程中来电话暂停播放 ，挂电话后开始播放
    @objc func onAudioSessionEvent(notic: Notification) {
        print(self.playStatus)
        if self.playStatus == .isPlaying {
            canResume = true
        }
        if notic.userInfo == nil {
            return
        }
        print(notic.userInfo ?? "")
        let type = notic.userInfo![AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType.RawValue
        let type2 = notic.userInfo![AVAudioSessionInterruptionOptionKey] as? Int

        print("type = \(String(describing: type))")
        print("type2=\(String(describing: type2))")

        if type == 1 && type2 == nil {
            self.pauseMusic()
        }
        if type == 0 && type2 == 1 && canResume {
            self.playMusic()
            
            canResume = false
        }
    }
    @objc func audioRouteChangeListenerCallback(notic: Notification) {
        if notic.userInfo == nil {
            return
        }
        let type = notic.userInfo![AVAudioSessionRouteChangeReasonKey] as? AVAudioSession.RouteChangeReason.RawValue
        if type == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue { // 耳机拔出
            print(self.playStatus)
            if self.playStatus == .isPlaying {
                self.pauseMusic()
            }
        }
    }
    @objc func audioDidEnterBackgroundNotification(notic: Notification) {
    }
    var model: [String: Any]! {
        didSet{
            print("歌曲url===\(String(describing: model["songUrl"]))")
            guard let music = model["songUrl"] else { return}
            
            if self.audioPlayer != nil {
                self.stop()
                self.audioPlayer?.clearQueue()
                self.audioPlayer?.dispose()
                self.audioPlayer = nil
            }
            
            var options = STKAudioPlayerOptions()
            options.flushQueueOnSeek = true
            options.enableVolumeMixer = true
            let equalizerB: (Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) = (31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 )
            options.equalizerBandFrequencies = equalizerB
            let player = STKAudioPlayer(options: options)
            
            player.meteringEnabled = true
            player.volume = 1
            player.equalizerEnabled = true
            player.delegate = self
            self.audioPlayer = player
            
            self.totalTime = Double(model["duration"] as? String ?? "0") ?? 0
            if ((model["isLocal"] as? Bool) == true) {
                let path = music as? String ?? ""
                let url = URL.init(fileURLWithPath: path)
                self.audioPlayer?.queue(url)
            } else {
                guard let url = self.HDinit(string: music as! String) else {return}
                self.audioPlayer?.queue(url)
            }
            
        }
    }
    func HDinit(string:String) -> URL? {
        let urlStrVaile = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return URL(string: urlStrVaile ?? "")
    }

    //停止播放
    func stop() {
        stopTimer()
        audioPlayer?.stop()
        self.setState(state: MusicStreamToolState.isStoped)
    }
    // 从暂停处播放
    func playMusic() {
        startTimer()
        audioPlayer?.resume()
    }
    func pauseMusic() {
        audioPlayer?.pause()
        stopTimer()
    }
    
    /// 设置播放器的状态
    func setState(state: MusicStreamToolState) {
        self.playStatus = state
        if (self.playStatusClouse != nil) {
            self.playStatusClouse!(self.playStatus)
        }
        
        self.updateBackgroundInfo()
        
        if state == .isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func updateBackgroundInfo() {
        // 后台播放
        let img: UIImage = UIImage(named:"AppIcon60x60") ?? UIImage()
        BackgroundTools.share.setOnceInfo(img: img, currentTimer: Int(self.audioPlayer?.progress ?? 0))
    }
}
// 3是播放中，5是开始播放但可能是还没有声音， 9是暂停  stopReason=2代表当前播放结束 stopReason=1代表是正常播放结束
// 由3-5是缓冲中，
extension MusicStreamTool: STKAudioPlayerDelegate {
    
    //开始播放歌曲
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didStartPlayingQueueItemId queueItemId: NSObject) {
        print("开始播放歌曲,歌曲状态=\(audioPlayer.state)")
        self.setState(state: MusicStreamToolState.beginPlay)
        self.startTimer()
    }
    
    //缓冲完毕
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        print("缓冲完毕,播放状态是\(audioPlayer.state.rawValue)")
    }
    
    //播放状态变化
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     stateChanged state: STKAudioPlayerState,
                     previousState: STKAudioPlayerState) {
        print("播放状态变化,之前的状态\(previousState.rawValue)--现在的状态\(state.rawValue)")
        if (state.rawValue == 9) { // 暂停
            self.setState(state: MusicStreamToolState.isPaued)
        }
        if (previousState.rawValue == 3 && state.rawValue == 5) { // 缓冲
            self.setState(state: MusicStreamToolState.isCacheing)
        }
        if (state.rawValue == 3) { // 开始播放
            self.setState(state: MusicStreamToolState.isPlaying)
        }
    }
    
    //播放结束
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishPlayingQueueItemId queueItemId: NSObject,
                     with stopReason: STKAudioPlayerStopReason,
                     andProgress progress: Double, andDuration duration: Double) {
        
        print("播放结束stopReason\(stopReason.rawValue)")
        self.stopTimer()
        if stopReason.rawValue == 1 || stopReason.rawValue == 0 {
            self.setState(state: MusicStreamToolState.isEnd)
        }
        if stopReason.rawValue == 2 {
            self.setState(state: MusicStreamToolState.isStoped)

            let music = self.model["songUrl"] ?? ""
            guard let url = self.HDinit(string: music as! String) else {
                return
            }
            self.audioPlayer?.play(url)
        }
    }
    
    //发生错误
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print("播放出错 \(errorCode.rawValue)")
        if errorCode.rawValue == 3 {
            self.setState(state: MusicStreamToolState.isStoped)
            let alertController = UIAlertController(title: "系统提示", message: "播放器出错", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (ACTION) in
                print("确定")
                
            }
            alertController.addAction(okAction);
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            return
        }
        self.setState(state: MusicStreamToolState.isStoped)
    }
}
extension MusicStreamTool {
    /**启动定时器 更新进度*/
    func startTimer(){
        timer.fireDate = Date.distantPast
    }
    /**关闭定时器*/
    func stopTimer(){
        if timer.isValid {
            timer.fireDate = Date.distantFuture
        }
    }
    
    @objc func updateProgress() {
        self.updateValue()
    }
    func updateValue() {
        if self.currentPlayTimerClouse != nil {
            self.currentPlayTimerClouse!(Int((self.audioPlayer?.progress ?? 0)), Int(audioPlayer?.duration ?? 0))
        }
        let value = Float((self.audioPlayer?.progress ?? 0)) / Float(self.totalTime)
        if self.currentPlayProgressclouse != nil {
            self.currentPlayProgressclouse!(value)
        }
        
        let timer = Int(self.audioPlayer?.progress ?? 0)
        BackgroundTools.share.setCurrentTimer(currentTimer: timer)
        if (timer < 2) {
            self.updateBackgroundInfo()
        }
    }
    
    func seekMusic(playOffset: Float) {
        //播放器定位到对应的位置
        audioPlayer?.seek(toTime: Double(playOffset))
        
        //如果当前时暂停状态，则继续播放
        if self.playStatus == .isPlaying
        {
            audioPlayer?.resume()
        }
    }
    
    func getAssetDuration() -> Float {
        var duration = Float(self.totalTime)
        if duration == 0 {
            duration = Float(self.audioPlayer?.duration ?? 0)
        }
        return duration
    }
}

extension MusicStreamTool {
    //MARK: - eq
    public func updateEQ(gains: [Float]) {
        for i in 0...9 {
            self.audioPlayer?.setGain(Float(gains[i]), forEqualizerBand: Int32(i))
        }
    }
    
    public func updateEQ(BandIndex: Int, gain: Float) {
        self.audioPlayer?.setGain(gain, forEqualizerBand: Int32(BandIndex))
    }
}



