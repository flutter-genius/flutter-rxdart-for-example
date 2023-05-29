import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/screens/location/location_event_screen.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class LocationBottomWidget extends StatefulWidget {
  final VenueModel location;
  final UserModel user;
  List<EventModel> events;

  LocationBottomWidget({this.location, this.user, this.events});

  @override
  _LocationBottomWidgetState createState() => _LocationBottomWidgetState();
}

class _LocationBottomWidgetState extends State<LocationBottomWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void dispose() {
//    _controller.reverse();
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
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF696969),
              spreadRadius: -10,
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            widget.user.uid == widget.location.ownerId
                ? Container()
                : Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FB.EVENT_COLLECTION).where('venueId', isEqualTo: widget.location.id.toString()).snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                  return HittapaRoundButton(
                    text:
                    LocaleKeys.widget_browse.tr() + ' (${widget.events.length}) ' + LocaleKeys.home_events.tr().toLowerCase(),
                    isNormal: true,
                    isOutline: true,
                    onClick: (){
                      if(widget.events.length > 0){
                          onShowEventsSlider(widget.events);
                      }
                    },
                  );
                },
              ),
            ),
            widget.user.uid == widget.location.ownerId
                ? Container()
                : SizedBox(
              width: 20,
            ),
            Expanded(
              child: HittapaRoundButton(
                text: LocaleKeys.global_create_event.tr().toUpperCase(),
                onClick: () => navigateToCategoryScreen(context,
                    location: widget.location),
              ),
            )
          ],
        ),
      ),
    );
  }

  onShowEventsSlider(List<EventModel> events) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF696969),
                    spreadRadius: -5,
                    blurRadius: 14,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 14, bottom: 17),
                    width: 45,
                    height: 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: CIRCLE_AVATAR_COLOR),
                  ),
                  Text(
                    LocaleKeys.home_events.tr(),
                    style: TextStyle(
                        fontSize: 17,
                        color: NAVIGATION_NORMAL_TEXT_COLOR,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: LocationEventScreen(
                      events: events,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
