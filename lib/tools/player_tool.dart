import 'dart:async';
import 'dart:math';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main_provide.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';

class PlayerTools {
  final stateSubject = new BehaviorSubject<AudioToolsState>.seeded(AudioToolsState.isStoped);
  final progressSubject = new BehaviorSubject<int>.seeded(0);
  final timerDownSubject = new BehaviorSubject<String>.seeded('');
  final currentSongSubject = new BehaviorSubject<Song>.seeded(Song());

  AudioTools audio;

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
    // 初始化
    audio = AudioTools();

    audio.stateSubject.listen((state) {
      this.currentState = state;
      this.stateSubject.value = state;
      if (state == AudioToolsState.isEnd) {
        this.nextAction(true);
      }
    });
    audio.progressSubject.listen((progress) {
      this.currentProgress = progress;
      this.progressSubject.value = progress;
    });
    audio.durationSubject.listen((duration) {
      this.duration = duration;
    });
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
    currentSongSubject.value = currentSong;
  }

  int _currentProgress = 0;
  int get currentProgress => _currentProgress;
  set currentProgress(int progress) {
    _currentProgress = progress;
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
  }

  AudioToolsState _currentState = AudioToolsState.isStoped;
  AudioToolsState get currentState => _currentState;
  set currentState(AudioToolsState state) {
    _currentState = state;
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
  Future<int> play(Song song) async {
    this.currentSong = song;
    return audio.play(song);
  }
  /// 暂停
  Future<int> pause() async {
    return audio.pause();

  }
  Future<int> resume() async {
    return audio.resume();

  }
  /// 停止
  Future<int> stop() async {
    return audio.stop();

  }
  /// seek
  Future<int> seek(int value) async {
    return audio.seek(value);
  }
  /// 上一首
  Future<int> preAction() async {

    if (this.mode == 1) { // 随机
      this.currentPlayIndex = Random().nextInt(this.songArr.length - 1);
    } else {
      this.currentPlayIndex -= 1;
      if (this.currentPlayIndex < 0) {
        this.currentPlayIndex = this.songArr.length - 1;
      }
    }

    return this.play(songArr[currentPlayIndex]);
  }
  /// 下一首
  Future<int> nextAction([bool isAutoend = false]) async{
    if (isAutoend && this.mode == 2) {
      return this.play(songArr[currentPlayIndex]);
    }
    if (this.mode == 1) { // 随机
      this.currentPlayIndex = Random().nextInt(this.songArr.length - 1);
    } else {
      this.currentPlayIndex += 1;
      if (this.currentPlayIndex >= this.songArr.length) {
        this.currentPlayIndex = 0;
      }
    }
    return this.play(songArr[currentPlayIndex]);
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