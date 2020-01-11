import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main/tap/opacity_tap_widget.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/viewmodel/player/player_provide.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class FullPlayerPage extends PageProvideNode {

  PlayerProvide provide = PlayerProvide();

  FullPlayerPage() {
//    mProviders.provide(Provider<PlayerProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _FullPlayerContentPage(provide);
  }
}

class _FullPlayerContentPage extends StatefulWidget {
  PlayerProvide provide;

  _FullPlayerContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _FullPlayerContentState();
  }
}

class _FullPlayerContentState extends State<_FullPlayerContentPage> with TickerProviderStateMixin {

  PlayerProvide _provide;
  Animation<double> animationNeedle;
  Animation<double> animationRecord;
  AnimationController controllerNeedle;
  AnimationController controllerRecord;
  final _rotateTween = new Tween<double>(begin: -0.05, end: 0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  AnimationController ges_controller;
  CurvedAnimation ges_curve;
  Animation<double> ges_animation;

  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provide ??= widget.provide;

    controllerNeedle = new AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    animationNeedle = new CurvedAnimation(parent: controllerNeedle, curve: Curves.linear);

    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord = new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);

    var s = PlayerTools.instance.stateSubject.listen((state) {
      if (state == AudioToolsState.isPlaying) {
        controllerNeedle.forward();
        controllerRecord.forward();
      } else {
        controllerNeedle.reverse();
        controllerRecord.stop(canceled: false);
      }
    });
    _subscriptions.add(s);

    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed && PlayerTools.instance.currentState == AudioToolsState.isPlaying) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });

    ges_controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    ges_curve = new CurvedAnimation(parent: ges_controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    controllerNeedle.dispose();
    controllerRecord.dispose();
    ges_controller.dispose();
    _subscriptions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      builder: (context) => _provide,
      child: new Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        body: _buildGesture(),
      ),
    );
  }

  Widget _buildGesture() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
          return new GestureDetector(
            onVerticalDragUpdate: (offset) {
              value.offsetY += offset.delta.dy;
            },
            onVerticalDragEnd: (offset) {
              if (value.offsetY > MediaQuery.of(context).size.height * 0.4) {
                animationToBottom();
              } else {
                this.animationToTop();
              }
            },
            child: new Transform.translate(
              offset: Offset(0, (value.offsetY >= 0.0 ? value.offsetY:0.0)),
              child: _buildView(),
            ),
          );
        }
    );
  }

  animationToTop() {
    ges_animation = Tween(begin: _provide.offsetY, end: 0.0).animate(ges_curve)
      ..addListener(() {
        _provide.offsetY = ges_animation.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        }
      });
    ges_controller.forward(from: 0);
  }

  animationToBottom() {
    ges_animation = Tween(begin: _provide.offsetY, end: MediaQuery.of(context).size.height).animate(ges_curve)
      ..addListener(() {
        _provide.offsetY = ges_animation.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop();
        }
      });
    ges_controller.forward(from: 0);
  }

  Widget _buildView() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
          return new Container(
            child:  Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new CachedNetworkImage(
                  key: Key(_provide.currentSong.imgUrl ?? ''),
                  imageUrl: _provide.currentSong.imgUrl ?? '',
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 0),
                  placeholder: (context, url) => AppConfig.getPlaceHoder(),
                  errorWidget: (context, url, error) => AppConfig.getPlaceHoder(),
                ),
                _setupContent()
              ],
            ),
          );
        }
    );
  }

  Widget _setupContent() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
          return new Column(
            children: <Widget>[
              _setupTop(),
              _setupMiddle(),
              _setupBottom(),
            ],
          );
        }
    );
  }

  Widget _setupTop() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
      return new SafeArea(
          child: new Row(
            children: <Widget>[
              new Container(
                width: 50,
                child: new OpacityTapWidget(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: new Icon(Icons.close, color: Colors.white,size: 27,),
                ),
              ),
              new Expanded(
                  child: new Text(_provide.currentSong.title ?? '',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,)
              ),
              new Container(
                width: 50,
              ),
            ],
          )
      );
    });
  }

  Widget _setupMiddle() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
          return new Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: new Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: new Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      new Image.asset('images/disc.png'),
                      new ClipOval(
                        child: new RotationTransition(
                          turns: _commonTween.animate(animationRecord),
                          alignment: Alignment.center,
                          child: new CachedNetworkImage(
                            width: 160,
                            height: 160,
                            key: Key(_provide.currentSong.imgUrl_s ?? ''),
                            imageUrl: _provide.currentSong.imgUrl_s ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => AppConfig.getPlaceHoder(160.0, 160.0),
                            errorWidget: (context, url, error) => AppConfig.getPlaceHoder(160.0, 160.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: new RotationTransition(
                    alignment: Alignment.topCenter,
                    turns: _rotateTween.animate(animationNeedle),
                    child: new Image.asset('images/play_needle.png', width: 150,height: 86,),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _setupBottom() {
    return new Expanded(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _setupSlide(),
            _setupControl()
          ],
        )
    );
  }

  Widget _setupSlide() {
    return Consumer<PlayerProvide>(
        builder: (BuildContext context, PlayerProvide value, Widget child) {
          return new Container(
            margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: new Row(
              children: <Widget>[
                new Text(_provide.songProgress, style: TextStyle(color: Colors.white, fontSize: 12),),
                new Expanded(
                    child: Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      value: _provide.sliderValue(),
                      min: 0,
                      max: 1,
                      onChanged: (newValue) {
                        print('onChanged:$newValue');
                      },
                      onChangeStart: (startValue) {
                        print('onChangeStart:$startValue');
                      },
                      onChangeEnd: (endValue) {
                        print('onChangeEnd:$endValue');
                        _provide.seek(endValue);
                      },
                      semanticFormatterCallback: (newValue) {
                        return '${newValue.round()} dollars';
                      },
                    )
                ),
                new Text(_provide.songDuration(), style: TextStyle(color: Colors.white, fontSize: 12),),
              ],
            ),
          );
        }
    );
  }

  Widget _setupControl() {
    return new SafeArea(
        child: new Container(
          height: 60,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _setupItems(),
          ),
        )
    );
  }

  List<OpacityTapWidget> _setupItems() {
    return new List<OpacityTapWidget>.generate(
        5,
            (int index) =>
            _setupItem(index));
  }

  Widget _setupItem(int index) {
    return new OpacityTapWidget(
      onTap: () {
        if (index == 0) {
          _provide.changeMode();
        }
        if (index == 1) {
          _provide.pre();
        }
        if (index == 2) {
          _provide.play();
        }
        if (index == 3) {
          _provide.next();
        }
        if (index == 4) {
          _provide.showMenu(context);
        }
      },
      child: _provide.controls[index],
    );
  }
}