import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/viewmodel/mine/setting_provide.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SettingPage extends StatelessWidget {

  final provide = SettingProvide();

  @override
  Widget buildContent(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provide,
      child: _SettingContentPage(provide),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildContent(context);
  }
}

class _SettingContentPage extends StatefulWidget {
  SettingProvide provide;

  _SettingContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _SettingContentState();
  }
}

class _SettingContentState extends State<_SettingContentPage> {
  SettingProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _provide ??= widget.provide;

    var s = PlayerTools.instance.timerDownSubject.listen((str) {
      _provide.downText = str;
    });
    _subscriptions.add(s);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置'),
        centerTitle: true,
      ),
      body: _initView(),
    );
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    super.dispose();
    print("设置页面释放");
  }


  Widget _initView() {
    return new Column(
      children: <Widget>[
        _initTimer()
      ],
    );
  }

  Widget _initTimer() {
    return new Container(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text('定时关闭', style: TextStyle(fontSize: 16),),
              new Switch(
                  value: Provider.of<SettingProvide>(context).openTimer,
                  onChanged: (value) {
                    _provide.openTimer = value;
                  })
            ],
          ),
          _provide.openTimer == false ? new Container():new Container(
            child: new Column(
              children: <Widget>[
                new Text(_provide.downText),
                new Slider(
                  activeColor: AppConfig.primaryColor,
                  inactiveColor: AppConfig.backgroundColor,
                  min: 0.0,
                  max: 40,
                  value: _provide.sliderValue,
                  onChanged: (value) {},
                  onChangeEnd: (endValue) {
                    print('onChangeEnd:$endValue');
                    if (endValue > 0) {
                      _provide.sliderValue = endValue;
                    } else {
                      _provide.sliderValue = 1;
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}