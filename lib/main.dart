import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/app.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/base/app_config.dart';

void main() async {
  await AppConfig.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new App(),
      debugShowCheckedModeBanner: false, // 去除debug旗标
      theme: new ThemeData(
          primaryColor: new Color.fromRGBO(255, 255, 255, 1),
          highlightColor: AppConfig.backgroundColor,
          splashColor: AppConfig.backgroundColor,
          hintColor: Colors.grey,
          scaffoldBackgroundColor:new Color.fromRGBO(255, 255, 255, 1), //设置页面背景颜色
//          bottomAppBarColor: new Color.fromRGBO(19, 35, 63, 1), //设置底部导航的背景色
//          backgroundColor: new Color.fromRGBO(19, 35, 63, 1),
//          indicatorColor: new Color.fromRGBO(19, 35, 63, 1),    //设置tab指示器颜色

          primaryIconTheme: new IconThemeData(color: Colors.black),//主要icon样式，如头部返回icon按钮
          iconTheme: new IconThemeData(size: 18.0, color: Colors.white),   //设置icon样式

          textTheme: new TextTheme(
              title: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
              ),
              subtitle: new TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal
              )
          ),
          primaryTextTheme: new TextTheme( //设置文本样式
              title: new TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),

          tabBarTheme: new TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey)
      ),
    );
  }
}