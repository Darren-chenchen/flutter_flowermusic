import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/model/mine_respository.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordProvide extends BaseProvide {
  List placeHoderText = ['请输入用户名(至少3位)', '请输入您注册时的邮箱', '6-12位数字与字母的组合'];
  List titles = ['用户名', '邮箱', '新密码'];

  String _userName = '';
  String get userName => _userName;
  set userName(String userName) {
    _userName = userName;
    _loginBtnCanClick();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    _loginBtnCanClick();
  }

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    _loginBtnCanClick();
  }

  /// 按钮是否可以点击
  bool _loginEnable = false;
  bool get loginEnable => _loginEnable;
  set loginEnable(bool loginEnable) {
    _loginEnable = loginEnable;
    notifyListeners();
  }

  /// 判断按钮是否可以点击
  _loginBtnCanClick() {
    bool emailValue = true;
    emailValue = CommonUtil.isEmail(email);
    if (userName.length >= 3 && CommonUtil.isPassword(password) && emailValue) {
      this.loginEnable = true;
    } else {
      this.loginEnable = false;
    }
    notifyListeners();
  }

  /// 密码是否是可见的
  bool _passwordVisiable = true;
  bool get passwordVisiable => _passwordVisiable;
  set passwordVisiable(bool passwordVisiable) {
    _passwordVisiable = passwordVisiable;
    notifyListeners();
  }

  final MineRepo _repo = MineRepo();

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