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

class EventRequestButton extends StatefulWidget {
  final EventModel event;
  final BuildContext context;
  final UserModel user, eventOwner;

  EventRequestButton({this.event, this.context, this.user, this.eventOwner});

  @override
  _EventRequestButtonState createState() => _EventRequestButtonState();
}

class _EventRequestButtonState extends State<EventRequestButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isRequested = false;

  _updateEvent(event) async {
    await NodeService().updateEvent(event);
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _offsetAnimation = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HittapaRoundGradientButton(
            text: LocaleKeys.event_detail_join_request.tr().toUpperCase(),
            isDisable: false,
            startColor: LIGHTBLUE_BUTTON_COLOR,
            endColor: LIGHTBLUE_BUTTON_COLOR,
            onClick: () async {
              await showDialog(context: context, useSafeArea: false, builder: (context) => StatefulBuilder(
                builder: (context, setState) {
                  return ConfirmDialog(
                  title: isRequested ? Center(
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
                                  child: Text(
                                      "YOUR JOIN REQUEST IS SUCCESSFULLY SENT",
                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 24),
                                      textAlign: TextAlign.center
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Center(
                                  child: Text(
                                      "We hope you have fun and value your opinion and believe people lke you make HittaPå a special place for interesting activities.",
                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
                                      textAlign: TextAlign.center
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ) : Text(
                    "Agree to event's requirements and user terms of use".toUpperCase(),
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),
                  firstButton: isRequested ? Container() : HittapaRoundButton(
                      text: "DISCARD",
                      onClick: () => Navigator.of(context).pop(),
                      isNormal: true,
                    isPopUp: true,
                    ),
                  secondButton: isRequested ? Container() :  HittapaRoundGradientButton(
                    text: LocaleKeys.event_detail_accepted.tr().toUpperCase(),
                    onClick: () async {
                      if (![
                        ...widget.event.participantsPending,
                        ...widget.event.participantsDeclined,
                        ...widget.event.participantsAccepted
                      ].contains(widget.user.uid)) {
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
                    yourWidget: isRequested ? Container() :  Column(
                      children: <Widget>[

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                              text:
                              "I understood event's description and agree to event's requirements including date, time, meeting place and user terms of use ",
                              children: <TextSpan>[
                                TextSpan(
                                    text: LocaleKeys.global_terms_of_use.tr(),
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        await launchURL('hittapa.com/terms');
                                      }
                                    ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                    text: LocaleKeys.global_privacy_policy.tr(),
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        await launchURL('hittapa.com/privacy');
                                      }
                                      )
                              ]),
                        )
                      ],
                    )
                  );
                })
              );
            },
          ),
          // HittapaRoundButton(
          //   isGoogleColor: true,
          //   text: LocaleKeys.event_detail_join_request.tr().toUpperCase(),
          //   onClick: () async {
          //     await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
          //       title: Text(
          //         LocaleKeys.event_detail_thank_you_for_event.tr().toUpperCase(),
          //         textAlign: TextAlign.center, style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),
          //       firstButton: HittapaRoundButton(
          //           text: LocaleKeys.panel_cancel.tr(),
          //           onClick: () => Navigator.of(context).pop(),
          //           isNormal: true,
          //         isPopUp: true,
          //         ),
          //       secondButton: HittapaRoundButton(
          //         text: LocaleKeys.event_detail_accepted.tr().toUpperCase(),
          //         isPopUp: true,
          //         onClick: () async {
          //           if (![
          //             ...widget.event.participantsPending,
          //             ...widget.event.participantsDeclined,
          //             ...widget.event.participantsAccepted
          //           ].contains(widget.user.uid)) {
          //             widget.event.participantsPending.add(widget.user.uid);
          //             await _updateEvent(widget.event.toJson());
          //             Navigator.of(context).pop();
          //           }
          //         },
          //       ),
          //         icon: Container(),
          //         yourWidget: Column(
          //           children: <Widget>[
          //             Center(
          //               child: Text(
          //                 LocaleKeys.create_event_we_value_your_opinion.tr(),
          //                 textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17),),
          //             ),
          //             RichText(
          //               textAlign: TextAlign.center,
          //               text: TextSpan(
          //                   style: TextStyle(
          //                       color: Colors.white, fontSize: 14),
          //                   text:
          //                   LocaleKeys.event_detail_by_posting.tr(),
          //                   children: <TextSpan>[
          //                     TextSpan(
          //                         text: LocaleKeys.global_terms_of_use.tr(),
          //                         style: TextStyle(
          //                           decoration: TextDecoration.underline,
          //                         ),
          //                         recognizer: TapGestureRecognizer()
          //                           ..onTap = () async{
          //                             await launchURL('hittapa.com/terms');
          //                           }
          //                         ),
          //                     TextSpan(text: ' '),
          //                     TextSpan(
          //                         text: LocaleKeys.global_privacy_policy.tr(),
          //                         style: TextStyle(
          //                             decoration: TextDecoration.underline),
          //                             recognizer: TapGestureRecognizer()
          //                           ..onTap = () async{
          //                             await launchURL('hittapa.com/privacy');
          //                           }
          //                           )
          //                   ]),
          //             )
          //           ],
          //         )
          //       )
          //     );
          //   },
          // )
        ],
      ),
    );
  }

  showSuccessDialog() async {
    await animated_dialog_box.showScaleAlertBox(
        title: Center(child: Text(LocaleKeys.widget_thank_you.tr())),
        context: widget.context,
        firstButton: Container(
          width: 0,
        ),
        icon: Container(),
        yourWidget: Builder(
          builder: (context) {
            Timer(
                Duration(
                  seconds: 4,
                ),
                () => Navigator.of(context).pop());
            return Container(
              child: Text(LocaleKeys.widget_you_have_successfully_applied.tr()),
            );
          },
        ));
  }

  showFailedDialog(String msg) async {
    await animated_dialog_box.showScaleAlertBox(
        title: Center(child: Text(
          LocaleKeys.widget_alert.tr()
          )),
        context: context,
        firstButton: Container(
          width: 170,
          child: HittapaRoundButton(
            text: LocaleKeys.global_ok.tr().toUpperCase(),
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        icon: Container(),
        yourWidget: Container(
          child: Text(msg),
        ));
  }
}
