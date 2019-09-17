import 'package:flutter_flowermusic/base/const_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class AppTools {
  static String SEARCH_HISTORY_LIST = '_searchHistory_';

  static AppTools _instance;
  static Future<AppTools> get instance async {
    return await getInstance();
  }
  static Future<AppTools> getInstance() async  {
    if (_instance == null) {
      _instance = new AppTools();
      await _instance._init();

    }
    return _instance;
  }
  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }
  static SharedPreferences _spf;

  static bool _beforCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }

  /// 存储搜索关键字
  Future<bool> setSearchKey(String key) {
    if (_beforCheck()) return null;
    var list = this.getHistoryKeys();
    if (list.contains(key)) {
      list.remove(key);
      list.insert(0, key);
    } else {
      list.insert(0, key);
    }
    return _spf.setStringList(ConstConfig.SEARCH_HISTORY_LIST, list);
  }
  /// 获取搜索历史
  List<String> getHistoryKeys() {
    var list = _spf.getStringList(ConstConfig.SEARCH_HISTORY_LIST);
    if (list != null) {
      return list;
    } else {
      return [];
    }
  }

  /// 清空搜索历史
  Future<bool> delectSearchKey() {
    return _spf.setStringList(ConstConfig.SEARCH_HISTORY_LIST, []);
  }

  /// 存储歌曲播放模式
  Future<bool> setMusicMode(int mode) {
    if (_beforCheck()) return null;
    return _spf.setInt(ConstConfig.MUSIC_MODE, mode);
  }

  // 获取数据
  int getMusicMode() {
    var mode = _spf.getInt(ConstConfig.MUSIC_MODE);
    if (mode == null) {
      mode = 0;
    }
    return mode;
  }
}