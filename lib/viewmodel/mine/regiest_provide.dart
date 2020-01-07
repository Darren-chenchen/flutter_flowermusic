import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/base/base2.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:rxdart/rxdart.dart';

class RegiestProvide extends BaseProvide2 {

  String _protocol = '';
  String get protocol => _protocol;
  set protocol(String protocol) {
    _protocol = protocol;
    notifyListeners();
  }

  final MineRepo _repo = MineRepo();

  // 重置密码
  Observable getProtocol() {
    return _repo
        .getProtocol()
        .doOnData((result) {
          this.protocol = result.data[0]['content'];
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
}