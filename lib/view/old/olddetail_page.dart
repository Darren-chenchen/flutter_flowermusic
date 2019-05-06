import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_html/flutter_html.dart';

class OldDetailPage extends StatefulWidget {

  Song song;

  OldDetailPage({Key key, @required this.song}) : super(key: key);

  @override
  _OldDetailPageState createState() => new _OldDetailPageState(this.song);
}

class _OldDetailPageState extends State<OldDetailPage> {

  final Song _song;

  _OldDetailPageState(this._song) {
  }

  @override
  void dispose() {
    super.dispose();
    print("详情释放");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: new AppBar(
        title: new Text(this._song.title),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Container(
      padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: new ListView.builder(
          itemCount: 1,
          itemBuilder: (context, i) {
            return new Html(data: _song.desc, defaultTextStyle: TextStyle(color: Colors.grey, fontSize: 16, height: 1));
          })
    );
  }
}