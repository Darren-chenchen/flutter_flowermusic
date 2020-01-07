import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/base/base2.dart';
import 'package:flutter_flowermusic/viewmodel/mine/regiest_provide.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
//import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

class RegiestProtocolPage extends PageProvideNode2 {

  RegiestProvide provider = RegiestProvide();

  RegiestProtocolPage() {
//    mProviders.provide(Provider<RegiestProvide>.value(provide));
//  mProviders = provider;
  }

  @override
  Widget buildContent(BuildContext context) {
    return _RegiestProtocolContentPage(provider);
  }

  @override
  BaseProvide2 initProvide() {
    // TODO: implement initProvide
    return provider;
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
    return ChangeNotifierProvider(
      builder: (context) => _provide,
      child: new Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: new AppBar(
          title: new Text('注册协议'),
          centerTitle: true,
          actions: <Widget>[
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Consumer<RegiestProvide> _buildBody() {
    return Consumer<RegiestProvide>(
        builder : (BuildContext context, RegiestProvide value, Widget child) {
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