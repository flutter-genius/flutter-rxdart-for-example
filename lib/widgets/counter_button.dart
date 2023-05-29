import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {
  final Widget child;
  final Function onTap;

  CounterButton({this.child, this.onTap});

  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        padding: new EdgeInsets.all(0.0),
        icon: widget.child,
        onPressed: () {
          widget.onTap();
        },
      ),
    );
  }
}
