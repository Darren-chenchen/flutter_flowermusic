
import 'package:flutter/services.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main_provide.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';

class MutualTools {
  // 工厂模式
  factory MutualTools() =>_getInstance();
  static MutualTools get instance => _getInstance();
  static MutualTools _instance;
  static MutualTools _getInstance() {
    if (_instance == null) {
      _instance = new MutualTools._internal();
    }
    return _instance;
  }

  EventChannel eventChannel = const EventChannel("darren.com.example.flutterFlowermusic/event");


  MutualTools._internal() {
    // 监听事件，同时发送参数12345
    eventChannel.receiveBroadcastStream(12345).listen(_onEvent,onError: _onError);
  }

  // 回调事件
  void _onEvent(Object event) {
    var arr = event.toString().split("&");
    if (arr.first == 'progress') {
      var arr2 = arr.last.split('+');
      var progress = arr2.first;
      var total = arr2.last;
      PlayerTools.instance.duration = int.parse(total);
      PlayerTools.instance.currentProgress = int.parse(progress);
    }
    if (arr.first == 'state') {
      if (arr.last == 'beginPlay') {
        PlayerTools.instance.currentState = AudioToolsState.beginPlay;

      }
      if (arr.last == 'isPlaying') {
        PlayerTools.instance.currentState = AudioToolsState.isPlaying;
      }

      if (arr.last == 'isCacheing') {
        PlayerTools.instance.currentState = AudioToolsState.isCacheing;
      } else {
      }

      if (arr.last == 'playPause') {
        PlayerTools.instance.currentState = AudioToolsState.isPaued;
      }
      if (arr.last == 'playEnd') {
        PlayerTools.instance.currentState = AudioToolsState.isEnd;
      }
      if (arr.last == 'isStoped') {
        PlayerTools.instance.currentState = AudioToolsState.isStoped;
      }
      if (arr.last == 'isError') {
        PlayerTools.instance.currentState = AudioToolsState.isError;
      }
    }
    if (arr.first == 'nextMusic') {
      PlayerTools.instance.nextAction();
    }
    if (arr.first == 'preMusic') {
      PlayerTools.instance.preAction();
    }
  }


  // 错误返回
  void _onError(Object error) {

  }

//  分享
  share(Song song) {
    try{
      AppConfig.platform.invokeMethod('share', song.toJson());
    } catch(e){
    }
  }
//  播放歌曲
  beginPlay(Song song) {
    try{
      AppConfig.platform.invokeMethod('beginPlay', song.toJson());
    } catch(e){
    }
  }
//  暂停歌曲
  pause() {
    try{
      AppConfig.platform.invokeMethod('pause');
    } catch(e){
    }
  }
//  从暂停播放
  resume() {
    try{
      AppConfig.platform.invokeMethod('resume');
    } catch(e){
    }
  }
//  停止
  stop() {
    try{
      AppConfig.platform.invokeMethod('stop');
    } catch(e){
    }
  }
//  seek
  seek(int value) {
    try{
      AppConfig.platform.invokeMethod('seek', value);
    } catch(e){
    }
  }
//  安装apk
  install(String path) {
    try{
      AppConfig.platform.invokeMethod('install', path);
    } catch(e){
    }
  }
}