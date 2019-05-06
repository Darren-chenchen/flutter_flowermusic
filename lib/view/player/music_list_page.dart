import 'package:flutter/material.dart';
import 'package:flutter_flowermusic/base/app_config.dart';
import 'package:flutter_flowermusic/data/song.dart';
import 'package:flutter_flowermusic/main/tap/opacity_tap_widget.dart';
import 'package:flutter_flowermusic/tools/player_tool.dart';

class MusicListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MusicListState();
  }
}

class MusicListState extends State<MusicListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.black87.withOpacity(0.75),
      body: new Column(
        children: <Widget>[
          new Container(
            height: 160,
            width: 100,
            child: new OpacityTapWidget(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: new Icon(Icons.close, color: Colors.white, size: 36,),
            ),
          ),
          new Expanded(
            child:_buildListView()
          )
        ],
      ),
    );
  }

  Widget _buildListView() {
    return new ListView.builder(
        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.3, 0, 0),
        itemCount: PlayerTools.instance.songArr.length,
        itemBuilder: (context, i) {
          if (PlayerTools.instance.songArr.length > 0) {
            return getRow(PlayerTools.instance.songArr[i], i);
          }
        });
  }

  Widget getRow(Song song, int index) {
    return new Container(
      child: new OpacityTapWidget(
        onTap: () {
          PlayerTools.instance.setSongs(PlayerTools.instance.songArr, index);
          Navigator.of(context).pop();
        },
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              width: MediaQuery.of(context).size.width,
              child: new Text(song.title, style: TextStyle(color: Colors.white),),
            ),
            new Divider(height: 1, color: AppConfig.divider,)
          ],
        ),
      ),
    );
  }
}