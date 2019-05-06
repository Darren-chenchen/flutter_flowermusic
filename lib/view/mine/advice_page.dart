import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:flutter_flowermusic/viewmodel/mine/advice_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class AdvicePage extends PageProvideNode {

  AdviceProvide provide = AdviceProvide();

  AdvicePage() {
    mProviders.provide(Provider<AdviceProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _AdviceContentPage(provide);
  }
}

class _AdviceContentPage extends StatefulWidget {
  AdviceProvide provide;

  _AdviceContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _AdviceContentState();
  }
}

class _AdviceContentState extends State<_AdviceContentPage> {
  AdviceProvide _provide;

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
    return new Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: new AppBar(
        title: new Text('意见反馈'),
        centerTitle: true
      ),
      body: _initView(),
    );
  }

  Provide<AdviceProvide> _initView() {
    return Provide<AdviceProvide>(
        builder: (BuildContext context, Widget child, AdviceProvide value) {
          return new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                _setupAdviceContent(),
                _setupImages(),
                _setupPhone(),
                _setupBottom()
              ],
            ),
          );
        });
  }

  Widget _setupAdviceContent() {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          alignment: Alignment.centerLeft,
          height: 44,
          child: new Text('问题和意见'),
        ),
        new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          color: Colors.white,
          child: new TextField(
            maxLines: 4,
            maxLength: 200,
            style: new TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入10个字以上的问题描述',
              hintStyle: new TextStyle(color: Colors.grey),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (str) {
              _provide.advice = str;
            },
            onSubmitted: (str) {
            },
          ),
        )
      ],
    );
  }

  Widget _setupImages() {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          alignment: Alignment.centerLeft,
          height: 44,
          child: new Text('图片(提供问题截图)'),
        ),
        new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          height: 30,
          alignment: Alignment.centerRight,
          color: Colors.white,
          child: new Text('${_provide.imgArr.length}/3',style: TextStyle(fontSize: 12),),
        ),
        new Container(
          height: 80,
          color: Colors.white,
          child: new Row(
            children: <Widget>[
              new GestureDetector(
                onTap: _clickIcon,
                child: new Icon(Icons.add_box, color: AppConfig.backgroundColor,size: 70,),
              ),
              new Expanded(
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: _setupItems(),
                  )
              )
            ],
          ),
        )
      ],
    );
  }

  List<Provide<AdviceProvide>> _setupItems() {
    return new List<Provide<AdviceProvide>>.generate(
        _provide.imgArr.length,
            (int index) =>
            _setupItem(index)
    );
  }

  Provide<AdviceProvide> _setupItem(int index) {
    return Provide<AdviceProvide>(
        builder: (BuildContext context, Widget child, AdviceProvide value)
    {
      return new GestureDetector(
        onTap: () {

        },
        child: new Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: new Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              new Image.network(_provide.imgArr[index]),
              new GestureDetector(
                onTap: () {
                  _provide.imgArr.removeAt(index);
                  _provide.notify();
                },
                child: new Icon(Icons.close, color: Colors.white,),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _setupPhone() {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          alignment: Alignment.centerLeft,
          height: 44,
          child: new Text('联系方式'),
        ),
        new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          color: Colors.white,
          child: new TextField(
            keyboardType: TextInputType.number,
            style: new TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入联系方式',
              hintStyle: new TextStyle(color: Colors.grey),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (str) {
              _provide.contact = str;
            },
            onSubmitted: (str) {
            },
          ),
        )
      ],
    );
  }

  Widget _setupBottom() {
    return new Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: new RaisedButton(
        color: AppConfig.primaryColor,
        onPressed: _submit,
        child: new Text('确 定', style: new TextStyle(color: Colors.white,fontSize: 18),),
      ),
    );
  }

  _submit() {
    if (_provide.advice.length < 10) {
      Fluttertoast.showToast(
          msg: "至少输入10个字的描述",
          gravity: ToastGravity.CENTER
      );
      return;
    }
    var s = _provide.adviceSubmit().doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }

  Future<void> _clickIcon() async {
    if (_provide.imgArr.length >= 3) {
      Fluttertoast.showToast(
          msg: "最多上传3张",
          gravity: ToastGravity.CENTER
      );
      return;
    }
    CommonUtil.clickIcon(3 - _provide.imgArr.length).then((data) {
      if (data != null) {
        _upload(data);
      }
    });
  }
  _upload(body) {
    var s = _provide.uploadImages(body).doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }
}