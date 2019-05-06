
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/comment.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/model/home_repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentProvide extends BaseProvide {
  Song _song;
  Song get song => _song;
  set song(Song song) {
    _song = song;
  }
  final HomeRepo _repo = HomeRepo();

  // 页数
  int _page = 0;
  int get page => _page;
  set page(int page) {
    _page = page;
  }

  final subjectMore = new BehaviorSubject<bool>.seeded(false);

  bool _hasMore = false;
  bool get hasMore => _hasMore;
  set hasMore(bool hasMore) {
    _hasMore = hasMore;
    subjectMore.value = hasMore;
  }

  List<Comment> _dataArr = [];
  List<Comment> get dataArr => _dataArr;
  set dataArr(List<Comment> arr) {
    _dataArr = arr;
    this.notify();
  }

  bool _showEmpty = false;
  bool get showEmpty => _showEmpty;
  set showEmpty(bool showEmpty) {
    _showEmpty = showEmpty;
  }

  /// 评论列表
  Observable commentList(bool isRefrsh) {
    isRefrsh ? this.page = 0 : this.page++;
    return _repo
        .commentList(this.page, song.id)
        .doOnData((result) {
      if (isRefrsh) {
        this.dataArr.clear();
      }
      var arr = result.data as List;
      this.dataArr.addAll(arr.map((map) => Comment.fromJson(map)));

      this.hasMore = result.total > this.dataArr.length;
      if (this.dataArr.length == 0) {
        this.showEmpty = true;
      }

      this.notify();
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  /// 发表评论
  Observable sendComment(String comment) {
    return _repo
        .sendComment(comment, song.id)
        .doOnData((result) {
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  Observable niceComment(String commentId) {
    return _repo
        .niceComment(commentId)
        .doOnData((result) {

      int index = this.dataArr.indexWhere((song) {
        return song.id == commentId;
      });
      this.dataArr[index].niceCount = this.dataArr[index].niceCount + 1;
      this.notify();
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  notify() {
    notifyListeners();
  }
}