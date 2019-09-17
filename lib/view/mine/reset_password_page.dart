
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/viewmodel/mine/reset_password_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordPage extends StatelessWidget {

  final provide = ResetPasswordProvide();

  @override
  Widget buildContent(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provide,
      child: _ResetPasswordContentPage(provide),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildContent(context);
  }
}

class _ResetPasswordContentPage extends StatefulWidget {
  ResetPasswordProvide provide;

  _ResetPasswordContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordContentState();
  }
}

class _ResetPasswordContentState extends State<_ResetPasswordContentPage> {
  ResetPasswordProvide _provide;

  final _subscriptions = CompositeSubscription();

  final _loading = LoadingDialog();

  final _userTF = TextEditingController();
  final _emailTF = TextEditingController();
  final _pwdTF = TextEditingController();

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
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
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
        new Text('重置密码', style: TextStyle(fontSize: 23),),
        new Container(height: 60,)
      ],
    );
  }

  _setupTextFields() {
    return new Column(
      children: _setupContent(),
    );
  }
  List<Widget> _setupContent() {
    return new List<Widget>.generate(
        3,
            (int index) =>
            _setupItem(index));
  }


  Widget _setupItem(int index) {
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
                  child: Consumer<ResetPasswordProvide>(builder: (build, provide, _) {
                    return TextField(
                        obscureText: (index == 2 &&
                            provide.passwordVisiable == false) ? true : false,
                        style: new TextStyle(color: Colors.black),
                        controller: index == 0 ? _userTF:index == 1 ? _emailTF:_pwdTF,
                        decoration: InputDecoration(
                          hintText: provide.placeHoderText[index],
                          hintStyle: new TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (str) {
                          if (index == 0) {
                            _provide.userName = str;
                            provide.loginEnable = _provide.loginEnable;
                          }
                          if (index == 1) {
                            _provide.email = str;
                            provide.loginEnable = _provide.loginEnable;
                          }
                          if (index == 2) {
                            _provide.password = str;
                            provide.loginEnable = _provide.loginEnable;
                          }
                        });
                  })
              ),

              index == 2 ? _setupEyeOpened() : new Container()
            ],
          ),
          new Divider(height: 1, color: AppConfig.divider)
        ],
      ),
    );
  }


  Widget _setupEyeOpened() {
    print('_setupEyeOpened');
    return Consumer<ResetPasswordProvide>(
        builder: ((build, provide, _) {
          return new GestureDetector(
            onTap: () {
              print(provide.passwordVisiable);
              provide.passwordVisiable =
              !provide.passwordVisiable;
            },
            child: new Icon(
              provide.passwordVisiable
                  ? Icons.remove_red_eye
                  : Icons.panorama_fish_eye,
              color: Colors.black,
            ),
          );
        })
    );
  }


  Widget _setupLoginBtn() {
    print('_setupLoginBtn');
    return new Container(
      height: 48,
      width: MediaQuery.of(context).size.width - 60,
      margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Consumer<ResetPasswordProvide>(builder: (build, provide, _) {
        return new RaisedButton(
          disabledColor: AppConfig.disabledMainColor,
          color: AppConfig.primaryColor,
          onPressed: provide.loginEnable ? _resetPassword : null,
          child: new Text('确 定', style: new TextStyle(color: Colors.white, fontSize: 18)),
        );
      }),
    );
  }

  _resetPassword() {
    var s = _provide.resetPassword().doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
      if (data.success) {
        Fluttertoast.showToast(
            msg: "重置成功"
        );
        Future.delayed(Duration(seconds: 1), () {
          this._goback(true);
        });
      }
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }
  _goback(bool logined) {
    Navigator.pop(context, logined);
  }
}