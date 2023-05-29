import 'package:flutter/material.dart';

class HittapaOutline extends StatefulWidget {
  final Widget child;
  final int height;
  final int round;

  HittapaOutline({@required this.child, this.height = 55, this.round = 18});

  @override
  _HittapaOutlineState createState() => _HittapaOutlineState();
}

class _HittapaOutlineState extends State<HittapaOutline> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.toDouble(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.round.toDouble())),
          border: Border.all(color: Color(0xFF9EACC4), width: 1)),
      child: widget.child,
    );
  }
}
