import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorPage extends StatefulWidget {

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于作者'),
      ),
      body: Stack(
        children: <Widget>[
          new WebView(
            initialUrl: 'http://www.darrenblog.cn', // 加载的url
            onWebViewCreated: (WebViewController web) {
              // webview 创建调用，
              web.canGoBack().then((res){
                print(res); // 是否能返回上一级
              });
              web.currentUrl().then((url){
                print(url);// 返回当前url
              });
              web.canGoForward().then((res){
                print(res); //是否能前进
              });
            },
            onPageFinished: (String value) {
              // webview 页面加载调用
              print('webview 页面加载调用onPageFinished');
              print(value);
            },
          )
        ],
      ),
    );
  }
}