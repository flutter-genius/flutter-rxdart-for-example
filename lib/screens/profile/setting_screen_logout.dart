import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/screens/main/mainScreen.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';

import 'package:hittapa/services/store_service.dart';
import 'package:redux/redux.dart';
import '../../global.dart';
import 'package:hittapa/global_export.dart';

class SettingScreenLogout extends StatefulWidget {
  final EventModel event;
  final UserModel owner;
  final List<File> files;

  SettingScreenLogout({this.event, this.owner, this.files});

  @override
  State<StatefulWidget> createState() => _EventPostedScreen();
}

class _EventPostedScreen extends State<SettingScreenLogout> {
  double _fontSize = 10;
  double _distance = 5;
  bool _isdone = false;

  @override
  // ignore: must_call_super
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
        ModalRoute.withName(Routes.MAIN),);
    });
  }

  lo(Store<AppState> store) async {
    if(!_isdone) {
      _isdone = true;
      await logOut(store);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          var user = state.user;
          lo(store);

          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.edit_profile_email.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  color: BORDER_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset('assets/double_arrow.svg'),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.create_account_password.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              ' (***********)',
                              style: TextStyle(
                                  color: BORDER_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset('assets/double_arrow.svg'),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.global_language.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              LocaleKeys.setting_swedish.tr(),
                              style: TextStyle(
                                  color: BORDER_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset('assets/double_arrow.svg'),
                      ),
                      ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_currency.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '(SEK)',
                              style: TextStyle(
                                  color: BORDER_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              LocaleKeys.setting_coming_soon.tr(),
                              style: TextStyle(
                                  color: GRADIENT_COLOR_TWO,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset('assets/double_arrow.svg'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_text_size.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            SvgPicture.asset('assets/A-A.svg'),
                          ],
                        ),
                      ),
                      Slider(
                        value: _fontSize,
                        min: 10,
                        max: 20,
                        activeColor: GRADIENT_COLOR_ONE,
                        inactiveColor: SHADOW_COLOR,
                        label: 'TEXt',
                        onChanged: (v) {
                          setState(() {
                            _fontSize = v;
                          });
                        },
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                        child: Text(
                          LocaleKeys.setting_this_is_reference_text.tr(),
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          children: <Widget>[
                            //                Text('Distance from my current location', style: TextStyle(color: TITLE_TEXT_COLOR, fontSize: 17, fontWeight: FontWeight.w500),),
                            Expanded(
                              child: Text(
                                LocaleKeys.setting_distance_from_my_location.tr(),
                                style: TextStyle(
                                    color: TITLE_TEXT_COLOR,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text('< ${_distance.toStringAsFixed(2)} km',
                                style: TextStyle(
                                    color: BORDER_COLOR,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      Slider(
                        value: _distance,
                        min: 2,
                        max: 100,
                        activeColor: GRADIENT_COLOR_ONE,
                        inactiveColor: SHADOW_COLOR,
                        label: 'TEXt',
                        onChanged: (v) {
                          setState(() {
                            _distance = v;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  right: 16, top: 24, left: 16, bottom: 12),
                              child: Text(
                                LocaleKeys.setting_saved_locations.tr().toUpperCase(),
                                style: TextStyle(
                                    color: BORDER_COLOR,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            FutureBuilder<List<Address>>(
                              future: getAddressed(),
                              builder: (context, snap) {
                                switch (snap.connectionState) {
                                  case ConnectionState.waiting:
                                    return Container();
                                  default:
                                    return Column(
                                      children: snap.data == null ? [] : snap.data
                                          .map((e) => Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(color: SEPARATOR2_COLOR,
                                                    style: BorderStyle.solid, width: 1))),
                                        margin: EdgeInsets.symmetric(horizontal: 16,),
                                        padding: EdgeInsets.symmetric(vertical: 13),
                                        child: Text(e.addressLine,
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: TITLE_TEXT_COLOR,
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                      )).toList(),
                                    );
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 32),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: PRIMARY_COLOR,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      LocaleKeys.setting_add_new_location.tr(),
                                      style: TextStyle(
                                          color: PRIMARY_COLOR,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                navigateToLocationPickerScreen(context).then((value) {
                                  if (value != null)
                                    saveAddress(value);
                                  setState(() {});
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  right: 16, top: 24, left: 16, bottom: 10),
                              child: Text(LocaleKeys.setting_notifications.tr().toUpperCase(),
                                  style: TextStyle(
                                      color: BORDER_COLOR,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.setting_applied_event.tr(),
                                    style: TextStyle(
                                        color: TITLE_TEXT_COLOR,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 30,
                                    child: CupertinoSwitch(
                                        value:
                                        user.isEnableNotificationAppliedEvent ??
                                            false,
                                        onChanged: (v) => dispatch(updateUser(
                                            user.copyWith(
                                                isEnableNotificationAppliedEvent:
                                                v)))),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.setting_acceptance.tr(),
                                    style: TextStyle(
                                        color: TITLE_TEXT_COLOR,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 30,
                                    child: CupertinoSwitch(
                                      value: user.isEnableNotificationAcceptEvent ??
                                          false,
                                      onChanged: (v) => dispatch(updateUser(
                                          user.copyWith(
                                              isEnableNotificationAcceptEvent: v))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.setting_message.tr(),
                                    style: TextStyle(
                                        color: TITLE_TEXT_COLOR,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 30,
                                    child: CupertinoSwitch(
                                      value:
                                      user.isEnableNotificationMessage ?? false,
                                      onChanged: (v) => dispatch(updateUser(user
                                          .copyWith(isEnableNotificationMessage: v))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.setting_activity_reminder.tr(),
                                    style: TextStyle(
                                        color: TITLE_TEXT_COLOR,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 30,
                                    child: CupertinoSwitch(
                                      value:
                                      user.isEnableNotificationReminderActivity ??
                                          false,
                                      onChanged: (v) => dispatch(updateUser(
                                          user.copyWith(
                                              isEnableNotificationReminderActivity:
                                              v))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 16, left: 16, top: 10, bottom: 24),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.setting_feedback_reminder.tr(),
                                    style: TextStyle(
                                        color: TITLE_TEXT_COLOR,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 30,
                                    child: CupertinoSwitch(
                                      value:
                                      user.isEnableNotificationReminderFeedback ??
                                          false,
                                      onChanged: (v) => dispatch(updateUser(
                                          user.copyWith(
                                              isEnableNotificationReminderFeedback:
                                              v))),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 16, left: 16, top: 18, bottom: 10),
                        child: GestureDetector(
                          child: Text(LocaleKeys.setting_logout.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500)),
                          onTap: (){},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 50),
                        child: Text(LocaleKeys.setting_disable.tr(),
                            style: TextStyle(
                                color: TITLE_TEXT_COLOR,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Image.asset('assets/images/check-white.png', width: 60, height: 60,),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(LocaleKeys.login_logout.tr(),
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 24),
                                  textAlign: TextAlign.center
                              ),
                            ),
                            SizedBox(height: 20,),
                            Center(
                              child: Text(LocaleKeys.create_event_we_value_your_opinion.tr(),
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
                                  textAlign: TextAlign.center
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        }
        );
  }
}


