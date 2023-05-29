import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/add_asset_dialog.dart';
import 'package:hittapa/widgets/event_request_button.dart';

import 'round_button.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class HittapaBottomWidget extends StatefulWidget {
  EventModel event;
  UserModel user, eventOwner;
  List<UserModel> users;
  AppState state;

  HittapaBottomWidget({
    @required this.event,
    @required this.user,
    this.users,
    this.eventOwner,
    this.state,
  });

  @override
  _HittapaBottomWidgetState createState() => _HittapaBottomWidgetState();
}

class _HittapaBottomWidgetState extends State<HittapaBottomWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  List<UserModel> listOfParticipantsAccepted = [];
  bool _isAttendence = false;
  bool _isMoreStandby = false;

  AccepedUserDialog _acceptedUserDialog;

  EventModel event;

  // ignore: unused_element
  _getEventUsers() async {
    var _result = await NodeService().getEventsUsers(event);
    if (_result != null && _result['data'] != null) {
      listOfParticipantsAccepted = [];
      _result['data'].forEach((doc) => listOfParticipantsAccepted.add(UserModel.fromJson(doc)));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _offsetAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(_controller);
  }

  @override
  void dispose() {
    _controller.reverse();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    event = widget.event;
    listOfParticipantsAccepted = widget.users;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Builder(builder: (context) {
          _acceptedUserDialog = new AccepedUserDialog(context: context, controller: _controller, event: event, users: widget.users, isForward: true, eventOwner: widget.eventOwner);
          _acceptedUserDialog.initState();
          switch (event.statusType(widget.user.uid)) {
            case ApplicantStatusType.guest:
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              Widget result = showRequest();
              if (event.isAdminEvent) {
                result = Container();
              }
              return result;
            case ApplicantStatusType.standby:
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              return showPending(LocaleKeys.widget_standby_for.tr());
            case ApplicantStatusType.pending:
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              return showPending(LocaleKeys.widget_waiting_for.tr());
            case ApplicantStatusType.accepted:
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              return showAccepted();
            case ApplicantStatusType.full:
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              return showStandby(context);
            case ApplicantStatusType.past:
              if ((event.feedback ?? []).length > 1) return Container();
              Timer(Duration(milliseconds: 500), () {
                if (this.mounted) _controller.forward();
              });
              return noFeedbackWidget();
            default:
              return Container();
          }
        }),
      ),
    );
  }

  Widget showRequest() {
    return Container(
        height: 100,
        padding: EdgeInsets.only(right: 20, top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          Column(
            children: <Widget>[EventRequestButton(context: context, event: event, user: widget.user, eventOwner: widget.eventOwner)],
          )
        ]));
  }

  Widget showPending(String title) {
    return Container(
        height: 100,
        padding: EdgeInsets.only(right: 20, top: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: NAVIGATION_NORMAL_TEXT_COLOR),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/pending_icon.svg'),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    LocaleKeys.event_detail_pending.tr(),
                    style: TextStyle(fontSize: 13, color: BORDER_COLOR),
                  )
                ],
              )
            ],
          )
        ]));
  }

  Widget showAccepted() {
    return Builder(builder: (context) {
      return _isAttendence
          ? Container(
              height: event.categoryId == 'adfdsafdasfadsf' ? 440 : 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  // color: Colors.black.withOpacity(0.7),
                  color: Colors.transparent,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF696969),
                      spreadRadius: -15,
                      blurRadius: 40,
                    ),
                  ]),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: CIRCLE_AVATAR_COLOR, borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  Text(
                    LocaleKeys.event_detail_event_attendees.tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  Container(
                    height: 180,
                    child: GridView.count(crossAxisCount: 3, childAspectRatio: 1, padding: EdgeInsets.all(10), crossAxisSpacing: 4, mainAxisSpacing: 4, children: <Widget>[
                      ...listOfParticipantsAccepted.map<Widget>((e) {
                        return Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: e.avatar ?? DEFAULT_AVATAR,
                                  fit: BoxFit.cover,
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${e.username}, ${e.birthday != null ? ageCalculate(e.birthday) : "20"} ${getGenderCharacter(e.gender)}',
                                style: TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ]),
                  ),
                  Container(
                    height: event.categoryId == 'adfdsafdasfadsf' ? 198 : 118,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.black),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              SvgPicture.asset(
                                'assets/checked_icon.svg',
                                width: 30,
                                height: 30,
                              ),
                              Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    ...(listOfParticipantsAccepted.length > 3 ? listOfParticipantsAccepted.sublist(0, 3) : listOfParticipantsAccepted).map<Widget>((e) {
                                      GlobalKey btnKey = GlobalKey(debugLabel: e.uid.toString());
                                      return Positioned(
                                        top: 17,
                                        child: GestureDetector(
                                            key: btnKey,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: CachedNetworkImage(
                                                    imageUrl: e.avatar ?? DEFAULT_AVATAR,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ))),
                                      );
                                    }).toList(),
                                    listOfParticipantsAccepted.length > 3
                                        ? Positioned(
                                            left: 115,
                                            top: 0,
                                            child: IconButton(
                                              icon: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(color: BORDER_COLOR, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '+${listOfParticipantsAccepted.length - 3}',
                                                      style: TextStyle(fontSize: 11, color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onPressed: () {},
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 17),
                                  child: HittapaRoundButton(isGoogleColor: true, onClick: () => navigateToMessageScreen(context, event), text: LocaleKeys.message_message.tr()),
                                ),
                              )
                            ],
                          ),
                          height: 80,
                        ),
                        event.categoryId == 't80ABU6avnYOJtZvjQDx'
                            ? Container(
                                child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                                  style: TextStyle(
                                    color: Color(0xFFD0021B),
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : Container(),
                        Text(
                          LocaleKeys.global_acknowledge.tr(),
                          style: TextStyle(color: BORDER_COLOR, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Container(
              height: event.categoryId == '5faaa4dadceaa674dee0f613' ? 160 : 100,
              decoration: BoxDecoration(
                  // color: CARD_BACKGROUND_COLOR,
                  color: Colors.transparent),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(24)),
                    ),
                    child: Row(
                      children: <Widget>[
                        eventOwnerWidget(widget.eventOwner, false, false),
                        InkWell(
                          onTap: () {
                            navigateToMessageScreen(context, event);
                          },
                          child: SvgPicture.asset('assets/svg/message.svg'),
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              _acceptedUserDialog.showAddDialog(context);
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              ...(listOfParticipantsAccepted.length > 3 ? listOfParticipantsAccepted.sublist(0, 3) : listOfParticipantsAccepted)
                                  .asMap()
                                  .map((key, value) {
                                    GlobalKey btnKey = GlobalKey(debugLabel: value.uid.toString());
                                    return MapEntry(
                                        key,
                                        Positioned(
                                          top: 17,
                                          left: 20.0 * key,
                                          child: GestureDetector(
                                              key: btnKey,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: CachedNetworkImage(
                                                      imageUrl: value.avatar ?? DEFAULT_AVATAR,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              listOfParticipantsAccepted.length > 3
                                  ? Positioned(
                                      left: 85,
                                      top: 18,
                                      child: IconButton(
                                        icon: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(color: BORDER_COLOR, borderRadius: BorderRadius.all(Radius.circular(10))),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '+${listOfParticipantsAccepted.length - 3}',
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )),
                      ],
                    ),
                    height: 100,
                  ),
                  event.categoryId == '5faaa4dadceaa674dee0f613'
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Note! All attendees are responsible for the children they brought with them to the event.',
                                  style: TextStyle(
                                    color: Color(0xFFD0021B),
                                    fontSize: 13,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 14, right: 14, bottom: 7),
                              ),
                              // Text(LocaleKeys.global_acknowledge.tr(),
                              //   style: TextStyle(color: BORDER_COLOR, fontSize: 13, fontWeight: FontWeight.w600),
                              // )
                            ],
                          ),
                        )
                      : Container()
                ],
              ));
    });
  }

  Widget showStandby(BuildContext context) {
    return Container(
        // height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: Colors.transparent,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 100,
              child: Stack(children: <Widget>[
                Positioned(
                  left: 0,
                  child: InkWell(
                    onTap: () => onClickCreate(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 + 50,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
                      child: Text(
                        'Create event',
                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 10,
                  child: InkWell(
                    onTap: () => onClickStandby(widget.user.uid),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: LIGHTBLUE_BUTTON_COLOR, borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
                      child: Text(
                        'Join standby ${event.participantsStandby.length}',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isMoreStandby = !_isMoreStandby;
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: CHECKED_COLOR,
                        ),
                        child: Text(
                          '?',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ]),
            ),
            _isMoreStandby
                ? Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text('Unfortunately this event is full with the required attendees needed, but you can create new or standby if someone withdraw from attendind'),
                  )
                : Container(),
          ],
        ));
  }

  Widget noFeedbackWidget() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(boxShadow: <BoxShadow>[
        const BoxShadow(color: const Color(0x56C9CFD7), blurRadius: 22, offset: Offset(0, -12)),
      ], borderRadius: const BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: CIRCLE_AVATAR_COLOR, borderRadius: BorderRadius.all(Radius.circular(3))),
          ),
          Text(
            LocaleKeys.event_detail_no_feedback.tr(),
            style: TextStyle(
              fontSize: 17,
              color: NAVIGATION_NORMAL_TEXT_COLOR,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Expanded(
            child: Text(
              LocaleKeys.event_detail_no_one_has_given_any_feedback.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: NAVIGATION_NORMAL_TEXT_COLOR),
            ),
          )
        ],
      ),
    );
  }

  onClickStandby(String firebaseId) {
    List<String> _standby = event.participantsStandby;
    print(firebaseId);
    if (!_standby.contains(firebaseId)) {
      _standby.add(firebaseId);
      NodeService().updateEvent(event.copyWith(participantsStandby: _standby).toFB()).then((_) => setState(() => event.participantsStandby.add(firebaseId)));
    }
  }

  onClickCreate(BuildContext context) {
    navigateToCategoryScreen(context, appstate: widget.state, pathIndex: 1);
  }
}
