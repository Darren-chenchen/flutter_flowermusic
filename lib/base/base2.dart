
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:flutter_flowermusic/viewmodel/home/home_provide.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// BaseProvide
class BaseProvide2 with ChangeNotifier {

  CompositeSubscription compositeSubscription = CompositeSubscription();


  /// add [StreamSubscription] to [compositeSubscription]
  ///
  /// 在 [dispose]的时候能进行取消
  addSubscription(StreamSubscription subscription){
    compositeSubscription.add(subscription);
  }

  @override
  void dispose() {
    super.dispose();
    compositeSubscription.dispose();
  }
}

/// page的基类 [PageProvideNode]
///
/// 隐藏了 [ProviderNode] 的调用
abstract class PageProvideNode2 extends StatelessWidget {
  /// The values made available to the [child].
  HomeProvide mProviders = HomeProvide();

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {

    return buildContent(context);
  }
}

abstract class BaseState2<T extends StatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}