
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/model.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/store_service.dart';
import 'dart:io' show Platform;
import 'my_location_dialog.dart';
import 'package:hittapa/global_export.dart';

class HittapaBottomAppBarItem {
  HittapaBottomAppBarItem({this.icon, this.activeIcon, this.text});

  Widget icon;
  Widget activeIcon;
  String text;
}

class HittapaBottomBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;
  final int bottomNavigationBarIndex;
  final String userId;

  HittapaBottomBar({this.onTabSelected, this.bottomNavigationBarIndex, this.userId});

  @override
  _HittapaBottomBarState createState() => _HittapaBottomBarState();
}

class _HittapaBottomBarState extends State<HittapaBottomBar>
    with TickerProviderStateMixin {
  AnimationController _controller;
  MyLocationDialog locationDialog;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    locationDialog = MyLocationDialog(
      context: context,
      controller: _controller,
    );
    locationDialog.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Address>>(
        future: getAddressed(),
        builder: (context, snap) {
          return Container(
            height: 90,
            child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  onTap: widget.onTabSelected,
                  currentIndex: widget.bottomNavigationBarIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 10,
                  unselectedItemColor: NAVIGATION_NORMAL_TEXT_COLOR,
                  unselectedLabelStyle: TextStyle(
                      color: NAVIGATION_NORMAL_COLOR, fontWeight: FontWeight.w600),
                  selectedLabelStyle: TextStyle(
                      color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600),
                  selectedItemColor: GRADIENT_COLOR_ONE,
                  unselectedFontSize: 10,
                  items: [
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        child: Container(
                          child: SvgPicture.asset(
                            'assets/new_home.svg',
                            height: 30,
                            color: (widget.bottomNavigationBarIndex == 0)
                                ? GRADIENT_COLOR_ONE
                                : NAVIGATION_NORMAL_TEXT_COLOR,
                          ),
                        ),
                        onLongPress: () {
                          locationDialog.showLocationDialog(context);
                        },
                      ),
                      title: Container(
                        child: Text(
                          LocaleKeys.home_home.tr(),
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        child: SvgPicture.asset(
                          'assets/new_activities.svg',
                          height: 30,
                          color: (widget.bottomNavigationBarIndex == 1)
                              ? GRADIENT_COLOR_ONE
                              : NAVIGATION_NORMAL_TEXT_COLOR,
                        ),
                      ),
                      title: Container(
                        child: Text(
                          LocaleKeys.home_activities.tr(),
                        ),
                      )
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        height: 30,
                        child: Stack(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/new_messagge.svg',
                              height: 30,
                              color: (widget.bottomNavigationBarIndex == 2)
                                  ? GRADIENT_COLOR_ONE
                                  : NAVIGATION_NORMAL_TEXT_COLOR,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(FB.MESSAGE_COLLECTION)
                                  .doc(widget.userId.toString())
                                  .collection(FB.UNREAD_COLLECTION)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                                if (snap.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snap.connectionState == ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                if ((snap.data.docs ?? []).length > 0)
                                  return Positioned(
                                    right: 0,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: GRADIENT_COLOR_TWO,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text(snap.data.docs.length.toString(), overflow: TextOverflow.clip, style: TextStyle(fontSize: 11, color: Colors.white),),
                                    ),
                                  );
                                return Container(width: 0,);
                              },
                            )
                          ],
                        ),
                      ),
                      title: Container(
                        child: Text(
                          LocaleKeys.home_message.tr(),
                        ),
                      )
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        height: 30,
                        child: Stack(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/new_notification.svg',
                              height: 30,
                              color: (widget.bottomNavigationBarIndex == 3)
                                  ? GRADIENT_COLOR_ONE
                                  : NAVIGATION_NORMAL_TEXT_COLOR,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(FB.NOTIFICATION_COLLECTION)
                                  .doc(widget.userId.toString())
                                  .collection(FB.NOTIFICATION_COLLECTION)
                                  .where('status', isEqualTo: false)
                                  .snapshots(),
                              builder: (context, snap) {
                                if (snap.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snap.connectionState == ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                if ((snap.data?.docs ?? []).length > 0)
                                  return Positioned(
                                    right: 0,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: GRADIENT_COLOR_TWO,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text(snap.data.docs.length.toString(), overflow: TextOverflow.clip, style: TextStyle(fontSize: 11, color: Colors.white),),
                                    ),
                                  );
                                return Container(width: 0,);
                              },
                            )
                          ],
                        ),
                      ),
                      title: Container(
                        child: Text(
                          LocaleKeys.home_notification.tr(),
                        ),
                      )
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.only(bottom: 9, top: 3),
                        child: Image.asset(widget.bottomNavigationBarIndex == 4 ?  'assets/images/covid_active.png' : 'assets/images/covid.png', width: 20, height: 20,),
                      ),
                      title: Container(
                        child: Text(
                          LocaleKeys.home_covid.tr(),
                        ),
                      )
                    ),
                  ],
                ),
          );
        }
    );
  }
}
