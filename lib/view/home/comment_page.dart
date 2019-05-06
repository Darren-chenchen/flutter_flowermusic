import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/data/comment.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/main/refresh/smart_refresher.dart';
import 'package:flutter_flowermusic/viewmodel/home/comment_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class CommentPage extends PageProvideNode {

  CommentProvide provide = CommentProvide();

  CommentPage(Song song) {
    provide.song = song;
    mProviders.provide(Provider <CommentProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _CommentContentPage(provide);
  }
}

class _CommentContentPage extends StatefulWidget {
  CommentProvide provide;

  _CommentContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _CommentContentState();
  }
}

class _CommentContentState extends State<_CommentContentPage> {

  final _subscriptions = CompositeSubscription();

  RefreshController _refreshController;

  final _loading = LoadingDialog();

  CommentProvide _provide;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = new RefreshController();
    _provide ??= widget.provide;
    _loadData();
    _provide.subjectMore.listen((hasMore) {
      if (hasMore) {
        _refreshController.sendBack(false, RefreshStatus.init);
      } else {
        if (_provide.dataArr.length > 0) {
          _refreshController.sendBack(false, RefreshStatus.noMore);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_provide.song.title),
        centerTitle: true
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(child: _initView(),),
          _buildBottomView()
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
  }

  Provide<CommentProvide> _initView() {
    return Provide<CommentProvide>(
        builder: (BuildContext context, Widget child, CommentProvide value) {
          return _provide.dataArr.length > 0 ? _buildListView() : AppConfig.initLoading(_provide.showEmpty, '暂无评论，来发表第一个评论吧');
        });
  }

  _loadData([bool isRefresh = true]) {
    var s = _provide.commentList(isRefresh).doOnListen(() {
    }).doOnCancel(() {
    }).listen((data) {
      if (isRefresh) {
        _refreshController.sendBack(true, RefreshStatus.idle);
      }
    }, onError: (e) {
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

  Widget _buildListView() {
    return new SmartRefresher(
      child: new ListView.builder(
          itemCount: _provide.dataArr.length,
          itemBuilder: (context, i) {
            if (_provide.dataArr.length > 0) {
              return getRow(_provide.dataArr[i]);
            }
          }),
      controller:_refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onHeaderRefresh: _onHeaderRefresh,
      onFooterRefresh: _onFooterRefresh,
    );
  }

  Widget getRow(Comment comment) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: new Row(
            children: <Widget>[
              new ClipOval(
                child: new CachedNetworkImage(
                  width: 60,
                  height: 60,
                  key: Key(comment.user.userPic),
                  imageUrl: comment.user.userPic ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => AppConfig.getUserPlaceHoder(60.0, 60.0),
                  errorWidget: (context, url, error) => AppConfig.getUserPlaceHoder(60.0, 60.0),
                ),
              ),
              new Container(width: 8,),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(comment.user.userName),
                    new Container(height: 8,),
                    new Text(comment.user.creatDateStr)
                  ],
                ),
              ),
              new GestureDetector(
                onTap: () {
                  this._niceAdd(comment);
                },
                child: new Row(
                  children: <Widget>[
                    new Text('${comment.niceCount}'),
                    new Container(width: 5,),
                    new Icon(Icons.thumb_up, color: Colors.grey,)
                  ],
                ),
              )
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: new Text(comment.content),
        )
      ],
    );
  }

  _niceAdd(Comment comment) {
    var s = _provide.niceComment(comment.id).doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }

  Widget _buildBottomView() {
    return new Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: new SafeArea(
          child: new TextField(
              maxLines: 2,
              textInputAction: TextInputAction.done,
              style: new TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: '请输入评论内容',
                hintStyle: new TextStyle(color: Colors.grey),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (str) {
              },
              onSubmitted: (str) {
                _submit(str);
              },
          )
      ),
    );
  }

  _submit(String content) {
    if (AppConfig.userTools.getUserData() == null) {
      Fluttertoast.showToast(
          msg: "请先登录",
          gravity: ToastGravity.CENTER
      );
      return;
    }
    var s = _provide.sendComment(content).doOnListen(() {
      _loading.show(context);
    }).doOnCancel(() {
    }).listen((data) {
      _loading.hide(context);
      _loadData(true);
      Fluttertoast.showToast(
          msg: "评论成功",
          gravity: ToastGravity.CENTER
      );
    }, onError: (e) {
      _loading.hide(context);
    });
    _subscriptions.add(s);
  }
}