import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:flutter_flowermusic/view/player/music_list_page.dart';
import 'package:flutter_svg/svg.dart';

class PlayerProvide extends BaseProvide {

  PlayerProvide() {
    PlayerTools.instance.stateSubject.listen((state) {
      setControlls();
    });

    PlayerTools.instance.progressSubject.listen((progress) {
      var pro = '${PlayerTools.instance.currentProgress}';
      this.songProgress = CommonUtil.dealDuration(pro);
    });

    setControlls();
  }

  List _controls = [];
  List get controls => _controls;
  set controls(List controls) {
    _controls = controls;
    notify();
  }

  Song get currentSong => PlayerTools.instance.currentSong;

  /// 歌曲进度
  String _songProgress = '';
  String get songProgress => _songProgress;
  set songProgress(String progress) {
    _songProgress = progress;
    notify();
  }

  /// 歌曲时长
  String songDuration() {
    return CommonUtil.dealDuration('${PlayerTools.instance.duration}');
  }

  /// slider
  double sliderValue() {
    if (PlayerTools.instance.duration == 0) {
      return 0.0;
    }
    var value = (PlayerTools.instance.currentProgress/PlayerTools.instance.duration) ?? 0.0;
    if (value > 1) {
      value = 1.0;
    }
    return value;
  }

  /// seek
  seek(double value) {
    int d = (value * PlayerTools.instance.duration).toInt();
    PlayerTools.instance.seek(d);
  }

  pre() {
    PlayerTools.instance.preAction();
  }
  play() {
    if (PlayerTools.instance.currentState == AudioToolsState.isPlaying) {
      PlayerTools.instance.pause();
    }
    if (PlayerTools.instance.currentState == AudioToolsState.isPaued) {
      PlayerTools.instance.resume();
    }
  }
  next() {
    PlayerTools.instance.nextAction();
  }

  Widget _getModeWidget() {
    return
    PlayerTools.instance.mode == 0 ?
         new SvgPicture.asset("images/ic_spen.svg", width: 28, height: 28):
    PlayerTools.instance.mode == 1 ?
         new SvgPicture.asset("images/ic_rand.svg", width: 28, height: 28):
         new SvgPicture.asset("images/is_single.svg", width: 28, height: 28);
  }

  changeMode() {
    if (PlayerTools.instance.mode == 0) {
      PlayerTools.instance.mode = 1;
      setControlls();
      return;
    }
    if (PlayerTools.instance.mode == 1) {
      PlayerTools.instance.mode = 2;
      setControlls();
      return;
    }
    if (PlayerTools.instance.mode == 2) {
      PlayerTools.instance.mode = 0;
      setControlls();
      return;
    }
  }

  setControlls() {
    this.controls = [
      _getModeWidget(),
      new Icon(Icons.skip_previous, color: Colors.white,size: 27,),
      PlayerTools.instance.currentState == AudioToolsState.isPlaying ? new Icon(Icons.pause_circle_outline, color: Colors.white,size: 46,):new Icon(Icons.play_circle_outline, color: Colors.white,size: 46,),
      new Icon(Icons.skip_next, color: Colors.white,size: 27,),
      new Icon(Icons.menu, color: Colors.white,size: 27,)
    ];
  }

  showMenu(BuildContext context) {
    Navigator.push(context, new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return MusicListPage();
        },
        transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: child,
          );
        }
    ));
  }

  notify() {
    notifyListeners();
  }
}