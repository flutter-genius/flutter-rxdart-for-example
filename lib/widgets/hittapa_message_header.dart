
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/model.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/store_service.dart';
import 'package:hittapa/global_export.dart';

class HittapaMessageHeader extends StatefulWidget {
  HittapaMessageHeader({this.messages});

  final List<dynamic> messages;
  @override
  _HittapaBottomBarState createState() => _HittapaBottomBarState();
}

class _HittapaBottomBarState extends State<HittapaMessageHeader> {
  Timer _timer;
  int _callTimes = 0;
  String _message = '';

  @override
  void initState() {
    super.initState();
    callTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  String getDayPeriod(int _ghour) {
    String _dayPeriod = 'evening';
    int _hour = _ghour;
    if (_hour >= 5 && _hour < 12) _dayPeriod = 'morning';
    if (_hour >= 12 && _hour < 19) _dayPeriod = 'afternoon';
    return _dayPeriod;
  }

  callTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (timer) {
      _message = '';
      DateTime _now = DateTime.now();
      // ignore: non_constant_identifier_names
      List _message_lists = widget.messages.where((element) => element['type'] == getDayPeriod(_now.hour)).toList();
      if (_message_lists.length > 0) {
        setState(() {
          _message = _message_lists[_callTimes%_message_lists.length]['message'];
        });
      }
      _callTimes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _message == '' ? Container() : Text(
        _message,
        style: TextStyle(
          color: DART_TEXT_COLOR,
          fontWeight: FontWeight.w400,
          fontSize: 18,
          decoration: TextDecoration.none,
          fontFamily: appTheme.fontFamily2
        ),
      ),
    );
  }
}
