
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/main/dialog/dialog.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';

/// BaseProvide
class BaseProvide with ChangeNotifier {

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
abstract class PageProvideNode extends StatelessWidget {
  /// The values made available to the [child].
  final Providers mProviders = Providers();

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ProviderNode(
      providers: mProviders,
      child: buildContent(context),
    );
  }
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}