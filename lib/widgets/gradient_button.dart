import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final Function onTap;

  GradientButton(this.text, this.onTap);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [GRADIENT_COLOR_ONE, GRADIENT_COLOR_TWO]),
          borderRadius: BorderRadius.circular(24)),
      child: FlatButton(
        child: Text(
          widget.text,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: () {
          widget.onTap();
        },
      ),
    );
  }
}
