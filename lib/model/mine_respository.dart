import 'package:dio/dio.dart';
import 'package:flutter_flowermusic/api/netUtils.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/base.dart';
import 'package:rxdart/rxdart.dart';

// 网络请求相关
class MineService {
  /// 登录
  Observable<BaseResponse> login(dynamic request) {
    var url = 'api/user/login';
    var response = post(url, body: request, queryParameters: null);
    return response;
  }
  /// 重置密码
  Observable<BaseResponse> resetPassword(dynamic request) {
    var url = 'api/user/resetPassword';
    var response = post(url, body: request, queryParameters: null);
    return response;
  }
  /// 获取注册协议
  Observable<BaseResponse> getProtocol() {
    var url = 'api/user/regiestRoule/get';
    var response = get(url);
    return response;
  }
  /// 收藏列表
  Observable<BaseResponse> favList() {
    var param = {
      'userId': AppConfig.userTools.getUserId(),
      'songType': 3
    };
    var url = 'api/song/collectionSongList';
    var response = get(url, params: param);
    return response;
  }
  /// 取消收藏
  Observable<BaseResponse> uncollectionSong(String songId) {
    var body = {
      'userId': AppConfig.userTools.getUserId(),
      'songId': songId
    };
    var url = 'api/song/uncollectionSong';
    var response = post(url, body: body);
    return response;
  }

  /// 上传头像
  Observable<BaseResponse> uploadUserHeader(FormData body) {
    var param = {
      'userId': AppConfig.userTools.getUserId()
    };
    var url = 'api/user/uploadUserHeader?userId=${AppConfig.userTools.getUserId()}';
    var response = post(url, body: body);
    return response;
  }

  /// 意见反馈
  Observable<BaseResponse> adviceSubmit(body) {
    var url = 'api/user/advice/submit';
    var response = post(url, body: body);
    return response;
  }
  /// 上传意见返回的图片
  Observable<BaseResponse> uploadImg(body) {
    var url = 'api/user/advice/Imgs';
    var response = post(url, body: body);
    return response;
  }
}


class MineRepo {
  final MineService _remote = MineService();

  Observable<BaseResponse> login(dynamic request) {
    return _remote.login(request);
  }

  Observable<BaseResponse> resetPassword(dynamic request) {
    return _remote.resetPassword(request);
  }

  Observable<BaseResponse> getProtocol() {
    return _remote.getProtocol();
  }

  Observable<BaseResponse> favList() {
    return _remote.favList();
  }

  Observable<BaseResponse> uncollectionSong(String songId) {
    return _remote.uncollectionSong(songId);
  }

  Observable<BaseResponse> uploadUserHeader(FormData body) {
    return _remote.uploadUserHeader(body);
  }

  Observable<BaseResponse> adviceSubmit(dynamic body) {
    return _remote.adviceSubmit(body);
  }

  Observable<BaseResponse> uploadImg(dynamic body) {
    return _remote.uploadImg(body);
  }
}