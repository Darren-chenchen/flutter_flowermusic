
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/viewmodel/mine/reset_password_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordPage extends PageProvideNode {

  ResetPasswordProvide provide = ResetPasswordProvide();

  ResetPasswordPage() {
    mProviders.provide(Provider<ResetPasswordProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _ResetPasswordContentPage(provide);
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
  List<Provide<ResetPasswordProvide>> _setupContent() {
    return new List<Provide<ResetPasswordProvide>>.generate(
        3,
            (int index) =>
            _setupItem(index));
  }


  Provide<ResetPasswordProvide>_setupItem(int index) {
    return Provide<ResetPasswordProvide>(
        builder: (BuildContext context, Widget child, ResetPasswordProvide value) {
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


  Provide<ResetPasswordProvide> _setupEyeOpened() {
    return Provide<ResetPasswordProvide>(
        builder: (BuildContext context, Widget child, ResetPasswordProvide value) {
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


  Provide<ResetPasswordProvide>  _setupLoginBtn() {
    return Provide<ResetPasswordProvide>(
        builder: (BuildContext context, Widget child, ResetPasswordProvide value) {
          return new Container(
            height: 48,
            width: MediaQuery.of(context).size.width - 60,
            margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: new RaisedButton(
              disabledColor: AppConfig.disabledMainColor,
              color: AppConfig.primaryColor,
              onPressed: value.loginEnable ? _resetPassword : null,
              child: new Text('确 定', style: new TextStyle(color: Colors.white,fontSize: 18),),
            ),
          );
        }
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