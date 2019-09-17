import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/user.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:flutter_flowermusic/tools/user_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginProvide extends BaseProvide {

  List placeHoderText = ['请输入用户名(至少3位)', '请输入您的邮箱(可选)', '6-12位数字与字母的组合'];
  List titles = ['用户名', '邮箱', '密码'];

  String _userName = '';
  String get userName => _userName;
  set userName(String userName) {
    _userName = userName;
    loginBtnCanClick();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    loginBtnCanClick();
  }

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    loginBtnCanClick();
  }

  /// 按钮是否可以点击
  bool _loginEnable = false;
  bool get loginEnable => _loginEnable;
  set loginEnable(bool loginEnable) {
    _loginEnable = loginEnable;
    notify();
  }

  /// 判断按钮是否可以点击
  loginBtnCanClick() {
    bool emailValue = true;
    if (this.email.length > 0) {
      emailValue = CommonUtil.isEmail(this.email);
    }
    if (this.userName.length >= 3 && CommonUtil.isPassword(this.password) && emailValue) {
      this.loginEnable = true;
    } else {
      this.loginEnable = false;
    }
    print('44444${this.loginEnable}');
//    notifyListeners();
  }

  /// 密码是否是可见的
  bool _passwordVisiable = true;
  bool get passwordVisiable => _passwordVisiable;
  set passwordVisiable(bool passwordVisiable) {
    _passwordVisiable = passwordVisiable;
    notify();
  }

  /// 是否同意注册协议
  bool _agreeProtocol = true;
  bool get agreeProtocol => _agreeProtocol;
  set agreeProtocol(bool agreeProtocol) {
    _agreeProtocol = agreeProtocol;
    notify();
  }

  notify() {
    notifyListeners();
  }


  final MineRepo _repo = MineRepo();
  /// 登录
  Observable login() {
    var body = {
      'userName': this.userName,
      'email': this.email,
      'passWord': this.password
    };
    return _repo
        .login(body)
        .doOnData((result) {
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }

  // 重置密码
  Observable resetPassword() {
    var body = {
      'userName': this.userName,
      'email': this.email,
      'passWord': this.password
    };
    return _repo
        .resetPassword(body)
        .doOnData((result) {
    })
        .doOnError((e, stacktrace) {
    })
        .doOnListen(() {
    })
        .doOnDone(() {
    });
  }
}