
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/main_provide.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/utils/common_util.dart';
import 'package:flutter_flowermusic/view/home/comment_page.dart';
import 'package:flutter_flowermusic/viewmodel/home/home_provide.dart';
import "package:flutter_flowermusic/main/refresh/pull_to_refresh.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provide/provide.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends PageProvideNode {

  HomeProvide provide = HomeProvide();

  HomePage() {
    mProviders.provide(Provider<HomeProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _HomeContentPage(provide);
  }
}

class _HomeContentPage extends StatefulWidget {
  HomeProvide provide;

  _HomeContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<_HomeContentPage> with AutomaticKeepAliveClientMixin<_HomeContentPage> {

  final _subscriptions = CompositeSubscription();

  RefreshController _refreshController;
  ScrollController _scrollControll;

  final _loading = LoadingDialog();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  HomeProvide _provide;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = new RefreshController();
    _scrollControll = new ScrollController();
    _provide ??= widget.provide;
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
    return Scaffold(
      appBar: new AppBar(
        title: new Text('推荐歌曲'),
        leading: new IconButton(icon: new Icon(Icons.my_location), onPressed: _pushSaved),
        centerTitle: true,
        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.search), onPressed: _pushSaved),
        ],
      ),
      body: _initView(),
    );
  }

  Provide<HomeProvide> _initView() {
    return Provide<HomeProvide>(
        builder: (BuildContext context, Widget child, HomeProvide value) {
          return _provide.dataArr.length > 0 ? _buildListView() : AppConfig
              .initLoading(false);
        });
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

  _pushSaved() {
    _scrollControll.animateTo((PlayerTools.instance.currentPlayIndex * 70).toDouble(), duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Provide<HomeProvide> _buildListView() {
    return Provide<HomeProvide>(
        builder: (BuildContext context, Widget child, HomeProvide value) {
          return new SmartRefresher(
              child: new ListView.builder(
                  itemCount: value.dataArr.length,
                  controller: _scrollControll,
                  itemBuilder: (context, i) {
                    if (value.dataArr.length > 0) {
                      return getRow(value.dataArr[i], i);
                    }
                  }),
              controller:_refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onHeaderRefresh: _onHeaderRefresh,
              onFooterRefresh: _onFooterRefresh,
              onOffsetChange: _onOffsetCallback,
          );
        }
    );
  }

  Widget getRow(Song song, int index) {
    return new Column(
      children: <Widget>[
        new Container(
          height: 70,
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
                  this._clickMore(song);
                },
                child: new Container(
                  width: 40,
                  height: 70,
                  child: new Icon(Icons.more_horiz, color: Colors.grey,),
                ),
              )
            ],),
          ),),
        song.isExpaned == true ? _setupCellBottom(song) : new Container(height: 0,color: Colors.blue,)
      ],
    );
  }

  Widget _setupCellBottom(Song song) {
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
                  new Icon(song.isFav ? Icons.favorite:Icons.favorite_border, color: song.isFav ? Colors.red:Colors.grey,),
                  new Text('收藏', style: TextStyle(color: Colors.grey,fontSize: 12),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _clickMore(Song song) {
    song.isExpaned = !song.isExpaned;
    _provide.notify();
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
}