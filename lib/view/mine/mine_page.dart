
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/user.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:flutter_flowermusic/viewmodel/mine/mine_provide.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MinePage extends StatefulWidget {

  MinePage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MineContentPage();
  }
}

class _MineContentPage extends State<MinePage> {
  MineProvide _provide = MineProvide();
  final _subscriptions = CompositeSubscription();

  final _loading = LoadingDialog();
  ScrollController _scrollControll;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollControll = ScrollController();

    print("mine===initState");
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: new Scaffold(
        backgroundColor: AppConfig.backgroundColor,
        body: new SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
          controller: _scrollControll,
          child: _setupBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
    print("我的释放");
  }

  Widget _setupBody() {
    return new Column(
      children: <Widget>[
        _setupHeader(),
        new Container(height: 12, color: AppConfig.backgroundColor,),
        new Column(
          children: _setupItems(_provide.colors.length),
        ),
        Selector<MineProvide, User>(
          selector: (_, provide) => provide.userInfo,
          builder: (_, value, child) {
            return value == null ?  new Container(height: 1,) : _setupBottom();
          },
        ),
      ],
    );
  }

  Widget _setupHeader() {
    return new Container(
      height: 260,
      color: AppConfig.primaryColor,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: new Row(
        children: <Widget>[
          Selector<MineProvide, User>(
            selector: (_, provide) => provide.userInfo,
            builder: (_, value, child) {
              return new GestureDetector(
                onTap: () {
                  _clickIcon();
                },
                child: new ClipOval(
                    child: new CachedNetworkImage(
                      width: 90,
                      height: 90,
                      key: Key(value == null ? '':value.userId),
                      imageUrl: value == null ? '':value.userPic ?? '',
                      fit: BoxFit.fill,
                      placeholder: (context, url) => AppConfig.getPlaceHoder(90.0, 90.0),
                      errorWidget: (context, url, error) => AppConfig.getPlaceHoder(90.0, 90.0),
                    )
                ),
              );
            },
          ),
          new Container(width: 8,),
          Selector<MineProvide, User>(
            selector: (_, provide) => provide.userInfo,
            builder: (_, value, child) {
              print('_setupHeader2');
              return new Expanded(
                child: new GestureDetector(
                  onTap: _gotoLogin,
                  child: new Text(value == null ? '您还没有登录':value.userName ?? '',
                    style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
              );
            },
          ),
          Selector<MineProvide, User>(
            selector: (_, provide) => provide.userInfo,
            builder: (_, value, child) {
              print('_setupHeader3');
              return value == null ? new Icon(Icons.keyboard_arrow_right):new Container(height: 1,);
            },
          ),
        ],
      ),
    );
  }

  List<GestureDetector> _setupItems(int count) {
    return new List<GestureDetector>.generate(
        count,
            (int index) =>
                _setupItem(index));
  }

  Widget _setupItem(int index) {
    return new GestureDetector(
      onTap: () {
        _provide.clickCell(index, context);
      },
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, index == 1 ? 12:0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new ClipOval(
                  child: new Container(
                    width: 30,
                    height: 30,
                    color: _provide.colors[index],
                    child: new Icon(_provide.icons[index]),
                  ),
                ),
                new Container(width: 8,),
                new Expanded(
                    child: new Text(_provide.content[index], style: TextStyle(color: Colors.black,fontSize: 16),)
                ),
                new Icon(Icons.keyboard_arrow_right, color: Colors.grey,)
              ],
            ),
            new Container(height: 8,),
            new Divider(height: 1, color: AppConfig.divider,)
          ],
        ),
      ),
    );
  }

  Widget _setupBottom() {
    return Selector<MineProvide, User>(
      selector: (_, provide) => provide.userInfo,
      builder: (_, value, child) {
        print('_setupBottom');
        return value == null ? new Container():new Container(
          height: 48,
          width: MediaQuery.of(context).size.width - 30,
          color: AppConfig.backgroundColor,
          margin: EdgeInsets.fromLTRB(15, 160, 15, 0),
          child: new RaisedButton(
            color: AppConfig.primaryColor,
            onPressed: _loginOut,
            child: new Text('退出登录', style: new TextStyle(color: Colors.white,fontSize: 18),),
          ),
        );
      },
    );
  }

  _loginOut() {
    _provide.loginOut(context);
  }
  _gotoLogin() {
    _provide.gotoLogin(context);
  }
  Future<void> _clickIcon() async {
    if (AppConfig.userTools.getUserData() == null) {
      return;
    }
    CommonUtil.clickIcon(1).then((data) {
      if (data != null) {
        _upload(data);
      }
    });
  }

  _upload(body) {
    var s = _provide.uploadUserHeader(body).doOnListen(() {
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