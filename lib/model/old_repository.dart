import 'package:flutter_flowermusic/api/netUtils.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/base.dart';
import 'package:rxdart/rxdart.dart';

// 网络请求相关
class OldService {
  /// 获取列表
  Observable<BaseResponse> getSongs(dynamic request, Map<String, dynamic> query) {
    var url = 'api/oldsong/list';
    var response = post(url, body: request, queryParameters: query);
    return response;
  }

  /// 收藏歌曲
  Observable<BaseResponse> collectionSong(String songId) {
    var body = {
      'userId': AppConfig.userTools.getUserId(),
      'songId': songId,
      'songType': 1
    };
    var url = 'api/song/collectionSong';
    var response = post(url, body: body, queryParameters: null);
    return response;
  }
  /// 取消收藏
  Observable<BaseResponse> uncollectionSong(String songId) {
    var body = {
      'userId': AppConfig.userTools.getUserId(),
      'songId': songId
    };
    var url = 'api/song/uncollectionSong';
    var response = post(url, body: body, queryParameters: null);
    return response;
  }
}


class OldRepo {
  final OldService _remote = OldService();

  Observable<BaseResponse> getSongs(Map<String, dynamic> query) {
    return _remote.getSongs(null, query);
  }

  Observable<BaseResponse> collectionSong(String songId) {
    return _remote.collectionSong(songId);
  }
  Observable<BaseResponse> uncollectionSong(String songId) {
    return _remote.uncollectionSong(songId);
  }
}