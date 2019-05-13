import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/model/home_repository.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class HomeProvide extends BaseProvide {
  // 页数
  int _page = 0;
  int get page => _page;
  set page(int page) {
    _page = page;
  }

  final subjectMore = new BehaviorSubject<bool>();

  bool _hasMore = false;
  bool get hasMore => _hasMore;
  set hasMore(bool hasMore) {
    _hasMore = hasMore;
    subjectMore.add(hasMore);
  }


  List<Song> _dataArr = [];
  List<Song> get dataArr => _dataArr;
  set dataArr(List<Song> arr) {
    _dataArr = arr;
    this.notify();
  }

  final HomeRepo _repo = HomeRepo();

  notify() {
    notifyListeners();
  }

  setSongs(int index) {
    PlayerTools.instance.setSongs(this.dataArr, index);
  }

  Observable getSongs(bool isRefrsh) {
    isRefrsh ? this.page = 0 : this.page++;
    var query = {
      'page': this.page,
      'pageSize': 30,
      'orderkey': 'imgUrl',
      'sequence': true,
      'searchKey': '',
      'userId': AppConfig.userTools.getUserId()
    };
    return _repo
        .getSongs(query)
        .doOnData((result) {
          if (isRefrsh) {
            this.dataArr.clear();
          }
          var arr = result.data as List;
          this.dataArr.addAll(arr.map((map) => Song.fromJson(map)));

          this.hasMore = result.total > this.dataArr.length;

          this.notify();
    })
        .doOnError((e, stacktrace) {
        })
        .doOnListen(() {
        })
        .doOnDone(() {
        });
  }

  /// 收藏
  Observable collectionSong(String songId) {
    return _repo
        .collectionSong(songId)
        .doOnData((result) {

          int index = this.dataArr.indexWhere((song) {
            return song.id == songId;
          });
          this.dataArr[index].isFav = true;
          this.notify();
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
  /// 取消收藏
  Observable uncollectionSong(String songId) {
    return _repo
        .uncollectionSong(songId)
        .doOnData((result) {

          int index = this.dataArr.indexWhere((song) {
           return song.id == songId;
          });
          this.dataArr[index].isFav = false;
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