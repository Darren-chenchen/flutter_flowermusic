

import 'base/base2.dart';

class MainProvide extends BaseProvide2 {

  // 工厂模式
  factory MainProvide() =>_getInstance();
  static MainProvide get instance => _getInstance();
  static MainProvide _instance;
  static MainProvide _getInstance() {
    if (_instance == null) {
      _instance = new MainProvide._internal();
    }
    return _instance;
  }

  MainProvide._internal() {
    // 初始化
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notify();
  }

  bool _showMini = false;
  bool get showMini => _showMini;
  set showMini(bool showMini) {
    _showMini = showMini;
    notify();
  }

  notify() {
    notifyListeners();
  }
}