import 'dart:async';
import 'dart:math';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main_provide.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';

import 'mutual_tool.dart';

class PlayerTools {
  final stateSubject = new BehaviorSubject<AudioToolsState>.seeded(AudioToolsState.isStoped);
  final progressSubject = new BehaviorSubject<int>.seeded(0);
  final timerDownSubject = new BehaviorSubject<String>.seeded('');
  final currentSongSubject = new BehaviorSubject<Song>.seeded(Song());

  // 工厂模式
  factory PlayerTools() =>_getInstance();
  static PlayerTools get instance => _getInstance();
  static PlayerTools _instance;
  static PlayerTools _getInstance() {
    if (_instance == null) {
      _instance = new PlayerTools._internal();
    }
    return _instance;
  }

  PlayerTools._internal() {
    this.mode = AppConfig.appTools.getMusicMode();
  }

  List<Song> _songArr = [];
  List<Song> get songArr => _songArr;
  set songArr(List<Song> songArr) {
    _songArr = songArr;
  }

  int _currentPlayIndex = 0;
  int get currentPlayIndex => _currentPlayIndex;
  set currentPlayIndex(int index) {
    _currentPlayIndex = index;
  }

  Song _currentSong = Song();
  Song get currentSong => _currentSong;
  set currentSong(Song currentSong) {
    _currentSong = currentSong;
    currentSongSubject.value = currentSong;
  }

  int _currentProgress = 0;
  int get currentProgress => _currentProgress;
  set currentProgress(int progress) {
    _currentProgress = progress;
    this.progressSubject.value = progress;
  }

  int _duration = 0;
  int get duration => _duration;
  set duration(int duration) {
    _duration = duration;
  }

  /// 0顺序 1随机  2单曲
  int _mode = 0;
  int get mode => _mode;
  set mode(int mode) {
    _mode = mode;
    AppConfig.appTools.setMusicMode(mode);
  }

  AudioToolsState _currentState = AudioToolsState.isStoped;
  AudioToolsState get currentState => _currentState;
  set currentState(AudioToolsState state) {
    _currentState = state;
    this.stateSubject.value = state;
    if (state == AudioToolsState.isEnd) {
      this.nextAction(true);
    }
  }

  // 设置数据源
  setSongs([List<Song> songs, int index = 0]) {

    this.songArr.clear();
    this.songArr.addAll(songs);

    this.currentPlayIndex = index;
    if (index < songArr.length) {
      this.play(songArr[index]);
    }

    MainProvide.instance.showMini = true;
  }

  setIndexPlay(int index) {
    if (index < songArr.length) {
      this.play(songArr[index]);
    }
  }

  /// 播放
  play(Song song) async {
    this.currentSong = song;
    if (this.songArr.length == 0) { /// 可能是单曲
      this.songArr = [song];
      this.currentPlayIndex = 0;
      MainProvide.instance.showMini = true;
    }
    this.appPlay(song);
  }
  appPlay(Song song) async {
    Song song_my = Song();
    song_my.songUrl = song.songUrl;
    song_my.id = song.id;
    song_my.duration = song.duration;
    song_my.size = song.size;
    song_my.imgUrl = song.imgUrl;
    song_my.imgUrl_s = song.imgUrl_s;
    song_my.title = song.title;
    song_my.singer = song.singer;
    song_my.lrcUrl = song.lrcUrl;

    var song_url = song.songUrl;
    song_my.songUrl = song_url;
    MutualTools.instance.beginPlay(song);
  }
  /// 暂停
  pause() {
    MutualTools.instance.pause();
  }
  resume() {
    MutualTools.instance.resume();
  }
  /// 停止
  stop() {
    MutualTools.instance.stop();
  }
  /// seek
  seek(int value) {
    MutualTools.instance.seek(value);
  }
  /// 上一首
  preAction() {

    if (this.mode == 1) { // 随机
      this.currentPlayIndex = Random().nextInt(this.songArr.length - 1);
    } else {
      this.currentPlayIndex -= 1;
      if (this.currentPlayIndex < 0) {
        this.currentPlayIndex = this.songArr.length - 1;
      }
    }
    this.play(songArr[currentPlayIndex]);
  }
  /// 下一首
  nextAction([bool isAutoend = false]){
    if (isAutoend && this.mode == 2) {
      this.play(songArr[currentPlayIndex]);
      return;
    }
    if (this.mode == 1) { // 随机
      this.currentPlayIndex = Random().nextInt(this.songArr.length - 1);
    } else {
      this.currentPlayIndex += 1;
      if (this.currentPlayIndex >= this.songArr.length) {
        this.currentPlayIndex = 0;
      }
    }
    this.play(songArr[currentPlayIndex]);
  }


  /// 定时器
  Timer _countdownTimer;
  int _countdownNum = 0;
  int get countdownNum => _countdownNum;
  set countdownNum(int countdownNum) {
    _countdownNum = countdownNum;
    if (countdownNum > 0) {
      this.startTimer();
    } else {
      this.stopTimer();
    }
  }

  /// 开启定时器
  startTimer() {
    stopTimer();
    _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      print(timer);
      this.countdownNum = this.countdownNum - 1;
      String text = CommonUtil.dealDuration('${this.countdownNum}');
      String downText = text + '后播放器关闭';
      timerDownSubject.value = downText;
      if (this.countdownNum == 0) {
        this.pause();
      }
    });
  }
  /// 关闭定时器
  stopTimer() {
    if (_countdownTimer != null) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
  }
}