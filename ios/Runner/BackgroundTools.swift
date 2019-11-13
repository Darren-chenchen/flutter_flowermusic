//
//  BackgroundTools.swift
//  XFMusic
//
//  Created by darren on 2017/10/12.
//  Copyright © 2017年 陈亮陈亮. All rights reserved.
//

import UIKit
import MediaPlayer

class BackgroundTools: UIResponder {
    static let share = BackgroundTools()
    
    var settings = [String : Any]()
    
    override init() {
        super.init()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    func setOnceInfo(img:UIImage, currentTimer: Int) {
        //大标题 - 小标题  - 歌曲总时长 - 歌曲当前播放时长 - 封面
        self.settings = [MPMediaItemPropertyTitle: MusicStreamTool.share.model["title"] ?? "" ,
                         MPMediaItemPropertyArtist:  MusicStreamTool.share.model["singer"] ?? "" ,
                         MPMediaItemPropertyPlaybackDuration:  MusicStreamTool.share.getAssetDuration(),
                         MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTimer,
                         MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: img)]
        MPNowPlayingInfoCenter.default().setValue(settings, forKey: "nowPlayingInfo")
    }
    
    // 设置后台播放信息
    func setCurrentTimer(currentTimer: Int) {
        //大标题 - 小标题  - 歌曲总时长 - 歌曲当前播放时长 - 封面
        self.settings[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimer
        MPNowPlayingInfoCenter.default().setValue(settings, forKey: "nowPlayingInfo")
    }
}
