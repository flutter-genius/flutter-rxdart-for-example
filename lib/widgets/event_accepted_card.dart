import 'package:add_2_calendar/add_2_calendar.dart' as CalenderEvent;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/requirement_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hittapa/models/models.dart';

import 'package:hittapa/services/socket_service.dart';

import '../models/user.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class EventAcceptedCard extends StatefulWidget {
  EventModel event;
  UserModel user;
  UserModel eventOwner;
  bool isExpanded;
  Function onExpanded;
  Function onRequirement;
  @override
  EventAcceptedCard(this.event, this.user, this.eventOwner, this.isExpanded, this.onExpanded, this.onRequirement);
  _EventAcceptedCardScreen createState() => _EventAcceptedCardScreen();
}

class _EventAcceptedCardScreen extends State<EventAcceptedCard> {
  EventModel event;
  UserModel user, eventOwner;
  bool _isconnected = false;
  bool _isPending = false;

  final SocketService socketService = injector.get<SocketService>();

  // ignore: unused_element
  _getData(String apiToken, String id) async {
    var _result = await NodeAuthService().getUser(id, apiToken);
    print(_result);
    setState(() {
      if (_result != null && _result['data'] != null) {
        eventOwner = UserModel.fromJson(_result['data']);
      }
    });
  }

  @override
  void initState() {
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
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (context, store) {
        AppState state = store.state;
        if (user == null) {
          user = state.user;
        }
        if (!_isconnected) {
          _isconnected = true;
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFD8D8D8),
              spreadRadius: 0,
              blurRadius: 3,
            ),
          ]),
          width: MediaQuery.of(context).size.width - 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 7, left: 7, bottom: 15, top: 27),
                        child: Text(
                          event.name,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: NAVIGATION_NORMAL_TEXT_COLOR),
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
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(left: 12, top: 12, bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Container(
                    width: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 0, right: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/calendar-outline.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  LocaleKeys.event_detail_date_time.tr(),
                                  style: TextStyle(color: BORDER_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  navigateToDashboardScreen(context, user, position: 1, activies: 1);
                                },
                                child: Container(
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
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            widget.user == null || event.isPassed || _isPending
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      CalenderEvent.Add2Calendar.addEvent2Cal(CalenderEvent.Event(
                                        title: event.name,
                                        description: event.description,
                                        location: event.location.address,
                                        startDate: event.startDT,
                                        endDate: event.endDT,
                                      ));
                                    },
                                    child: Text(
                                      LocaleKeys.widget_add_calendar.tr(),
                                      style: TextStyle(color: GRADIENT_COLOR_TWO, fontWeight: FontWeight.w600, fontSize: 14),
                                    ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        if (!_isPending) {
                          navigateToCheckLocationScreen(context, event.location.coordinates[0], event.location.coordinates[1], true, event.name, event.location.address, event);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 0, right: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/meet_point_icon.svg',
                                    width: 21,
                                    height: 16,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              _isPending
                                  ? FutureBuilder(
                                      future: getDistance(event),
                                      builder: (context, value) {
                                        if (value?.data == null) return Container();
                                        return Text(
                                          value?.data.toString() + ' km',
                                          style: TextStyle(fontSize: 15, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width / 2 - 55,
                                      child: Text(
                                        event.location.address,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 14, color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          )
                        ],
                      ))
                ]),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        widget.onRequirement();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 12),
                        width: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
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
                                    Text(
                                      event.requirements[0]?.value != null
                                          ? event.requirements[0].value.toLowerCase() == "all_gender"
                                              ? 'All '
                                              : '${event.requirements[0].value[0].toUpperCase() + event.requirements[0].value.substring(1, event.requirements[0].value.length)}' ?? 'All '
                                          : 'All ',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                        child: Text(
                                      '${event.requirements[1] != null ? '${event.requirements[1].value ?? '18'}-${int.parse(event.requirements[1].other ?? '66') < 64 ? event.requirements[1].other : (event.requirements[1].other ?? '65') + '+'}' : ''}',
                                      style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w600),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.onRequirement();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
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
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RequirementWidget(event.requirements, widget.onRequirement, true),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5, left: 16),
                child: Text(
                  LocaleKeys.event_detail_description.tr(),
                  style: TextStyle(color: DART_TEXT_COLOR, fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
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
              )
            ],
          ),
        );
      },
    );
  }
}
