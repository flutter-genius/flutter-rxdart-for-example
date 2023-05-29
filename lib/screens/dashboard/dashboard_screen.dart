import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/filter.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/screens/dashboard/activity_component.dart';
import 'package:hittapa/screens/dashboard/covid_component.dart';
import 'package:hittapa/screens/dashboard/home_component.dart';
import 'package:hittapa/screens/dashboard/message_component.dart';
import 'package:hittapa/screens/dashboard/notification_component.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/hittapa_bottombar.dart';
import 'package:hittapa/widgets/hittapa_header.dart';
import 'package:hittapa/widgets/hittapa_message_header.dart';
import 'package:hittapa/widgets/no_internet.dart';
import 'package:hittapa/widgets/no_location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardScreen extends StatefulWidget {
  final int currentPage;
  final int activies;
  final UserModel user;

  DashboardScreen({this.currentPage = 0, this.activies = 0, this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPage = 0;
  int _currentActivies = 0;
  // ignore: non_constant_identifier_names
  bool loading = true, is_location_allow = true, is_internet = true;
  String fcmToken;
  List _messages = [
    {'type': 'morning', 'message': 'Good morning', 'range': '05-12'},
    {'type': 'afternoon', 'message': 'Good afternoon', 'range': '12-19'},
    {'type': 'evening', 'message': 'Good evening', 'range': '19-05'},
    {'type': 'morning', 'message': 'This is morning message.', 'range': '05-12'},
    {'type': 'afternoon', 'message': 'This is afternoon message.', 'range': '12-19'},
    {'type': 'evening', 'message': 'This is evening message.', 'range': '19-05'},
  ];

  PageController _pageController = PageController(
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    checkInternetConnection();
    if (_currentPage == 0) _currentPage = widget.currentPage ?? 0;
    _currentActivies = widget.activies ?? 0;
    _pageController = PageController(initialPage: _currentPage);
    _getToken();
    _readyCallReceive(widget.user);
  }

  _readyCallReceive(UserModel user) {
    print('call....');
    final stream = FirebaseFirestore.instance.collection("calls").where("receiver", isEqualTo: user.uid).snapshots();
    stream.listen((value) {
      if (value.docs.length > 0) {
        print(value.docs[0]);
        navigateToReceiverScreen(context, value.docs[0]['channelName'], value.docs[0]['caller'], value.docs[0]['receiver']);
      }
    });
  }

  _getToken() async {
    String _firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
    print('@@@@@ firebase token: ' + _firebaseToken);
    NodeAuthService().updateUserToken(_firebaseToken);
  }

  checkLocationPermission() async {
    print("@@@@@ check the location permission on the dashboard");
    var _allow = await Permission.location.request();
    print(_allow);
    if (_allow.isGranted) {
      setState(() {
        is_location_allow = true;
      });
    } else {
      setState(() {
        is_location_allow = false;
      });
    }
  }

  checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("@@@@@ this is the internet connection");
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      if (is_internet) {
        setState(() {
          is_internet = false;
        });
      }
    } else {
      if (!is_internet) {
        setState(() {
          is_internet = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          FilterModel eventFilter = store.state.eventFilter;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: BACKGROUND_COLOR,
              toolbarHeight: _currentPage == 0 ? 40 : 40,
              flexibleSpace: _appBar(store),
              elevation: 0,
            ),
            backgroundColor: BACKGROUND_COLOR,
            body: Container(
              child: Column(
                children: [
                  // _appBar(store),
                  Expanded(
                    child: is_internet
                        ? Container(
                            child: PageView(
                            physics: new NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: <Widget>[
                              is_location_allow
                                  ? HomeComponent(
                                      onClick: checkInternetConnection,
                                    )
                                  : NoLocation(onClick: checkLocationPermission),
                              is_location_allow
                                  ? ActivitiesComponent(
                                      onClick: checkInternetConnection,
                                    )
                                  : NoLocation(onClick: checkLocationPermission),
                              MessageComponent(
                                onClick: checkInternetConnection,
                              ),
                              NotificationComponent(
                                onClick: checkInternetConnection,
                              ),
                              CovidComponent(
                                onClick: checkInternetConnection,
                              ),
                            ],
                          ))
                        : Container(
                            child: PageView(
                            physics: new NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: <Widget>[
                              NoInternet(onClick: checkInternetConnection),
                              NoInternet(onClick: checkInternetConnection),
                              NoInternet(onClick: checkInternetConnection),
                              NoInternet(onClick: checkInternetConnection),
                              NoInternet(onClick: checkInternetConnection),
                            ],
                          )),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Colors.white, boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0xFF696969), spreadRadius: 1, blurRadius: 4, offset: Offset(1, 1)),
              ]),
              child: is_internet && is_location_allow
                  ? HittapaBottomBar(
                      userId: store.state.user.uid,
                      bottomNavigationBarIndex: _currentPage,
                      onTabSelected: (value) => onTabSelected(value, store.dispatch, eventFilter),
                    )
                  : Container(height: 70),
            ),
          );
        });
  }

  Widget _appBar(store) {
    FilterModel eventFilter = store.state.eventFilter;
    UserModel user = store.state.user;
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 5),
      margin: EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(color: Colors.white),
      child: is_internet && is_location_allow
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(children: <Widget>[
                          _currentActivies == 1
                              ? IconButton(
                                  icon: SvgPicture.asset('assets/arrow-back.svg'),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              : Container(),
                          HittapaHeader(currentPage: _currentPage, messages: _messages, user: user),
                        ])),
                    Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateToSearchLocationScreen(context, store.state.user.location.coordinates[0], store.state.user.location.coordinates[1], store.state.user.location).then((v) {});
                                },
                                child: Container(
                                  child: SvgPicture.asset('assets/search_icon.svg'),
                                ),
                              ),
                              Center(
                                child: Stack(
                                  children: <Widget>[
                                    IconButton(
                                      color: Colors.transparent,
                                      onPressed: () => navigateToFilterScreen(context),
                                      icon: SvgPicture.asset('assets/filter_icon.svg'),
                                    ),
                                    if (eventFilter != null && eventFilter.getCount() > 0)
                                      Positioned(
                                        bottom: 10,
                                        left: 3,
                                        child: Container(
                                          decoration: BoxDecoration(color: BORDER_COLOR, borderRadius: const BorderRadius.all(Radius.circular(8))),
                                          width: 16,
                                          height: 16,
                                          child: Center(
                                            child: Text(
                                              eventFilter.getCount().toString(),
                                              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  navigateToCategoryScreen(context, appstate: store.state, pathIndex: 1);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: SvgPicture.asset('assets/svg/plus-circle.svg'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  navigateToMenuScreen(context);
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: GRAY_COLOR,
                                              blurRadius: 10.0,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                            child: Container(
                                              child: CachedNetworkImage(
                                                width: 80,
                                                height: 80,
                                                imageUrl: user?.avatar ?? DEFAULT_AVATAR,
                                                placeholder: (context, url) => Center(
                                                  child: SvgPicture.asset(
                                                    'assets/avatar_placeholder.svg',
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                ),
                                                errorWidget: (context, url, err) => Center(
                                                  child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                      user?.userRole == 1
                                          ? Positioned(
                                              right: 0,
                                              top: 0,
                                              child: SvgPicture.asset(
                                                'assets/svg/hittapa-admin-mark.svg',
                                                height: 15,
                                                width: 15,
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                // _currentPage == 0
                //     ? HittapaMessageHeader(
                //         messages: _messages,
                //       )
                //     : Container(),
              ],
            )
          : HittapaHeader(currentPage: _currentPage, messages: _messages, user: user),
    );
  }

  // event listener on bottom navigation bar
  onTabSelected(int value, Function dispatch, FilterModel eventFilter) {
    setState(() {
      this._currentPage = value;
    });
    _pageController.animateToPage(value, duration: Duration(milliseconds: 700), curve: Curves.easeInCubic);
    if (this._currentPage == 0 && value == 0) {
      dispatch(dispatch(SetEventFilter(filter: eventFilter)));
    }
  }
}
