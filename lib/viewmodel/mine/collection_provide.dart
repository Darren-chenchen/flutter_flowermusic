import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class CollectionProvide extends BaseProvide {

  final MineRepo _repo = MineRepo();

  List<Song> _dataArr = [];
  List<Song> get dataArr => _dataArr;
  set dataArr(List<Song> arr) {
    _dataArr = arr;
    this.notify();
  }

  bool _showEmpty = false;
  bool get showEmpty => _showEmpty;
  set showEmpty(bool showEmpty) {
    _showEmpty = showEmpty;
  }

  notify() {
    notifyListeners();
  }

  Observable favList() {
    return _repo
        .favList()
        .doOnData((result) {
      this.dataArr.clear();
      var arr = result.data as List;
      this.dataArr.addAll(arr.map((map) => Song.fromJson(map)));
      this.notify();
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  Observable uncollectionSong(String songId) {
    return _repo
        .uncollectionSong(songId)
        .doOnData((result) {
      int index = this.dataArr.indexWhere((song) {
        return song.id == songId;
      });
      this.dataArr.removeAt(index);
      if (this.dataArr.length == 0) {
        this.showEmpty = true;
      }

      this.notify();

      Fluttertoast.showToast(
          msg: "取消收藏成功",
          gravity: ToastGravity.CENTER
      );
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
}