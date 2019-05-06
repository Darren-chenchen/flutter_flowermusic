
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';


class SettingProvide extends BaseProvide {

  SettingProvide() {
    if (PlayerTools.instance.countdownNum > 0) {
      this.openTimer = true;
    }
  }
  bool _openTimer = false;
  bool get openTimer => _openTimer;
  set openTimer(bool openTimer) {
    _openTimer = openTimer;
    if (openTimer) {
      if (PlayerTools.instance.countdownNum > 0) {
        this.sliderValue = (PlayerTools.instance.countdownNum / 60);
      } else {
        this.sliderValue = 10;
      }
      this.startTimer();
    } else {
      this.stopTimer();
    }
    notify();
  }

  double _sliderValue = 10;
  double get sliderValue => _sliderValue;
  set sliderValue(double sliderValue) {
    _sliderValue = sliderValue;
    PlayerTools.instance.countdownNum = (sliderValue * 60).toInt();
    this.startTimer();
  }

  String _downText = '09:59后播放器关闭';
  String get downText => _downText;
  set downText(String downText) {
    _downText = downText;
    notify();
  }

  /// 开启定时器
  startTimer() {
    PlayerTools.instance.startTimer();
  }
  /// 关闭定时器
  stopTimer() {
    PlayerTools.instance.countdownNum = 0;
  }

  notify() {
    notifyListeners();
  }
}