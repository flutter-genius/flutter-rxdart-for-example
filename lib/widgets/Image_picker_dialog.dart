import 'dart:async';

import 'package:flutter/material.dart';

import '../global.dart';
import 'image_picker_handler.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class ImagePickerDialog extends StatelessWidget {
  final ImagePickerHandler listener;
  final AnimationController controller;
  final BuildContext context;

  ImagePickerDialog({@required this.context, this.listener, this.controller});

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (controller == null || _drawerDetailsPosition == null || _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pop(this.context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: CIRCLE_AVATAR_COLOR,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 36,
                      ),
                      Text(
                        LocaleKeys.panel_change_picture.tr(),
                        style: TextStyle(
                            fontSize: 17,
                            color: NAVIGATION_NORMAL_TEXT_COLOR,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: roundedButton(
                                LocaleKeys.panel_upload_from_camera.tr(),
                                EdgeInsets.symmetric(horizontal: 16),
                                Colors.white,
                                NAVIGATION_NORMAL_TEXT_COLOR,
                                () => listener.openGallery()),
                          )
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: roundedButton(
                                LocaleKeys.panel_take_a_picture.tr(),
                                EdgeInsets.symmetric(horizontal: 16),
                                Colors.white,
                                NAVIGATION_NORMAL_TEXT_COLOR,
                                () => listener.openCamera()),
                          )
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: roundedButton(
                                LocaleKeys.panel_cancel.tr(),
                                EdgeInsets.symmetric(horizontal: 16),
                                Colors.white,
                                NAVIGATION_NORMAL_TEXT_COLOR,
                                () => dismissDialog()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin, Color bgColor,
      Color textColor, Function onTap) {
    return Container(
      margin: margin,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        color: bgColor,
        padding: EdgeInsets.all(15.0),
        child: Text(
          buttonLabel,
          style: new TextStyle(
              color: textColor, fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        onPressed: () => onTap(),
      ),
    );
  }
}
