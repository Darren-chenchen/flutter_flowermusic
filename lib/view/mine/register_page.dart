import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/view/mine/register_protocol_page.dart';
import 'package:flutter_flowermusic/viewmodel/mine/login_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPage extends PageProvideNode {
  LoginProvide provide = LoginProvide();

  RegisterPage() {
    mProviders.provide(Provider<LoginProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _RegisterContentPage(provide);
  }
}

class _RegisterContentPage extends StatefulWidget {
  LoginProvide provide;

  _RegisterContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _RegisterContentState();
  }
}

class _RegisterContentState extends State<_RegisterContentPage> {
  LoginProvide _provide;
  final _subscriptions = CompositeSubscription();

  final _loading = LoadingDialog();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _provide ??= widget.provide;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.lightBlueAccent,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 245, 255, 1),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
              ),
              _setupTop(),
              Padding(
                padding: const EdgeInsets.only(bottom: 57),
              ),
              _setUpFrame(),
              _setupBottom(),
            ],
          ),
        ),
        floatingActionButtonLocation: _MiniStartBottomFloatingActionButtonLocation(),
        floatingActionButton: FloatingActionButton(
            heroTag: 'login',
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("login释放");
    _subscriptions.dispose();
  }

  Widget _setupTop() {
    return Center(
      child: Hero(
        tag: 'bird',
        child: Image.asset(
          'images/bird.png',
          width: 95,
        ),
      ),
    );
  }

  _setUpFrame() {
    return Stack(
      children: [
        Provide<LoginProvide>(
          builder: (BuildContext context, Widget child, LoginProvide value) {
            return Hero(
              tag: 'frame',
              child: ClipPath(
                clipper: _CustomClipper(),
                child: Container(
                  height: 331,
                  width: 302,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(181, 181, 181, 0.16), offset: Offset(0, 10), blurRadius: 6)
                      ]),
                ),
              ),
            );
          },
        ),
        Positioned(
          height: 331,
          width: 302,
          child: Padding(
            padding: const EdgeInsets.only(top: 108.0, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                _setupItem(0, 'name'),
                _setupItem(1, 'email'),
                _setupItem(2, 'pwd'),
                Hero(
                  tag: 'forget',
                  child: Divider(
                    height: 12,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 113,
          width: 76,
          height: 76,
          child: Hero(
            tag: 'avatar',
            child: DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage('images/user.png')),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
            ),
          ),
        ),
        Positioned(
          left: 92,
          bottom: 0,
          width: 119,
          height: 47,
          child: Transform.translate(
            offset: Offset(0, 24),
            child: Hero(
              tag: 'sign',
              child: CupertinoButton(
                pressedOpacity: 0.8,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.all(Radius.circular(34)),
                color: const Color(0xFF6DA2FF),
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _login();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _setupItem(int index, String tag) {
    return Hero(
      tag: tag,
      child: CupertinoTextField(
          obscureText: (index == 2 && _provide.passwordVisiable == false) ? true : false,
          prefix: Icon(
            _provide.placeHolderIcon[index],
            color: const Color(0xFFBED5FF),
            size: 24.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
          clearButtonMode: OverlayVisibilityMode.editing,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: const Color(0xFFBED5FF))),
          ),
          placeholderStyle: TextStyle(color: const Color(0xFFBED5FF)),
          placeholder: _provide.placeHolderText[index],
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
          }),
    );
  }

  Provide<LoginProvide> _setupBottom() {
    return Provide<LoginProvide>(builder: (BuildContext context, Widget child, LoginProvide value) {
      return Hero(
        tag: 'bottom',
        child: Container(
            padding: EdgeInsets.only(top: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: _agree,
                  child: value.agreeProtocol
                      ? Icon(
                          Icons.check_circle,
                          color: AppConfig.primaryColor,
                        )
                      : Icon(
                          Icons.check_circle_outline,
                          color: AppConfig.grayTextColor,
                        ),
                ),
                GestureDetector(
                  onTap: _agree,
                  child: Text('已认真阅读并同意', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ),
                GestureDetector(
                  onTap: _gotoRegiestProticol,
                  child: Text('《注册协议》', style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
                )
              ],
            )),
      );
    });
  }

  _login() {
    if (_provide.agreeProtocol == false) {
      Fluttertoast.showToast(msg: "尚未同意注册协议", gravity: ToastGravity.CENTER);
      return;
    }
    var s = _provide
        .login()
        .doOnListen(() {
          _loading.show(context);
        })
        .doOnCancel(() {})
        .listen((data) {
          _loading.hide(context);
          if (data.success) {
            var res = data.data as Map;

            /// 存储用户信息
            AppConfig.userTools.setUserData(res).then((success) {
              if (success) {
                Fluttertoast.showToast(msg: "登录成功", gravity: ToastGravity.CENTER);
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegiestProtocolPage())).then((value) {});
  }

  _goback(bool logined) {
    Navigator.pop(context, logined);
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 100);
    path.quadraticBezierTo(5, 86, 20, 80);
    path.lineTo(287, 0);
    path.lineTo(307, 0);
    path.lineTo(307, 344);
    path.lineTo(0, 344);
    path.lineTo(0, 100);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _MiniStartBottomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  const _MiniStartBottomFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // We have to offset the FAB by four pixels because the FAB itself _adds_
    // four pixels in every direction in order to have a hit target area of 48
    // pixels in each dimension, despite being a circle of radius 40.
    return Offset(45, scaffoldGeometry.scaffoldSize.height - 150);
  }

  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 2.0;
    // The FAB should sit with a margin between it and the snack bar.
    if (snackBarHeight > 0.0)
      fabY = math.min(fabY, contentBottom - snackBarHeight - fabHeight - kFloatingActionButtonMargin);
    // The FAB should sit with its center in front of the top of the bottom sheet.
    if (bottomSheetHeight > 0.0) fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.miniStartBottom';
}
