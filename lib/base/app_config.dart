import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flowermusic/tools/user_tool.dart';

class AppConfig {
  static const baseUrl = 'http://chenliang.yishouhaoge.cn/';

  static const primaryColor = Color(0xFF5DBE82); //主题色

  static const disabledMainColor = Color.fromRGBO(97, 190, 130, 0.5);
  static const textColor = Color(0xFF333333);
  static const grayTextColor = Color(0xFF71747E);
  static const backgroundColor = Color(0xFFF5F5F8);
  static const divider = Color(0xFFdddddd);

  // 交互相关
  static const platform = const MethodChannel('darren.com.example.flutterFlowermusic/mutual');

  /// Construct a color from a hex code string, of the format #RRGGBB.
  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Widget getPlaceHoder([width, height]) {
    return new Container(
        width: width,
        height: height,
        child: new Image.asset(
          'images/placehoder_img.png',
          fit: BoxFit.cover,
        ));
  }

  static Widget getUserPlaceHoder(width, height) {
    return new Container(width: width, height: height, child: new Image.asset('images/nologin.png'));
  }

  static Widget getLoadingPlaceHoder(width, height) {
    return new SizedBox(width: width, height: height, child: const CircularProgressIndicator(strokeWidth: 2.0));
  }

  //debug:false  release: true
  static const bool inProduction = const bool.fromEnvironment("dart.vm.product");

  static Widget initLoading(bool showEmpty, [String emptyText = '暂无数据']) {
    return new Center(
      child: showEmpty
          ? _initEmpty(emptyText)
          : SizedBox(width: 35.0, height: 35.0, child: const CircularProgressIndicator(strokeWidth: 2.0)),
    );
  }

  static Widget _initEmpty(String emptyText) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
      child: new Column(
        children: <Widget>[
          new Icon(
            Icons.hourglass_empty,
            color: Colors.grey,
            size: 60,
          ),
          new Container(
            height: 10,
          ),
          new Text(emptyText)
        ],
      ),
    );
  }

  static UserTools userTools;

  static init() async {
    userTools = await UserTools.getInstance();
  }
}
