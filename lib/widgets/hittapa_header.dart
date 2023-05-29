import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/user.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:hittapa/global_export.dart';
import 'package:provider/provider.dart';

import '../config.dart';

//ignore: must_be_immutable
class HittapaHeader extends StatelessWidget {
  final int currentPage;
  final List messages;
  final UserModel user;
  HittapaHeader({this.currentPage = 0, this.messages, this.user});
  GlobalKey btnKey = GlobalKey();

  String getDayPeriod(int _ghour) {
    String _dayPeriod = 'Evening';
    int _hour = _ghour;
    if (_hour >= 5 && _hour < 12) _dayPeriod = 'Morning';
    if (_hour >= 12 && _hour < 19) _dayPeriod = 'Afternoon';
    return _dayPeriod;
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    // String _headerText = "HittaPå.";
    String _headerText = "";
    bool _isUserImage = false;
    final _provider = Provider.of<IsScroller>(context);
    if (currentPage == 1) _headerText = 'My Calendar';
    if (currentPage == 2) _headerText = LocaleKeys.home_message.tr();
    if (currentPage == 3) _headerText = LocaleKeys.home_notification.tr();
    if (!_provider.isAction && currentPage == 0) {
      DateTime _now = DateTime.now();
      // ignore: non_constant_identifier_names
      _headerText = "Good " + getDayPeriod(_now.hour);
      _isUserImage = true;
    }
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: currentPage == 0
          ? _isUserImage
              ? <Widget>[
                  Text(
                    _headerText,
                    style: TextStyle(
                        color: DART_TEXT_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        decoration: TextDecoration.none,
                        fontFamily: appTheme.fontFamily2),
                  ),
                ]
              : [
                  Image.asset('assets/logo.png', width: 120),
                ]
          : <Widget>[
              Text(
                _headerText,
                style: TextStyle(
                    color: DART_TEXT_COLOR,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    decoration: TextDecoration.none,
                    fontFamily: appTheme.fontFamily2),
              ),
            ],
    ));
  }
}
