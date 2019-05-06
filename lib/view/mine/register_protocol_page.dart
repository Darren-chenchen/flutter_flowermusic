import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/viewmodel/mine/regiest_provide.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class RegiestProtocolPage extends PageProvideNode {

  RegiestProvide provide = RegiestProvide();

  RegiestProtocolPage() {
    mProviders.provide(Provider<RegiestProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _RegiestProtocolContentPage(provide);
  }
}

class _RegiestProtocolContentPage extends StatefulWidget {
  RegiestProvide provide;

  _RegiestProtocolContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _RegiestProtocolContentState();
  }
}

class _RegiestProtocolContentState extends State<_RegiestProtocolContentPage> {

  RegiestProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provide ??= widget.provide;
    _loadData();
  }
  _loadData() {
    var s = _provide.getProtocol().doOnListen(() {
    }).doOnCancel(() {
    }).listen((data) {
    }, onError: (e) {
    });
    _subscriptions.add(s);
  }
  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: new AppBar(
        title: new Text('注册协议'),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: _buildBody(),
    );
  }

  Provide<RegiestProvide> _buildBody() {
    return Provide<RegiestProvide>(
        builder: (BuildContext context, Widget child, RegiestProvide value) {
          return new Container(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: new ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, i) {
                    return new Html(data: value.protocol, defaultTextStyle: TextStyle(color: Colors.grey, fontSize: 16, height: 1));
                  })
          );
        }
    );
  }
}