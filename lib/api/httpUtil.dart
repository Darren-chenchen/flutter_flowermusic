
import 'package:dio/dio.dart';
import 'package:flutter_flowermusic/base/app_config.dart';

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;

  static HttpUtil getInstance() {
    print('getInstance');
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }
  HttpUtil() {
    dio = new Dio()
      ..options = BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: 30000,
          receiveTimeout: 30000)
      ..interceptors.add(HeaderInterceptor());
//      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

class HeaderInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    final token = AppConfig.userTools.getUserToken();
    if (token != null && token.length > 0) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer' + ' ' + token);
    }
//    if (options.uri.path.indexOf('api/user/advice/Imgs') > 0 || options.uri.path.indexOf('api/user/uploadUserHeader') > 0) { // 上传图片
//      options.headers.putIfAbsent('Content-Type', () => 'multipart/form-data');
//      print('上传图片');
//    } else {
//    }
//    options.headers.putIfAbsent('Content-Type', () => 'application/json;charset=UTF-8');

    return super.onRequest(options);
  }
}

