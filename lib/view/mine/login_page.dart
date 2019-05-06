
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/tools/user_tool.dart';
import 'package:flutter_flowermusic/view/mine/register_protocol_page.dart';
import 'package:flutter_flowermusic/view/mine/reset_password_page.dart';
import 'package:flutter_flowermusic/viewmodel/mine/login_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends PageProvideNode {

  LoginProvide provide = LoginProvide();

  LoginPage() {
    mProviders.provide(Provider<LoginProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _LoginContentPage(provide);
  }
}

class _LoginContentPage extends StatefulWidget {
  LoginProvide provide;

  _LoginContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _LoginContentState();
  }
}

class _LoginContentState extends State<_LoginContentPage> {
  LoginProvide _provide;
  final _subscriptions = CompositeSubscription();

  final _loading = LoadingDialog();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _provide ??= widget.provide;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            _setupBack(),
            _setupTop(),
            _setupTextFields(),
            _setupLoginBtn(),
            _setupResetPwd(),
            _setupBottom(),
            new Container(height: 20,)
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    print("login释放");
    _subscriptions.dispose();
  }

  Widget _setupBack() {
    return new Container(
      height: 160,
      padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: new GestureDetector(
        onTap: () {
          this._goback(false);
        },
        child: new Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 40,),
      ),
    );
  }
  
  Widget _setupTop() {
    return new Column(
      children: <Widget>[
        new Text('请输入你的用户名', style: TextStyle(fontSize: 23),),
        new Text('未注册的用户，登录后即可注册', style: TextStyle(fontSize: 14, color: Colors.grey),),
        new Container(height: 50,)
      ],
    );
  }

  _setupTextFields() {
    return new Column(
      children: _setupContent(),
    );
  }
  List<Provide<LoginProvide>> _setupContent() {
    return new List<Provide<LoginProvide>>.generate(
        3,
            (int index) =>
            _setupItem(index));
  }


  Provide<LoginProvide>_setupItem(int index) {
    return Provide<LoginProvide>(
        builder: (BuildContext context, Widget child, LoginProvide value) {
          return new Container(
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 60,
                      child: new Text(_provide.titles[index], style: TextStyle(fontSize: 16)),
                    ),
                    new Expanded(
                        child: new TextField(
                            obscureText: (index == 2 && _provide.passwordVisiable == false) ? true:false,
                            style: new TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: _provide.placeHoderText[index],
                              hintStyle: new TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (str) {
                              if (index == 0) {
                                _provide.userName = str;
                              }
                              if (index == 1) {
                                _provide.email = str;
                              }
                              if (index == 2) {
                                _provide.password = str;
                              }
                            }
                        )
                    ),

                    index == 2 ? _setupEyeOpened() : new Container()
                  ],
                ),
                new Divider(height: 1, color: AppConfig.divider)
              ],
            ),
          );
        }
    );
  }


  Provide<LoginProvide> _setupEyeOpened() {
    return Provide<LoginProvide>(
        builder: (BuildContext context, Widget child, LoginProvide value) {
          return new GestureDetector(
            onTap: () {
              print(_provide.passwordVisiable);
              _provide.passwordVisiable = !_provide.passwordVisiable;
            },
            child: new Icon(
              _provide.passwordVisiable ? Icons.remove_red_eye:Icons.panorama_fish_eye,
              color: Colors.black,),
          );
        }
    );
  }


  Provide<LoginProvide>  _setupLoginBtn() {
    return Provide<LoginProvide>(
        builder: (BuildContext context, Widget child, LoginProvide value) {
          return new Container(
            height: 48,
            width: MediaQuery.of(context).size.width - 60,
            margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: new RaisedButton(
              disabledColor: AppConfig.disabledMainColor,
              color: AppConfig.primaryColor,
              onPressed: value.loginEnable ? _login : null,
              child: new Text('登 录', style: new TextStyle(color: Colors.white,fontSize: 18),),
            ),
          );
        }
    );
  }

  Widget _setupResetPwd() {
    return new Container(
      padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
      child: new Row(
        children: <Widget>[
          new Text('忘记密码？', style: TextStyle(fontSize: 14, color: Colors.grey)),
          new GestureDetector(
            onTap: () {
              this._resetPwd();
            },
            child: new Text('重置密码', style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
          )
        ],
      ),
    );
  }

  Provide<LoginProvide>  _setupBottom() {
    return Provide<LoginProvide>(
        builder: (BuildContext context, Widget child, LoginProvide value) {
          return new Container(
              height: MediaQuery.of(context).size.height - 560,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new GestureDetector(
                    onTap: _agree,
                    child: value.agreeProtocol ?
                        new Icon(Icons.check_circle, color: AppConfig.primaryColor,)
                        :new Icon(Icons.check_circle_outline, color: AppConfig.grayTextColor,),
                  ),
                  new GestureDetector(
                    onTap: _agree,
                    child: new Text('已认真阅读并同意', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
                  new GestureDetector(
                    onTap: _gotoRegiestProticol,
                    child: new Text('《注册协议》', style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
                  )
                ],
              )
          );
        }
    );
  }

  _login() {
    if (_provide.agreeProtocol == false) {
      Fluttertoast.showToast(
          msg: "尚未同意注册协议",
          gravity: ToastGravity.CENTER
      );
      return;
    }
    var s = _provide.login().doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
      if (data.success) {
        var res = data.data as Map;
        /// 存储用户信息
        AppConfig.userTools.setUserData(res).then((success) {
          if (success) {
            Fluttertoast.showToast(
                msg: "登录成功",
                gravity: ToastGravity.CENTER
            );
            Future.delayed(Duration(seconds: 1), () {
              this._goback(true);
            });
          }
        });
      }
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }
  _agree() {
    _provide.agreeProtocol = !_provide.agreeProtocol;
  }
  _gotoRegiestProticol() {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => RegiestProtocolPage())).then((value) {
    });
  }
  _resetPwd() {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => ResetPasswordPage())).then((value) {
    });
  }
  _goback(bool logined) {
    Navigator.pop(context, logined);
  }
}