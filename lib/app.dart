
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/base.dart';
import 'package:flutter_flowermusic/main_provide.dart';
import 'package:flutter_flowermusic/view/home/home_page.dart';
import 'package:flutter_flowermusic/view/mine/mine_page.dart';
import 'package:flutter_flowermusic/view/old/old_page.dart';
import 'package:flutter_flowermusic/view/player/mini_player_page.dart';
import 'package:provide/provide.dart';

class App extends PageProvideNode {

  App() {
    mProviders.provide(Provider<MainProvide>.value(MainProvide.instance));
  }
  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _AppContentPage();
  }
}

class _AppContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<_AppContentPage> with TickerProviderStateMixin<_AppContentPage> {

  MainProvide _provide;
  TabController controller;
  HomePage _home = HomePage();
  OldPage _old = OldPage();
  MinePage _mine = MinePage();
  MiniPlayerPage _miniPage = MiniPlayerPage();

  Animation<double> _animationMini;
  AnimationController _miniController;
  final _tranTween = new Tween<double>(begin: 1, end: 0);

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _provide = MainProvide.instance;

    controller = new TabController(length: 3, vsync: this);

    _miniController = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationMini = new CurvedAnimation(parent: _miniController, curve: Curves.linear);
  }

  @override
  void dispose() {
    controller.dispose();
    _miniController.dispose();
    super.dispose();
    print("app释放");
  }

  ontap(int index) {
    _provide.currentIndex = index;
    controller.animateTo(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          alignment: AlignmentDirectional.bottomEnd,
          overflow: Overflow.visible,
          children: <Widget>[
            _initTabBarView(),
            _initMiniPlayer()
          ],
        ),
        bottomNavigationBar: _initBottomNavigationBar()
    );
  }

  Widget _initTabBarView() {
    return new TabBarView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _home,
        _old,
        _mine,
      ],
    );
  }

  Provide<MainProvide> _initMiniPlayer() {
    return Provide<MainProvide>(
        builder: (BuildContext context, Widget child, MainProvide value) {
          return Visibility(
            visible: _provide.showMini,
            child: new FadeTransition(
              opacity: _tranTween.animate(_animationMini),
              child: new Container(
                width: 80,
                height: 110,
                child: _miniPage,
              ),
            ),
          );
        });
  }

  Provide<MainProvide> _initBottomNavigationBar() {
    return Provide<MainProvide>(
        builder: (BuildContext context, Widget child, MainProvide value) {
          return Theme(
              data: new ThemeData(
                  canvasColor: Colors.white, // BottomNavigationBar背景色
                  textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.grey))
              ),
              child: BottomNavigationBar(
                  fixedColor: Colors.black,
                  currentIndex: _provide.currentIndex,
                  onTap: ontap,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    new BottomNavigationBarItem(
                        icon: new Icon(Icons.music_video),
                        title: new Text('推荐')),
                    new BottomNavigationBarItem(
                        icon: new Icon(Icons.music_note),
                        title: new Text('经典')),
                    new BottomNavigationBarItem(
                        icon: new Icon(Icons.people),
                        title: new Text('我的'))
                  ])
          );
        });
  }
}