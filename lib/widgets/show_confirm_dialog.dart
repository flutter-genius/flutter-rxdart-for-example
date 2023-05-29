import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final Widget firstButton;
  final Widget secondButton;
  final Widget title;
  final Widget yourWidget;
  final Widget icon;
  final bool isCenter;
  final bool isEvent;

  ConfirmDialog({this.firstButton, this.secondButton, this.title, this.yourWidget, this.icon, this.isCenter = true, this.isEvent = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isEvent ? Color.fromRGBO(0, 0, 0, 0.3) : Color.fromRGBO(0, 0, 0, 0.5),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              title == null ? Container() : title,
              SizedBox(
                height: 30,
              ),
              yourWidget == null ? Container() : yourWidget,
              SizedBox(height: firstButton == null && secondButton == null ? 0 : 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  firstButton == null ? Container() : firstButton,
                  firstButton != null && secondButton != null
                      ? SizedBox(
                          width: 30,
                        )
                      : SizedBox(width: 0),
                  secondButton == null ? Container() : secondButton
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
