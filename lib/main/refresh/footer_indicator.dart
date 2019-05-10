
import 'package:flutter/material.dart' hide RefreshIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_flowermusic/main/refresh/smart_refresher.dart';

class FooterIndicator extends Indicator {
  final String releaseText,
      idleText,
      refreshingText,
      completeText,
      failedText,
      noDataText;

  final Widget releaseIcon,
      refreshingIcon,
      completeIcon,
      failedIcon,
      noMoreIcon;

  final double height;

  final double spacing;

  final TextStyle textStyle;

  const FooterIndicator( {
    @required RefreshStatus mode = RefreshStatus.init,
    Key key,
    this.textStyle: const TextStyle(color: const Color(0xff555555)),
    this.refreshingText: '加载中...',
    this.noDataText: '没有更多数据了',
    this.height: 60.0,
    this.releaseText: '',
    this.completeText: '',
    this.noMoreIcon: const Icon(Icons.clear, color: Colors.grey),
    this.failedText: '加载失败',
    this.idleText: '加载中...',
    this.spacing: 15.0,
    this.refreshingIcon: const CircularProgressIndicator(strokeWidth: 2.0),
    this.failedIcon: const Icon(Icons.clear, color: Colors.grey),
    this.completeIcon: const Icon(Icons.done, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.arrow_upward, color: Colors.grey),
  }) : super(key: key, mode: mode);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FooterIndicatorState();
  }
}

class _FooterIndicatorState extends State<FooterIndicator> {
  Widget _buildText() {
    return new Text(
        widget.mode == RefreshStatus.canRefresh
            ? widget.releaseText
            : widget.mode == RefreshStatus.completed
            ? widget.completeText
            : widget.mode == RefreshStatus.failed
            ? widget.failedText
            : widget.mode == RefreshStatus.refreshing
            ? widget.refreshingText
            : widget.mode == RefreshStatus.noMore
            ? widget.noDataText
            : widget.mode == RefreshStatus.init
            ? ''
            : widget.idleText,
        style: widget.textStyle);
  }

  Widget _buildIcon() {
    Widget icon = widget.mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : widget.mode == RefreshStatus.noMore
        ? widget.noMoreIcon
        : widget.mode == RefreshStatus.completed
        ? widget.completeIcon
        : widget.mode == RefreshStatus.failed
        ? widget.failedIcon
        : widget.mode == RefreshStatus.init
        ? new Container()
        : new SizedBox(
      width: 15.0,
      height: 15.0,
      child: widget.refreshingIcon,
    );
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildContent
    Widget textWidget = _buildText();
    Widget iconWidget = _buildIcon();
    List<Widget> children = <Widget>[
      iconWidget,
      new Container(
        width: widget.spacing,
        height: widget.spacing,
      ),
      textWidget
    ];
    Widget container = new Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    return new Container(
      height: widget.height+0.0,
      child: new Center(
        child: container,
      ),
    );
  }
}
