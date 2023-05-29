import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/event_admin_request_button.dart';
import 'package:hittapa/widgets/flexible_button.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../global.dart';
import 'dart:async';

import 'package:hittapa/global_export.dart';

class EventAdminBottomHeader extends StatefulWidget {
  final EventModel event;
  final UserModel eventOwner;
  final UserModel user;
  final PanelController controller;

  EventAdminBottomHeader({@required this.event, this.eventOwner, this.controller, this.user});
  @override
  _EventAdminBottomHeaderrState createState() => _EventAdminBottomHeaderrState();
}

class _EventAdminBottomHeaderrState extends State<EventAdminBottomHeader> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  bool isOpen = false;
  EventModel event;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _offsetAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.2)).animate(_animationController);

    Timer(Duration(milliseconds: 500), () {
      if (this.mounted) _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    event = widget.event;
    return SlideTransition(position: _offsetAnimation, child: headerWidget());
  }

  Widget headerWidget() {
    var ids = event.participantsAccepted.toSet().toList();
    ids = ids.where((element) => element != event.ownerId).toList();
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 45,
              height: 6,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: BORDER_COLOR),
            ),
            Text(
              LocaleKeys.event_detail_manage_requests.tr(),
              style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
            ),
            Container(
                height: 80,
                padding: EdgeInsets.only(right: 20, top: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  Column(
                    children: <Widget>[EventAdminRequestButton(context: context, event: event, user: widget.user, eventOwner: widget.eventOwner)],
                  )
                ])),
          ],
        ));
  }
}

class EventAdminBottomBody extends StatelessWidget {
  final EventModel event;
  final List<UserModel> others;
  final PanelController controller;
  final UserModel user;
  final UserModel eventOwner;
  final Function onCall;

  EventAdminBottomBody({this.event, this.others, this.controller, this.user, this.eventOwner, this.onCall});

  @override
  Widget build(BuildContext context) {
    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 140),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'On HittPas admin event users hsa just more than a possiblity of joining event, they can also call and book for their relatives who has no Hittapas account.',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Join requests',
              style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 16), text: "By clicking on the Request join button you agree to the ", children: <TextSpan>[
                TextSpan(
                    text: LocaleKeys.global_terms_of_use.tr(),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launchURL('hittapa.com/terms');
                      }),
                TextSpan(text: ' and '),
                TextSpan(
                    text: LocaleKeys.global_privacy_policy.tr(),
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launchURL('hittapa.com/privacy');
                      })
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            EventAdminRequestButton(context: context, event: event, user: user, eventOwner: eventOwner),
            SizedBox(
              height: 30,
            ),
            Text(
              'Call Magdalena to book in a relative',
              style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You can call Magdalena to book in space for a relative who has no HittaPås account, NOTE on calling on time  stated in the event description. ',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                eventOwnerWidgetOnImage(eventOwner, false, false),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                print('Press');
                onCall();
              },
              child: Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  color: SHADOW_COLOR,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SvgPicture.asset('assets/svg/phone.svg'), Text('Call', style: TextStyle(fontSize: 17, color: BACKGROUND_COLOR))],
                ),
              ),
            ),
          ],
        ));
  }
}
