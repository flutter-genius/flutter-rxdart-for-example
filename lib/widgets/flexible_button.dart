import 'package:flutter/material.dart';

class FlexibleButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color color;
  final double width;
  final double height;

  FlexibleButton(
      {@required this.onClick,
      @required this.text,
      @required this.color,
      @required this.width,
      @required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(height))),
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
        onPressed: onClick,
      ),
    );
  }
}
