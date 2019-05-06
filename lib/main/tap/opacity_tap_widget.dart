import 'package:flutter/material.dart';

class OpacityTapWidget extends StatefulWidget {
  final Widget child;
  final Function onTap;

  const OpacityTapWidget({Key key, this.child, this.onTap}) : super(key: key);

  @override
  OpacityTapWidgetState createState() {
    return new OpacityTapWidgetState();
  }
}

class OpacityTapWidgetState extends State<OpacityTapWidget> {
  var isDown = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: new Opacity(
          opacity: isDown ? 0.5 : 1,
          child: widget.child,
        ),
      ),
      onTap: widget.onTap,
      onTapDown: (d) => setState(() => this.isDown = true),
      onTapUp: (d) => setState(() => this.isDown = false),
      onTapCancel: () => setState(() => this.isDown = false),
    );
  }
}