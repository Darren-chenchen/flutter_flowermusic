
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:rxdart/rxdart.dart';

enum AudioToolsState {
  beginPlay,
  isPlaying,
  isPaued,
  isCacheing,
  isStoped,
  isEnd,
  isError
}

class AudioTools {
  AudioPlayer audioPlayer = new AudioPlayer();
  final stateSubject = new BehaviorSubject<AudioToolsState>.seeded(AudioToolsState.isStoped);
  final progressSubject = new BehaviorSubject<int>.seeded(0);
  final durationSubject = new BehaviorSubject<int>.seeded(0);

  AudioTools() {
    AudioPlayer.logEnabled = false;
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      this.durationSubject.value = d.inSeconds;
    });
    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      this.progressSubject.value = p.inSeconds;
      if (p.inSeconds < 2) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          setPlayerState(AudioToolsState.isPlaying);
        });
      }
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      if (s == AudioPlayerState.PAUSED) {
        setPlayerState(AudioToolsState.isPaued);
      }
      if (s == AudioPlayerState.STOPPED) {
        setPlayerState(AudioToolsState.isStoped);
      }
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      print('onPlayerCompletion');
      setPlayerState(AudioToolsState.isEnd);
    });
    audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setPlayerState(AudioToolsState.isError);
    });
  }
  /// 播放
  Future<int> play(Song song) async {
    if (audioPlayer.state != AudioPlayerState.STOPPED) {
      await audioPlayer.stop();
    }
    var encoded = Uri.encodeFull(song.songUrl);
    audioPlayer.play(encoded).then((value) {
      if (value == 1) {
        setPlayerState(AudioToolsState.beginPlay);
      } else {
      }
      return value;
    });
  }
  /// 暂停
  Future<int> pause() async {
    audioPlayer.pause().then((value) {
      if (value == 1) {

      } else {

      }
      return value;
    });
  }
  Future<int> seek(int value) async {
    Duration d = Duration(seconds: value);
    audioPlayer.seek(d).then((value) {
      if (value == 1) {

      } else {

      }
      return value;
    });
  }
  /// resume
  Future<int> resume() async {
    audioPlayer.resume().then((value) {
      if (value == 1) {
        setPlayerState(AudioToolsState.isPlaying);
      } else {

      }
      return value;
    });
  }
  /// 停止
  Future<int> stop() async {
    audioPlayer.stop().then((value) {
      if (value == 1) {

      } else {

      }
      return value;
    });
  }

  setPlayerState(AudioToolsState state) {
    stateSubject.value = state;
  }
}