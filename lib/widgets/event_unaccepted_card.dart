import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/requirement_widget.dart';
import 'package:intl/intl.dart';
import 'package:hittapa/services/socket_service.dart';
import 'package:hittapa/global_export.dart';

// ignore: must_be_immutable
class EventUnacceptedCard extends StatefulWidget {
  EventModel event;
  UserModel user;
  UserModel eventOwner;
  bool isExpanded;
  Function onExpanded;
  Function onRequirement;

  @override
  EventUnacceptedCard(this.event, this.user, this.eventOwner, this.isExpanded, this.onExpanded, this.onRequirement);
  _EventUnacceptedCardScreen createState() => _EventUnacceptedCardScreen();
}

class _EventUnacceptedCardScreen extends State<EventUnacceptedCard> {
  EventModel event;
  UserModel user, eventOwner;
  bool _isPending = false;

  final SocketService socketService = injector.get<SocketService>();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    event = widget.event;
    user = widget.user;
    if (widget.user != null && widget.user.uid != null && event.statusType(widget.user.uid) == ApplicantStatusType.pending) {
      _isPending = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    eventOwner = widget.eventOwner;
    if (_isPending) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          width: MediaQuery.of(context).size.width - 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(right: 7, left: 7, bottom: 10, top: 10),
                        child: Text(
                          this.event.name,
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width / 19.5, fontWeight: FontWeight.w600, color: NAVIGATION_NORMAL_TEXT_COLOR),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: SHADOW_COLOR,
                    spreadRadius: 0,
                    blurRadius: 5,
                  ),
                ]),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 170,
                          child: FlatButton(
                              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                              color: Colors.white,
                              child: Container(
                                child: Center(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'assets/calendar-outline.svg',
                                                width: 16,
                                                height: 18,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                LocaleKeys.event_detail_date_time.tr(),
                                                style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Container(
                                          width: 140,
                                          child: Text(
                                            '${event.isFlexibleDate ? 'Any date' : ''} '
                                            '${DateFormat('${event.isFlexibleDate ? '' : 'd MMM '}'
                                                '${event.isFlexibleStartTime ? '' : 'HH:mm'}').format(event.startDT)}-'
                                            '${(event.isFlexibleDate && event.isFlexibleStartTime) ? ' and time' : event.isFlexibleStartTime ? 'Any time' : ''}'
                                            '${event.isFlexibleDate ? 'Any date' : ''} '
                                            '${DateFormat('${event.isFlexibleDate ? '' : ''}'
                                                '${event.isFlexibleEndTime ? '' : 'HH:mm'}').format(event.endDT)}'
                                            '${(event.isFlexibleDate && event.isFlexibleEndTime) ? ' and time' : event.isFlexibleEndTime ? 'Any time' : ''}',
                                            style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                              ),
                              onPressed: () {
                                navigateToDashboardScreen(context, user, position: 1, activies: 1);
                                // navigateToDetailScreen(context, widget.event);
                              }),
                        ),
                        Expanded(
                          child: FlatButton(
                            color: Colors.white,
                            child: Container(
                              child: Center(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  'assets/meet_point_icon.svg',
                                                  width: 20,
                                                  height: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  LocaleKeys.create_event_meeting_point.tr(),
                                                  style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )),
                                        SizedBox(width: 3),
                                        FutureBuilder(
                                          future: getDistance(event),
                                          builder: (context, value) {
                                            if (value?.data == null) return Container();
                                            return Text(
                                              value?.data.toString() + ' km',
                                              style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                            );
                                          },
                                        )
                                      ],
                                    )),
                              ])),
                            ),
                            onPressed: () {
                              navigateToCheckLocationScreen(context, event.location.coordinates[0], event.location.coordinates[1], false, event.name, event.location.address, event);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 20, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            widget.onRequirement();
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 170,
                                  child: Text(
                                    LocaleKeys.event_detail_participants_gender_age.tr(),
                                    style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 1, right: 1, top: 2),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 1),
                                            child: SvgPicture.asset(
                                              'assets/group_icon.svg',
                                              width: 21,
                                              height: 17,
                                              color: BORDER_COLOR,
                                            ),
                                          ),
                                          Text(
                                            (event != null ? (event.unLimitedMaxParticipantsNo ? LocaleKeys.create_event_unlimited.tr() : event.maxParticipantsNo.toString()) : 0),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      ' ${event.requirements[0]?.value != null ? '${event.requirements[0].value[0].toUpperCase() + event.requirements[0].value.substring(1, event.requirements[0].value.length)}' ?? 'All gender' : 'All gender'}, ',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${event.requirements[1] != null ? '${event.requirements[1].value ?? '18'}-${int.parse(event.requirements[1].other ?? '66') < 64 ? event.requirements[1].other : (event.requirements[1].other ?? '65') + '+'}' : ''}',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            widget.onRequirement();
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  LocaleKeys.event_detail_we_will_speak.tr(),
                                  style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 1),
                                      child: SvgPicture.asset(
                                        'assets/svg/language.svg',
                                        color: BORDER_COLOR,
                                        fit: BoxFit.fill,
                                        width: 18,
                                        height: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      event.requirements[2].other != null ? event.requirements[2].other : 'English',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RequirementWidget(event.requirements, widget.onRequirement, _isPending),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 5, left: 16),
                    child: Text(
                      LocaleKeys.event_detail_description.tr(),
                      style: TextStyle(color: DART_TEXT_COLOR, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: event.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: DART_TEXT_COLOR,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ],
          ));
    } else {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width - 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(right: 7, left: 7, bottom: 10, top: 10),
                        child: Text(
                          this.event.name,
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width / 19.5, fontWeight: FontWeight.w600, color: NAVIGATION_NORMAL_TEXT_COLOR),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: SHADOW_COLOR,
                    spreadRadius: 0,
                    blurRadius: 5,
                  ),
                ]),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: FlatButton(
                              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                              color: Colors.white,
                              child: Container(
                                child: Center(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/calendar-outline.svg',
                                          width: 16,
                                          height: 18,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          LocaleKeys.event_detail_date_time.tr(),
                                          style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    width: 140,
                                    child: Text(
                                      '${event.isFlexibleDate ? 'Any date' : ''} '
                                      '${DateFormat('${event.isFlexibleDate ? '' : 'd MMM '}'
                                          '${event.isFlexibleStartTime ? '' : 'HH:mm'}').format(event.startDT)}-'
                                      '${(event.isFlexibleDate && event.isFlexibleStartTime) ? ' and time' : event.isFlexibleStartTime ? 'Any time' : ''}'
                                      '${event.isFlexibleDate ? 'Any date' : ''} '
                                      '${DateFormat('${event.isFlexibleDate ? '' : ''}'
                                          '${event.isFlexibleEndTime ? '' : 'HH:mm'}').format(event.endDT)}'
                                      '${(event.isFlexibleDate && event.isFlexibleEndTime) ? ' and time' : event.isFlexibleEndTime ? 'Any time' : ''}',
                                      style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ])),
                              ),
                              onPressed: () {
                                navigateToDashboardScreen(context, user, position: 1, activies: 1);
                                // navigateToDetailScreen(context, widget.event);
                              }),
                        ),
                        Container(
                          width: 150,
                          child: FlatButton(
                            color: Colors.white,
                            child: Container(
                              height: 50,
                              child: Center(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      top: 8,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/meet_point_icon.svg',
                                          width: 20,
                                          height: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          LocaleKeys.create_event_meeting_point.tr(),
                                          style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 3,
                                ),
                                FutureBuilder(
                                  future: getDistance(event),
                                  builder: (context, value) {
                                    if (value?.data == null) return Container();
                                    return Text(
                                      value?.data.toString() + ' km',
                                      style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                    );
                                  },
                                )
                              ])),
                            ),
                            onPressed: () {
                              navigateToCheckLocationScreen(context, event.location.coordinates[0], event.location.coordinates[1], false, event.name, event.location.address, event);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 20, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            widget.onRequirement();
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  child: Text(
                                    LocaleKeys.event_detail_participants_gender_age.tr(),
                                    style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 1, right: 1, top: 2),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 1),
                                            child: SvgPicture.asset(
                                              'assets/group_icon.svg',
                                              width: 21,
                                              height: 17,
                                              color: BORDER_COLOR,
                                            ),
                                          ),
                                          Text(
                                            (event != null ? (event.unLimitedMaxParticipantsNo ? LocaleKeys.create_event_unlimited.tr() : event.maxParticipantsNo.toString()) : 0),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      ' ${event.requirements[0]?.value != null ? '${event.requirements[0].value[0].toUpperCase() + event.requirements[0].value.substring(1, event.requirements[0].value.length)}' ?? 'All gender' : 'All gender'}, ',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${event.requirements[1] != null ? '${event.requirements[1].value ?? '18'}-${int.parse(event.requirements[1].other ?? '66') < 64 ? event.requirements[1].other : (event.requirements[1].other ?? '65') + '+'}' : ''}',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            widget.onRequirement();
                          },
                          child: Container(
                            height: 55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  LocaleKeys.event_detail_we_will_speak.tr(),
                                  style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 1),
                                      child: SvgPicture.asset(
                                        'assets/svg/language.svg',
                                        color: BORDER_COLOR,
                                        fit: BoxFit.fill,
                                        width: 18,
                                        height: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      event.requirements[2].other != null ? event.requirements[2].other : 'English',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RequirementWidget(event.requirements, widget.onRequirement, false),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 5, left: 16),
                    child: Text(
                      LocaleKeys.event_detail_description.tr(),
                      style: TextStyle(color: DART_TEXT_COLOR, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: event.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: DART_TEXT_COLOR,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            ],
          ));
    }
  }
}
