
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:flutter_flowermusic/view/home/comment_page.dart';
import 'package:flutter_flowermusic/viewmodel/home/home_provide.dart';
import "package:flutter_flowermusic/main/refresh/pull_to_refresh.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {

  HomePage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeContentPage();
  }
}

class _HomeContentPage extends State<HomePage> {

  final _subscriptions = CompositeSubscription();

  RefreshController _refreshController;
  ScrollController _scrollControll;

  final _loading = LoadingDialog();

  final _cellHeight = 80.0;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  HomeProvide _provide = HomeProvide();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = new RefreshController();
    _scrollControll = new ScrollController();
    _loadData();
    _provide.subjectMore.listen((hasMore) {
      print("_provide.subjectMore.listen${hasMore}");
      if (hasMore) {
        _refreshController.sendBack(false, RefreshStatus.init);
      } else {
        if (_provide.dataArr.length > 0) {
          _refreshController.sendBack(false, RefreshStatus.noMore);
        }
      }
    });
    print("首页--initState");
  }

  @override
  void dispose() {
    super.dispose();
    print("首页释放");
    _subscriptions.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('home-build(BuildContext context)');
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('推荐歌曲'),
          leading: new IconButton(icon: new Icon(Icons.my_location), onPressed: _pushSaved),
          centerTitle: true,
          actions: <Widget>[
          ],
        ),
        body: _initView(),
      ),
    );
  }

  Widget _initView() {
    return Consumer<HomeProvide>(builder: (build, provide, _) {
      print('Consumer-initView');
      return _provide.dataArr.length > 0 ? _buildListView() : AppConfig
          .initLoading(false);
    },);
  }

  _pushSaved() {
    _scrollControll.animateTo((PlayerTools.instance.currentPlayIndex * 70).toDouble(), duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Widget _buildListView() {
    return new Column(
      children: <Widget>[
        Consumer<HomeProvide>(builder: (build, provide, _) {
          print('Consumer1');
          return new Text('${_provide.count}---该页面验证Consumer，点击cell上的图标展开一个cell，观察控制台的打印情况，结论：只要发送通知后使用Consumer的部分全部都会重绘，再其他页面我会使用Selector来验证局部的刷新');
        },),
        new Expanded(
            child: new SmartRefresher(
              child: new ListView.builder(
                  itemCount: _provide.dataArr.length,
                  controller: _scrollControll,
                  itemBuilder: (context, i) {
                    if (_provide.dataArr.length > 0) {
                      return getRow(_provide.dataArr[i], i);
                    }
                  }),
              controller:_refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onHeaderRefresh: _onHeaderRefresh,
              onFooterRefresh: _onFooterRefresh,
              onOffsetChange: _onOffsetCallback,
            )
        )]);
  }

  Widget getRow(Song song, int index) {
    return Consumer<HomeProvide>(builder: (build, provide, _) {
      print('Consumer--getRow${index}');

    return new Column(
      children: <Widget>[
        new Container(
          height: _cellHeight,
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: new InkWell(
            onTap: () {
              _provide.setSongs(index);
            },
            child: new Row(children: <Widget>[
              new CachedNetworkImage(
                width: 70,
                height: 70,
                key: Key(song.imgUrl_s),
                imageUrl: song.imgUrl_s,
                fit: BoxFit.cover,
                placeholder: (context, url) => AppConfig.getPlaceHoder(70.0, 70.0),
                errorWidget: (context, url, error) => AppConfig.getPlaceHoder(70.0, 70.0),
              ),
              new Container(
                width: 8,
              ),
              new Expanded(child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(height: 4,),
                  new Text(song.title, style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                  new Container(height: 8,),
                  new Text(song.duration != '' ? ' 时长：' + CommonUtil.dealDuration(song.duration):'', style: TextStyle(color: Colors.grey, fontSize: 12),textAlign: TextAlign.left)
                ],)),
              new InkWell(
                onTap: () {
                  _provide.count = index;
                  _provide.dataArr[index].isExpaned = !provide.dataArr[index].isExpaned;
                },
                child: new Container(
                  width: 40,
                    height: 70,
                    child: new Icon(Icons.more_horiz, color: Colors.grey,),
                  ),
                )
              ],),
            ),),
          _provide.dataArr[index].isExpaned == true ? _setupCellBottom(song, index) : new Container(height: 0,color: Colors.blue,)
        ],
      );
    },);
  }

  Widget _setupCellBottom(Song song, int index) {
    return new Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              this._clicCommon(song);
            },
            child: new Container(
              width: 50,
              child: new Column(
                children: <Widget>[
                  new Icon(Icons.comment, color: Colors.grey,),
                  new Text('评论', style: TextStyle(color: Colors.grey,fontSize: 12),)
                ],
              ),
            ),
          ),
          new GestureDetector(
            onTap: () {
              this._clicShare(song);
            },
            child: new Container(
              width: 50,
              child: new Column(
                children: <Widget>[
                  new Icon(Icons.share, color: Colors.grey,),
                  new Text('分享', style: TextStyle(color: Colors.grey,fontSize: 12),)
                ],
              ),
            ),
          ),
          new GestureDetector(
            onTap: () {
              this._clicFav(song);
            },
            child: new Container(
              width: 50,
              child: new Column(
                children: <Widget>[
                  Consumer<HomeProvide>(builder: (build, provide, _) {
                    print('Consumer-fav');
                    return new Icon(_provide.dataArr[index].isFav ? Icons.favorite:Icons.favorite_border, color: _provide.dataArr[index].isFav ? Colors.red:Colors.grey,);
                  },),
                  new Text('收藏', style: TextStyle(color: Colors.grey,fontSize: 12),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _clicCommon(Song song) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => CommentPage(song))).then((value) {
    });
  }
  _clicShare(Song song) {
    try{
      AppConfig.platform.invokeMethod('share', Song.toJson(song));
    } catch(e){
    }
  }
  _clicFav(Song song) {
    if (AppConfig.userTools.getUserData() == null) {
      Fluttertoast.showToast(
          msg: "请先登录",
          gravity: ToastGravity.CENTER
      );
      return;
    }
    if (song.isFav) {
      showAlert(context, title: '确定要取消收藏？', onlyPositive: false)
          .then((value) {
        if (value) {
          this._uncollectionSong(song.id);
        }
      });
    } else {
      this._collectionSong(song.id);
    }
  }
  _loadData([bool isRefresh = true]) {
    var s = _provide.getSongs(isRefresh).doOnListen(() {
    }).doOnCancel(() {
    }).listen((data) {
      if (isRefresh) {
        _refreshController.sendBack(true, RefreshStatus.idle);
      }
    }, onError: (e) {
    });
    _subscriptions.add(s);
  }

  _collectionSong(String songId) {
    var s = _provide.collectionSong(songId).doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }

  _uncollectionSong(String songId) {
    var s = _provide.uncollectionSong(songId).doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }

  _onHeaderRefresh() {
    _loadData();
  }
  _onFooterRefresh() {
    if (_provide.hasMore) {
      _loadData(false);
    }
  }
  _onOffsetCallback(bool up, double offset) {
  }
}