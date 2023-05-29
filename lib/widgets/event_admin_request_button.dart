import 'dart:async';

import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';

import 'round_button.dart';
import 'package:hittapa/global_export.dart';

class EventAdminRequestButton extends StatefulWidget {
  final EventModel event;
  final BuildContext context;
  final UserModel user, eventOwner;

  EventAdminRequestButton({this.event, this.context, this.user, this.eventOwner});

  @override
  _EventAdminRequestButtonState createState() => _EventAdminRequestButtonState();
}

class _EventAdminRequestButtonState extends State<EventAdminRequestButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isRequested = false;

  _updateEvent(event) async {
    await NodeService().updateEvent(event);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _offsetAnimation = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero).animate(_controller);
    Timer(Duration(milliseconds: 100), () {
      if (!_controller.isAnimating && this.mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.reverse();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HittapaRoundGradientButton(
            text: 'REQUEST JOIN',
            isDisable: false,
            isLogo: true,
            startColor: ADMIN_REQUEST_ONE_COLOR,
            endColor: ADMIN_REQUEST_TWO_COLOR,
            onClick: () async {
              await showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (context) => StatefulBuilder(builder: (context, setState) {
                        return ConfirmDialog(
                            title: isRequested
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/check-white.png',
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Text("YOUR JOIN REQUEST IS SUCCESSFULLY SENT",
                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 24), textAlign: TextAlign.center),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Text("We hope you have fun and value your opinion and believe people lke you make HittaPå a special place for interesting activities.",
                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17), textAlign: TextAlign.center),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    "Agree to event's requirements and user terms of use".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                            firstButton: isRequested
                                ? Container()
                                : HittapaRoundButton(
                                    text: "DISCARD",
                                    onClick: () => Navigator.of(context).pop(),
                                    isNormal: true,
                                    isPopUp: true,
                                  ),
                            secondButton: isRequested
                                ? Container()
                                : HittapaRoundGradientButton(
                                    text: LocaleKeys.event_detail_accepted.tr().toUpperCase(),
                                    onClick: () async {
                                      if (![...widget.event.participantsPending, ...widget.event.participantsDeclined, ...widget.event.participantsAccepted].contains(widget.user.uid)) {
                                        widget.event.participantsPending.add(widget.user.uid);
                                        await _updateEvent(widget.event.toJson());
                                        setState(() => isRequested = true);
                                        Future.delayed(Duration(seconds: 2), () {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    startColor: LIGHTBLUE_BUTTON_COLOR,
                                    endColor: LIGHTBLUE_BUTTON_COLOR,
                                  ),
                            icon: Container(),
                            yourWidget: isRequested
                                ? Container()
                                : Column(
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            style: TextStyle(color: Colors.white, fontSize: 14),
                                            text: "I understood event's description and agree to event's requirements including date, time, meeting place and user terms of use ",
                                            children: <TextSpan>[
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
                                      )
                                    ],
                                  ));
                      }));
            },
          ),
        ],
      ),
    );
  }
}
