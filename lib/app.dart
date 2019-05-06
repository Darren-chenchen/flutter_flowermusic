
import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/view/home/home_page.dart';
import 'package:flutter_flowermusic/view/mine/mine_page.dart';
import 'package:flutter_flowermusic/view/old/old_page.dart';
import 'package:flutter_flowermusic/view/player/mini_player_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin<App> {

  TabController controller;
  int _currentIndex = 0;
  HomePage _home = HomePage();
  OldPage _old = OldPage();
  MinePage _mine = MinePage();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    print("app释放");
  }

  ontap(int index) {
    setState(() {
      _currentIndex = index;
    });
    controller.animateTo(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            new TabBarView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _home,
                _old,
                _mine,
              ],
            ),
            new Container(
              width: 80,
              height: 110,
              child: new MiniPlayerPage(),
            )
          ],
        ),
        bottomNavigationBar: Theme(data: new ThemeData(
            canvasColor: Colors.white, // BottomNavigationBar背景色
            textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.grey))
        ),
            child: BottomNavigationBar(
                fixedColor: Colors.black,
                currentIndex: _currentIndex,
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
        )
    );
  }
}