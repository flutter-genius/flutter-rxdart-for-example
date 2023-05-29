import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/flexible_button.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../global.dart';
import 'dart:async';

import 'package:hittapa/global_export.dart';

class MyEventBottomHeader extends StatefulWidget {
  final EventModel event;
  final UserModel eventOwner;
  final PanelController controller;

  MyEventBottomHeader({@required this.event, this.eventOwner, this.controller});
  @override
  _MyEventBottomHeaderState createState() => _MyEventBottomHeaderState();
}

class _MyEventBottomHeaderState extends State<MyEventBottomHeader> with SingleTickerProviderStateMixin {
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
        height: 110,
        padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TAB_COLOR, TAB_TWO_COLOR]),
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(24)),
        ),
        child: Stack(children: [
          // Container(
          //   padding: EdgeInsets.only(left: 15, top: 3),
          //   child: eventOwnerImageOnBottom(widget.eventOwner),
          // ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: 45,
                  height: 6,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: BORDER_COLOR),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      LocaleKeys.event_detail_manage_requests.tr(),
                      style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 33,
                          height: 25,
                          child: FittedBox(
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.cover,
                            child: SvgPicture.asset(
                              'assets/bells.svg',
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('${(event.participantsPending ?? []).length + (event.participantsStandby ?? []).length}', style: TextStyle(color: Colors.white, fontSize: 12)),
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(color: Color(0xFFFD5805), borderRadius: BorderRadius.all(Radius.circular(7))),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: sticker(label: LocaleKeys.event_detail_pending.tr(), value: event.participantsPending?.length.toString(), color: Color(0xFFF5A623)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: sticker(label: LocaleKeys.event_detail_accepted.tr(), value: ids?.length.toString(), color: Color(0xFF26D522)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: sticker(label: LocaleKeys.event_detail_standby.tr(), value: event.participantsStandby?.length.toString(), color: Color(0xFFB8B8B8)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]));
  }

  Widget sticker({String label, String value, Color color}) {
    if (widget.event.isAdminEvent) {
      label = '';
    }
    return GestureDetector(
      child: Container(
        height: 24,
        alignment: Alignment(0, 0),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Text(
          '$value $label',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () {
        widget.controller.open();
      },
    );
  }
}

class MyEventBottomBody extends StatelessWidget {
  final EventModel event;
  final List<UserModel> others;
  final PanelController controller;

  MyEventBottomBody({this.event, this.others, this.controller});

  @override
  Widget build(BuildContext context) {
    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context) {
    var ids = event.participantsAccepted.toSet().toList();
    ids = ids.where((element) => element != event.ownerId).toList();
    int totals = 0;
    totals += ids.length;
    totals += event.participantsPending.length;
    totals += event.participantsStandby.length;
    return Container(
        margin: EdgeInsets.only(top: 100),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 220,
              child: DefaultStickyHeaderController(
                child: CustomScrollView(
                  slivers: [
                    sliverPendingItem(
                      items: event.participantsPending,
                      color: Color(0xFFF5A623),
                      label: LocaleKeys.event_detail_pending_requests.tr(),
                    ),
                    sliverStandbyItem(
                      items: event.participantsStandby,
                      color: Color(0xFFB8B8B8),
                      label: LocaleKeys.event_detail_standby_upper.tr(),
                    ),
                    sliverAcceptItem(items: ids, color: Color(0xFF26D522), label: 'Accepted users ${ids.length} of ${totals}', context: context),
                  ],
                ),
              ),
            ),
            others.length > 0
                ? Container(
                    child: FlexibleButton(
                    onClick: () {
                      navigateToMessageScreen(context, event);
                    },
                    text: 'Message All',
                    color: BORDER_COLOR,
                    height: 48,
                    width: MediaQuery.of(context).size.width - 60,
                  ))
                : Container()
          ],
        ));
  }

  Widget sliverHeader({String title, Color underline, String tailing}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFB8B8B8), width: 1))),
      padding: EdgeInsets.only(top: 40, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underline, width: 2))),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            tailing,
            style: TextStyle(fontSize: 13, color: GOOGLE_COLOR, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget sliverPendingItem({List<String> items, String label, Color color}) {
    return SliverStickyHeader(
      header: sliverHeader(title: label, underline: color, tailing: LocaleKeys.event_detail_accept_all.tr() + ' (${items.length})'),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, i) => FutureBuilder<dynamic>(
                  future: NodeAuthService().getUser(items[i], null),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) return ListTile();
                    UserModel _user = UserModel.fromJson(snap.data['data']);
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(_user.avatar ?? DEFAULT_AVATAR),
                            )),
                            Positioned(
                              right: 0,
                              child: _user.isEmailVerified ? SvgPicture.asset('asset_users/safe_icon.svg') : Container(),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        '${_user.username}, ${ageCalculate(_user?.birthday ?? 2000)} ${getGenderCharacter(_user.gender)}',
                        style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
                      ),
                      title: FutureBuilder(
                        future: distanceInKmBetweenEarthCoordinates(_user.location?.coordinates[0], _user.location?.coordinates[1], event.location?.coordinates[0], event.location?.coordinates[1]),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return Row(
                              children: [
                                Text(
                                  '${(snap.data / 1000).toStringAsFixed(2)} km',
                                  style: TextStyle(color: BORDER_COLOR, fontSize: 13),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/meet_point_icon.svg', width: 20)
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      trailing: Container(
                        width: 135,
                        child: HittapaRoundButton(
                          isGreenColor: true,
                          text: LocaleKeys.global_accept.tr(),
                          onClick: () => onClickAccept(_user.uid),
                        ),
                      ),
                    );
                  },
                ),
            childCount: items.length),
      ),
    );
  }

  Widget sliverAcceptItem({List<String> items, String label, Color color, BuildContext context}) {
    return SliverStickyHeader(
      header: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFB8B8B8), width: 1))),
        padding: EdgeInsets.only(top: 40, bottom: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: color, width: 2))),
              child: Text(
                label,
                style: TextStyle(fontSize: 18, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: () {
                navigateToEventAttendeeScreen(
                    context: context,
                    onDiscard: () {
                      print('@@@@@ on discard');
                      Navigator.of(context).pop();
                    },
                    onAdd: () async {
                      print('@@@@@ on add');
                      Navigator.of(context).pop();
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop();
                      });
                      await showDialog(
                          context: context,
                          useSafeArea: false,
                          builder: (context) => StatefulBuilder(builder: (context, setState) {
                                return ConfirmDialog(
                                  title: Center(
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
                                          child: Text("Attendee succesfully added", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 24), textAlign: TextAlign.center),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  icon: Container(),
                                );
                              }));
                    },
                    event: event);
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFB8B8B8), width: 2))),
                child: Text(
                  'Add User +',
                  style: TextStyle(fontSize: 18, color: GOOGLE_COLOR, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
      sliver: SliverGrid.count(
        crossAxisCount: 3,
        children: others
            .map((e) => Container(
                    child: Column(children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: CachedNetworkImage(
                            width: 60,
                            height: 60,
                            imageUrl: e?.avatar ?? DEFAULT_AVATAR,
                            placeholder: (context, url) => Center(
                              child: SvgPicture.asset(
                                'assets/avatar_placeholder.svg',
                                width: 60,
                                height: 60,
                              ),
                            ),
                            errorWidget: (context, url, err) => Center(
                              child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        e?.userRole == 1
                            ? Positioned(
                                right: 0,
                                child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                              )
                            : Positioned(
                                right: 0,
                                child: SvgPicture.asset('assets/safe_icon.svg'),
                              ),
                        e?.userRole == 3
                            ? Positioned(
                                right: 0,
                                bottom: 0,
                                child: SvgPicture.asset('assets/svg/plus-circle.svg', color: BORDER_COLOR),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 0),
                    // width: 130,
                    child: Text(
                      '${e?.username} ${e?.birthday != null ? ageCalculate(e.birthday) : ""}${getGenderCharacter(e?.gender)}',
                      style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
                    ),
                  )
                ])))
            .toList(),
      ),
    );
  }

  Widget sliverStandbyItem({List<String> items, String label, Color color}) {
    return SliverStickyHeader(
      header: sliverHeader(title: label, underline: color, tailing: '(${items.length})'),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, i) => FutureBuilder<dynamic>(
                  future: NodeAuthService().getUser(items[i], null),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) return ListTile();
                    UserModel _user = UserModel.fromJson(snap.data['data']);
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(_user.avatar ?? DEFAULT_AVATAR),
                            )),
                            _user?.userRole == 1
                                ? Positioned(
                                    right: 0,
                                    child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                                  )
                                : Positioned(
                                    right: 0,
                                    child: SvgPicture.asset('assets/safe_icon.svg'),
                                  ),
                          ],
                        ),
                      ),
                      title: FutureBuilder(
                        future: (_user.location != null && _user.location.coordinates.length > 0)
                            ? distanceInKmBetweenEarthCoordinates(_user.location?.coordinates[0], _user.location?.coordinates[1], event.location?.coordinates[0], event.location?.coordinates[1])
                            : distanceInKmBetweenEarthCoordinates(0, 0, event.location?.coordinates[0], event.location?.coordinates[1]),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return Row(
                              children: [
                                Text(
                                  '${(snap.data / 1000).toStringAsFixed(2)} km',
                                  style: TextStyle(color: BORDER_COLOR, fontSize: 13),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/meet_point_icon.svg', width: 20)
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      subtitle: Text(
                        '${_user.username}, ${ageCalculate(_user?.birthday ?? 2000)}${getGenderCharacter(_user.gender)}',
                        style: TextStyle(fontSize: 17, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
                      ),
                      trailing: PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              LocaleKeys.global_accept.tr(),
                              style: TextStyle(color: NAVIGATION_ACTIVE_COLOR, fontWeight: FontWeight.w500),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(
                              LocaleKeys.event_detail_decline.tr(),
                              style: TextStyle(color: NAVIGATION_ACTIVE_COLOR, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                        offset: Offset(0, 60),
                        onSelected: (value) {
                          if (value == 1) onClickAcceptStandby(_user.uid);
                          if (value == 2) onDeclinedStandby(_user.uid);
                        },
                      ),
                    );
                  },
                ),
            childCount: items.length),
      ),
    );
  }

  onClickAccept(String uid) {
    List<String> _pending = event.participantsPending;
    List<String> _accepted = event.participantsAccepted;
    List<String> _standby = event.participantsStandby;

    if (_pending.remove(uid) && !_accepted.contains(uid)) {
      _accepted.add(uid);
      if (_accepted.length == event.maxParticipantsNo) {
        _standby = _standby + _pending;
      }
      NodeService().updateEvent(event.copyWith(participantsAccepted: _accepted, participantsPending: _pending, participantsStandby: _standby).toJson()).then((_) {});
    }
  }

  onDeclined(String uid) {
    List<String> _accepted = event.participantsAccepted;
    List<String> _declined = event.participantsDeclined;

    if (_accepted.remove(uid) && !_declined.contains(uid)) {
      _declined.add(uid);
      NodeService().updateEvent(event.copyWith(participantsDeclined: _declined, participantsAccepted: _accepted).toJson()).then((_) {});
    }
  }

  onClickAcceptStandby(String firebaseId) {
    List<String> _standby = event.participantsStandby;
    List<String> _accepted = event.participantsAccepted;

    if (_standby.remove(firebaseId) && !_accepted.contains(firebaseId)) {
      _accepted.add(firebaseId);
      NodeService().updateEvent(event.copyWith(participantsAccepted: _accepted, participantsPending: _standby).toJson()).then((_) {});
    }
  }

  onDeclinedStandby(String firebaseId) {
    List<String> _standby = event.participantsStandby;
    List<String> _declined = event.participantsDeclined;

    if (_standby.remove(firebaseId) && !_declined.contains(firebaseId)) {
      _declined.add(firebaseId);
      NodeService().updateEvent(event.copyWith(participantsDeclined: _declined, participantsPending: _standby).toJson()).then((_) {});
    }
  }
}
