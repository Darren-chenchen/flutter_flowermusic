import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/user.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:flutter_flowermusic/view/mine/advice_page.dart';
import 'package:flutter_flowermusic/view/mine/author_page.dart';
import 'package:flutter_flowermusic/view/mine/collection_page.dart';
import 'package:flutter_flowermusic/view/mine/login_page.dart';
import 'package:flutter_flowermusic/view/mine/setting_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class MineProvide extends BaseProvide {
  List content = ['我的收藏', '五星好评', '意见反馈', '设置'];
  List icons = [Icons.favorite_border, Icons.star_border, Icons.email, Icons.settings];
  List colors = [Color(0xFF007aff), Color(0xFFFF7F00), Color(0xFFEEAD0E), Color(0xFFC0FF3E)];

  User _userInfo;
  User get userInfo => _userInfo;
  set userInfo(User userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  MineProvide() {
    this._loginedOrNot();
  }

  final MineRepo _repo = MineRepo();

  _loginedOrNot() {
    var user = AppConfig.userTools.getUserData();
    if (user != null) {
      var userinfo = user as Map<String, dynamic>;
      this.userInfo = User.fromJson(userinfo);
    }
  }

  loginOut(BuildContext context) {
    showAlert(context, title: '确定要退出登录？', onlyPositive: false)
        .then((value) {
      if (value) {
        AppConfig.userTools.delectUserData().then((value) {
          if (value) {
            this.userInfo = null;
          }
        });
      }
    });
  }

  gotoLogin(BuildContext context) {
    if (this.userInfo != null) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => LoginPage())).then((value) {
      if (value) {
        this._loginedOrNot();
      }
    });
  }

  clickCell(int index, BuildContext context) {
    if (index == 0) {
      bool logined = _showLoginText();
      if (logined) {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => CollectionPage()));
      }
    }
    if (index == 1) {
      try{
         AppConfig.platform.invokeMethod('GoodComment');
      } catch(e){
      }
    }

    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => AdvicePage()));
    }

    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => SettingPage()));
    }
  }

  bool _showLoginText() {
    if (this.userInfo == null) {
      Fluttertoast.showToast(
          msg: "请先登录",
          gravity: ToastGravity.CENTER
      );
      return false;
    } else {
      return true;
    }
  }

  // 上传头像
  Observable uploadUserHeader(FormData body) {
    return _repo
        .uploadUserHeader(body)
        .doOnData((result) {
      if (result.success) {
        // 更新用户信息
        AppConfig.userTools.updateUserIcon(result.data['imageUrl']).then((user) {
          this.userInfo = User.fromJson(user);

          Fluttertoast.showToast(
            msg: "上传成功",
            gravity: ToastGravity.CENTER
          );
        });
      }
    })
        .doOnError((e, stacktrace) {
          Fluttertoast.showToast(
              msg: "上传失败",
              gravity: ToastGravity.CENTER
          );
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
}