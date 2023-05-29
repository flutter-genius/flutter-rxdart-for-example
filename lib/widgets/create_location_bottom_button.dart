import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

class CreateLocationBottomButton extends StatefulWidget {
  @override
  _CreateLocationBottomButtonState createState() =>
      _CreateLocationBottomButtonState();
}

class _CreateLocationBottomButtonState extends State<CreateLocationBottomButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _offsetAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(_controller);
    Timer(Duration(seconds: 2), () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF696969),
              spreadRadius: -10,
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: HittapaRoundButton(
                text: LocaleKeys.menu_create_location.tr().toUpperCase(),
                onClick: () => navigateToNewLocationScreen(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
