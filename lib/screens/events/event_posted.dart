import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/event_unaccepted_card.dart';
import 'package:hittapa/widgets/hittapa_imageview.dart';
import 'dart:async';

import '../../config.dart';
import '../../global.dart';
import 'package:hittapa/global_export.dart';

class EventPosted extends StatefulWidget {
  final EventModel event;
  final UserModel owner;
  final List<File> files;

  EventPosted({this.event, this.owner, this.files});

  @override
  State<StatefulWidget> createState() => _EventPostedScreen();
}

class _EventPostedScreen extends State<EventPosted> {
  UserModel user;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      navigateToDashboardScreen(context, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    if (debug) print("EventSummary:build ${widget.event.imageUrls}");
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          user = state.user;
          return Scaffold(
              backgroundColor: CARD_BACKGROUND_COLOR,
              body: Stack(children: <Widget>[
                SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(children: <Widget>[
                        HittapaImageView(
                          title: widget.event.name,
                          eventId: widget.event.id,
                          images: widget.files.length > 0 ? [] : widget.event.imageUrls,
                          files: widget.files,
                          eventOwner: widget.owner,
                          user: widget.owner,
                          isGuest: true,
                        ),
                        Positioned(top: MediaQuery.of(context).size.width - 10, child: EventUnacceptedCard(widget.event, null, widget.owner, false, null, null)),
                        // Positioned(
                        //   top: MediaQuery.of(context).size.width-105,
                        //   left: 20,
                        //   child: InkWell(
                        //     child: Container(
                        //       width: 135,
                        //       height: 50,
                        //       alignment: Alignment.center,
                        //       padding: EdgeInsets.all(3),
                        //       decoration: BoxDecoration(
                        //         color: Color(0x30000000),
                        //         borderRadius: BorderRadius.all(Radius.circular(20)),
                        //         border: Border.all(color: Colors.white, width: 1)
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text('Upload own Image', style: TextStyle(color: Colors.white, fontSize: 15)),
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             children: [
                        //               Text('Option', style: TextStyle(color: Colors.white, fontSize: 15)),
                        //               widget.files.length == 0 ? SvgPicture.asset(
                        //                 "assets/svg/image_lock.svg",
                        //                 width: 25,
                        //                 height: 15,
                        //                 // color: BORDER_COLOR,
                        //               ) : Image(
                        //                 image: ExactAssetImage(widget.files[0].path),
                        //                 width: 25,
                        //                 height: 15
                        //               ),
                        //               SizedBox(width: 3),
                        //               widget.files.length > 1 ? Image(
                        //                 image: ExactAssetImage(widget.files[1].path),
                        //                 width: 25,
                        //                 height: 15
                        //               ) : SvgPicture.asset(
                        //                 "assets/svg/image_lock.svg",
                        //                 width: 25,
                        //                 height: 15,
                        //                 // color: BORDER_COLOR,
                        //               ),
                        //               SizedBox(width: 3),
                        //               widget.files.length > 2 ? Image(
                        //                 image: ExactAssetImage(widget.files[2].path),
                        //                 width: 25,
                        //                 height: 15
                        //               ) : SvgPicture.asset(
                        //                 "assets/svg/image_lock.svg",
                        //                 width: 25,
                        //                 height: 15,
                        //                 // color: BORDER_COLOR,
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ])),
                ])),
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                    ),
                    child: Center(
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
                            child: Text(LocaleKeys.create_event_posted.tr(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 24), textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child:
                                Text(LocaleKeys.create_event_we_value_your_opinion.tr(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17), textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(LocaleKeys.create_event_have_fun.tr(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    )),
              ]));
        });
  }
}
