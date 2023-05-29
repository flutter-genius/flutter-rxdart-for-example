import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/add_asset_dialog.dart';
import 'package:hittapa/widgets/bottom_widget.dart';
import 'package:hittapa/widgets/event_accepted_card.dart';
import 'package:hittapa/widgets/event_admin_bottom_slider.dart';
import 'package:hittapa/widgets/event_request_button.dart';
import 'package:hittapa/widgets/event_unaccepted_card.dart';
import 'package:hittapa/widgets/hittapa_imageview.dart';
import 'package:hittapa/widgets/my_bottom_slider.dart';
import 'package:hittapa/widgets/past_bottom_slider_new.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hittapa/services/socket_service.dart';

import 'package:hittapa/services/dynamic_link_service.dart';
import 'package:hittapa/global_export.dart';

import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class EventDetailScreen extends StatefulWidget {
  EventModel event;
  EventDetailScreen({this.event});
  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
  PanelController _panelController = PanelController();
  AnimationController _controller;
  NewAddAssetsDialog _locationDialog;

  /// change for the 1 tasks for user report function, before that was AddAssetsdialog
  ReportBehaviorDialog _reportDialog;
  bool isOpen = false;
  int _rate = 0;
  EventModel event;
  String isAction;
  UserModel user;
  UserModel eventOwner;
  List<UserModel> _others = [];
  final SocketService socketService = injector.get<SocketService>();
  var deepLinkUrl;
  bool isExpanded, isAccepted;

  generateDrivingCell(List<PostRequirement> list) {
    PostRequirement _driving;
    list?.forEach((element) {
      if (element.requirementId == 8) _driving = element;
    });
    if (_driving == null) return Container();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          Text(
            LocaleKeys.toast_select_driver_license.tr(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/driving_licence.svg',
                color: BORDER_COLOR,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                _driving.value != null ? _driving.other.replaceAll('Cat.', '') : 'A1',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }

  generateChildrenCell(List<PostRequirement> list) {
    PostRequirement _children;
    list?.forEach((element) {
      if (element.requirementId == 9) _children = element;
    });
    if (_children == null) return Container();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            LocaleKeys.event_detail_children_age.tr(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/has_child_icon.svg',
                color: BORDER_COLOR,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                '${_children.value} - ${_children.other}',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }

  generateTempoCell(List<PostRequirement> list) {
    PostRequirement _tempo;
    list?.forEach((element) {
      if (element.requirementId == 7) _tempo = element;
    });
    if (_tempo == null) return Container();
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            LocaleKeys.global_tempo.tr(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/tempo_icon.svg',
                color: BORDER_COLOR,
                width: 15,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                _tempo.value,
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }

  onRequirement() async {
    print('@@@@@ open requirement modal');
    await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) => ConfirmDialog(
            isEvent: true,
            isCenter: true,
            yourWidget: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Text('Particpant, Gender and Age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    child: Text("Are part of ${this.eventOwner.username}'s requirement for attendees to meet un in other to joing the event.",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gender:',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ' ${event.requirements[0]?.value != null ? '${event.requirements[0].value[0].toUpperCase() + event.requirements[0].value.substring(1, event.requirements[0].value.length)}' ?? 'All gender' : 'All gender'}, ',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Number of participants:',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    (event != null ? (event.unLimitedMaxParticipantsNo ? LocaleKeys.create_event_unlimited.tr() : event.maxParticipantsNo.toString()) : 0),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: SvgPicture.asset(
                                      'assets/group_icon.svg',
                                      width: 21,
                                      height: 14,
                                      color: BORDER_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age group:',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${event.requirements[1] != null ? '${event.requirements[1].value ?? '18'}-${int.parse(event.requirements[1].other ?? '66') < 64 ? event.requirements[1].other : (event.requirements[1].other ?? '65') + '+'}' : ''}',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Speaking Language',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
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
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        generateTempoCell(this.event.requirements),
                        generateDrivingCell(this.event.requirements),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [generateChildrenCell(this.event.requirements)],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Text("OBS! All parents/guardian are responslible for the children in their care. Thank you for understanding",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 10),
                      alignment: Alignment.bottomRight,
                      // width: MediaQuery.of(context).size.width-74,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              child: SvgPicture.asset(
                            'assets/svg/close.svg',
                            width: 21,
                            height: 21,
                            color: Colors.white,
                          ))))
                ],
              ),
            )));
  }

  onExpanded() async {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  _loadSocket() async {
    if (!isOpen) {
      isOpen = true;
      _getOwner();
      _getDeepLinkUrl();
      _getUsers();
      socketService.socket.on("send_event", (data) {
        print('@@@@@ this is the update the event from socket in event detail page screen');
        EventModel _event = EventModel.fromJson(data);
        event = _event;
        _getUsers();
        if (mounted) {
          if (_event.id == event.id) {
            setState(() {});
          }
        }
      });
    }
  }

  _getDeepLinkUrl() async {
    deepLinkUrl = await DynamicLinkService().createDeepLink(event.id);
    print('********** this is the deeplink url *******************');
    print(deepLinkUrl);
  }

  _getUsers() async {
    List<String> _lists = event.participantsAccepted;
    _others = [];
    var _data = {'lists': _lists};
    var _result = await NodeService().getUsers(_data);
    if (_result != null && _result['data'] != null) {
      var dd = _result['data'];
      for (int i = 0; i < dd.length; i++) {
        UserModel userModel = UserModel.fromJson(dd[i]);
        if (userModel.uid != event?.ownerId) {
          _others.add(userModel);
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  _getOwner() async {
    var _result = await NodeAuthService().getUser(event?.ownerId, null);
    if (_result != null && _result['data'] != null) {
      eventOwner = UserModel.fromJson(_result['data']);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    socketService.socket.connect();
    isExpanded = false;
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    event = widget.event;
  }

  @override
  void dispose() {
    _controller.dispose();
    socketService.socket.dispose();
    // _channel.sink.close();
    super.dispose();
  }

  onCall() async {
    _panelController.close();

    // Get microphone permission
    await [Permission.microphone].request();

    String channelName = event.id + '_' + user.uid;

    FirebaseFirestore.instance.collection('calls').doc(channelName).set({
      'caller': user.uid,
      'receiver': event?.ownerId,
      'channelName': channelName,
    }).then((value) => {navigateToCallerScreen(globalContext, channelName, event, eventOwner)});
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          user = state.user;
          _locationDialog = new NewAddAssetsDialog(
            context: context,
            controller: _controller,
            event: event,
            user: user,
            isForward: true,
          );
          _reportDialog = new ReportBehaviorDialog(
            context: context,
            controller: _controller,
            event: event,
            user: user,
            isForward: true,
          );
          _loadSocket();
          _locationDialog.initState();
          _reportDialog.initState();
          return Builder(
            builder: (context) {
              isAccepted = event.statusType(user.uid) == ApplicantStatusType.my ||
                  event.statusType(user.uid) == ApplicantStatusType.accepted ||
                  event.statusType(user.uid) == ApplicantStatusType.pastAttendees ||
                  event.statusType(user.uid) == ApplicantStatusType.pastMy;
              double minHeight = 0;
              double maxHeight = 1;
              Widget _header = Container();
              Widget _body = Container();
              if (event.statusType(user.uid) == ApplicantStatusType.my) {
                minHeight = 120;
                maxHeight = MediaQuery.of(context).size.height - 60;
                _body = MyEventBottomBody(
                  event: event,
                  others: _others,
                  controller: _panelController,
                );
                _header = MyEventBottomHeader(
                  event: event,
                  eventOwner: eventOwner,
                  controller: _panelController,
                );
              }

              if (event.statusType(user.uid) == ApplicantStatusType.pastMy ||
                  event.statusType(user.uid) == ApplicantStatusType.pastAttendees ||
                  (event.isPassed && (event.feedback ?? []).length > 0)) {
                minHeight = 160;
                maxHeight = MediaQuery.of(context).size.height / 2;
                _body = PastBottomBody(
                  controller: _panelController,
                  rate: _rate,
                  user: user,
                  event: event,
                );
                _header = PastBottomHeader(
                  controller: _panelController,
                  event: event,
                  user: user,
                  onTapRate: (value) => setState(() => _rate = value),
                  rate: _rate,
                );
              }

              if (event.statusType(user.uid) == ApplicantStatusType.guest && event?.isAdminEvent != null && event?.isAdminEvent) {
                minHeight = 120;
                maxHeight = MediaQuery.of(context).size.height - 60;
                _body = EventAdminBottomBody(
                  event: event,
                  others: _others,
                  controller: _panelController,
                  user: user,
                  eventOwner: eventOwner,
                  onCall: () {
                    onCall();
                  },
                );
                _header = EventAdminBottomHeader(
                  event: event,
                  eventOwner: eventOwner,
                  controller: _panelController,
                  user: user,
                );
              }

              return Scaffold(
                backgroundColor: CARD_BACKGROUND_COLOR,
                body: SlidingUpPanel(
                  color: Colors.transparent,
                  controller: _panelController,
                  backdropEnabled: true,
                  renderPanelSheet: true,
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                  boxShadow: <BoxShadow>[
                    const BoxShadow(color: const Color(0x56C9CFD7), blurRadius: 22, offset: Offset(0, -12)),
                  ],
                  body: Stack(children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.width + (isAccepted ? 600 : 550),
                            child: Stack(children: <Widget>[
                              HittapaImageView(
                                title: event.name,
                                eventId: event.id,
                                images: event.imageUrls,
                                files: null, //widget.images,
                                eventOwner: eventOwner,
                                user: user,
                                isGuest: event.statusType(user.uid) == ApplicantStatusType.full ||
                                        event.statusType(user.uid) == ApplicantStatusType.guest ||
                                        event.statusType(user.uid) == ApplicantStatusType.pending
                                    ? true
                                    : false,
                              ),
                              Positioned(
                                top: isAccepted ? MediaQuery.of(context).size.width - 40 : MediaQuery.of(context).size.width,
                                child: isAccepted
                                    ? EventAcceptedCard(event, user, eventOwner, isExpanded, onExpanded, onRequirement)
                                    : EventUnacceptedCard(event, user, eventOwner, isExpanded, onExpanded, onRequirement),
                              ),
                            ])),
                      ])),
                    ),
                    Container(
                      height: 95,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        actions: <Widget>[
                          IconButton(
                            icon: SvgPicture.asset(Platform.isAndroid ? 'assets/svg/android-share.svg' : 'assets/share_icon.svg'),
                            onPressed: () {
                              FlutterShare.share(
                                title: event.name,
                                linkUrl: deepLinkUrl,
                                chooserTitle: LocaleKeys.menu_share.tr(),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () async {
                              isAction = await _locationDialog.showAddDialog(context, deepLinkUrl);
                              if (isAction != null) {
                                _reportDialog.showAddDialog(context, _others, eventOwner);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: HittapaBottomWidget(
                          event: event,
                          user: user,
                          users: _others,
                          eventOwner: eventOwner,
                          state: state,
                        )),
                  ]),
                  collapsed: Container(),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                  header: _header,
                  panel: _body,
                ),
                // floatingActionButton: showFloatingActionButton(context, event, user, eventOwner),
              );
            },
          );
        });
  }
}

Widget showFloatingActionButton(BuildContext context, EventModel event, UserModel user, UserModel eventOwner) {
  if (event.statusType(user.uid) == ApplicantStatusType.guest) return EventRequestButton(context: context, event: event, user: user, eventOwner: eventOwner);
  return null;
}
