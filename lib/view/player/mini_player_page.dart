import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/tools/audio_tool.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';
import 'package:flutter_flowermusic/view/player/full_player_page.dart';
import 'package:flutter_flowermusic/viewmodel/player/player_provide.dart';
import 'package:provide/provide.dart';


class MiniPlayerPage extends PageProvideNode {
  PlayerProvide provide = PlayerProvide();

  MiniPlayerPage() {
    mProviders.provide(Provider<PlayerProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return _MiniPlayerContentPage(provide);
  }
}

class _MiniPlayerContentPage extends StatefulWidget {
  PlayerProvide provide;
  _MiniPlayerContentPage(this.provide);

  @override
  State<StatefulWidget> createState() {
    return _MiniPlayerContentState();
  }
}

class _MiniPlayerContentState extends State<_MiniPlayerContentPage> with TickerProviderStateMixin {

  PlayerProvide _provide;
  Animation<double> animationNeedle;
  Animation<double> animationRecord;
  AnimationController controllerNeedle;
  AnimationController controllerRecord;
  final _rotateTween = new Tween<double>(begin: 0.0, end: -0.02);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

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

    PlayerTools.instance.stateSubject.listen((state) {
      if (state == AudioToolsState.isPlaying) {
        controllerNeedle.forward();
        controllerRecord.forward();
      } else {
        controllerNeedle.reverse();
        controllerRecord.stop(canceled: false);
      }
    });
    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed && PlayerTools.instance.currentState == AudioToolsState.isPlaying) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerNeedle.dispose();
    controllerRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  Provide<PlayerProvide> _buildView() {
    return Provide<PlayerProvide>(
        builder: (BuildContext context, Widget child, PlayerProvide value) {
          return new Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: new Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                new Container(
                    width: 80,
                    height: 90,
                    padding: EdgeInsets.fromLTRB(14, 30, 0, 0),
                    child: new InkWell(
                      onTap: _showFullPlayer,
                      child: new Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          new Image.asset('images/disc.png'),
                          new ClipOval(
                            child: new RotationTransition(
                              turns: _commonTween.animate(animationRecord),
                              alignment: Alignment.center,
                              child: new CachedNetworkImage(
                                width: 35,
                                height: 35,
                                key: Key(_provide.currentSong.imgUrl_s ?? ''),
                                imageUrl: _provide.currentSong.imgUrl_s ?? 'http://www.yishouhaoge.cn:4001/1555069598726-fj_s23.jpg',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => AppConfig.getLoadingPlaceHoder(20.0, 20.0),
                                errorWidget: (context, url, error) => AppConfig.getPlaceHoder(35.0, 35.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
                new Container(
                  width: 80,
                  child: new RotationTransition(
                    alignment: Alignment.topRight,
                    turns: _rotateTween.animate(animationNeedle),
                    child: new Image.asset('images/play_needle2.png', width: 80,height: 46,alignment: Alignment.topRight,),
                  ),
                )
              ],
            ),
          );
        }
    );
  }


  _showFullPlayer() {
    Navigator.push(context, new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return FullPlayerPage();
        },
        transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
          return new SlideTransition(
            position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end:Offset(0.0, 0.0)
            ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn
            )),
            child: child,
          );
        }
    ));
  }
}