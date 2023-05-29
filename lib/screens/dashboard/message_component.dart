import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/message.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

const _messageCreatedAtField = 'createdAtDT';

class MessageComponent extends StatefulWidget {
  final Function onClick;
  const MessageComponent({
    Key key,
    this.onClick,
  }) : super(key: key);
  
  @override
  _MessageComponentState createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  List<EventModel> _events = [];
  UserModel _user;
  bool isGetted = false;

  _getEvents() async{
    _events = _events.where((element) => element.id != AdminEvent.id).toList();
    Map _data = {
        'id': _user.uid,
        'startDT': DateTime.now().toUtc()?.millisecondsSinceEpoch
      };
      // _events.add(AdminEvent);
      var _result = await NodeService().getEventsAccepted(_data);
      if(_result != null && _result['data']!= null){
        if(mounted){
          setState(() {
            _result['data'].forEach((e) {
              EventModel _event = EventModel.fromJson(e);
              int _index = _events.indexWhere((element) => element.id == _event.id);
              if (_index < 0) _events.add(_event);
              else _events[_index] = _event;
            });
            // _events.sort((a, b) => b.updatedAtDT.compareTo(a.updatedAtDT));
            // _events.sort((a, b) => b.createdAtDT.compareTo(a.createdAtDT));
          });
        }
      }
      _result = await NodeService().getEventsByUser(_data);
      if(_result != null && _result['data']!= null){
        if(mounted){
          setState(() {
            _result['data'].forEach((e) {
              EventModel _event = EventModel.fromJson(e);
              int _index = _events.indexWhere((element) => element.id == _event.id);
              if (_index < 0) {
                if(_event.participantsAccepted.length > 0) _events.add(_event);
              }
              else _events[_index] = _event;
            });
            // if (_events.length > 1) {
            //   _events.sort((a, b) => b.updatedAtDT.compareTo(a.updatedAtDT));
            //   _events.reversed.toList();
            // }
            // _events.sort((a, b) => b.createdAtDT.compareTo(a.createdAtDT));
          });
        }
      }
      _events.sort((a, b) => b.updatedAtDT.compareTo(a.updatedAtDT));
      _events.insert(0, AdminEvent);
  }

  _loadData() async {
    if(!isGetted) {
      await widget.onClick();
      isGetted = true;
      _getEvents();
    }
    _timeInterval();
  }

  _timeInterval() {
    Timer.periodic(new Duration(seconds: 10),  (timer){
      if (mounted) {
        _getEvents();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) {
          AppState state = store.state;
          _user = state.user;
          _loadData();
        },
        builder: (context, store) {

          // Fetching list of events ids where user is participant
          if (_events.isEmpty) {
            return Scaffold(
                backgroundColor: BACKGROUND_COLOR,
                body: showNoChatRooms());
          }

          return Scaffold(
            backgroundColor: BACKGROUND_COLOR,
            body: ListView.separated(
                padding: EdgeInsets.only(bottom: 65),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  EventModel _event = _events[index];
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('${FB.CHAT_COLLECTION}/${_event.id}/${FB.EVENT_CHATROOM_COLLECTION}')
                          .orderBy(_messageCreatedAtField, descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, messagesnapshot) {
                        if (!messagesnapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        if (messagesnapshot.data.docs.length > 0)
                          return showChatRooms(context, _event, MessageModel.fromFB(messagesnapshot.data.docs[0]), _user.uid);

                        return showChatRooms(context, _event,
                            MessageModel(text: LocaleKeys.message_no_chat.tr() + " ${_event.name}"), _user.uid);
                      });
                },
                separatorBuilder: (context, index) => buildSeparator(context, index)),
          );
        });
  }

  Widget showChatRooms(BuildContext context, EventModel _event, MessageModel message, String userId) {
    if (_event.id == ADMINMESSAGEID)
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 11),
          height: 75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                child: GFAvatar(
                    backgroundImage: CachedNetworkImageProvider(_event.imageUrl ?? ''),
                    shape: GFAvatarShape.standard),
              ),
              Container(
                margin: EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2,),
                    Text(
                      _event.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                    ),
                    SizedBox(height: 2,),
                     Text(
                      message.createdAtDT == null ? '2021 May 01' : getDateTimeString(message.createdAtDT),
                       style: TextStyle(
                           color: NAVIGATION_NORMAL_TEXT_COLOR,
                           fontSize: 13,
                           fontWeight: FontWeight.w600),),
                    SizedBox(height: 7,),
                    Text(
                      LocaleKeys.message_from_hittapa.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: BORDER_COLOR,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              Expanded(child: SizedBox(),),
              Container(
                child: Column(
                  children: <Widget>[
                     SizedBox(height: 2,),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(FB.CHAT_COLLECTION)
                          .doc(_event.id.toString())
                          .collection(userId.toString())
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) return Container();
                        if ((snap.data?.docs ?? []).length > 0)
                        return GFBadge(
                          shape: GFBadgeShape.circle,
                          size: GFSize.LARGE,
                          child: Text(
                            "${snap.data.docs.length}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        );
                        else return Container();
                      },
                    ),
                    Expanded(child: SizedBox(),),
                    message?.createdAtDT != null
                     ? Text("${(DateFormat('hh:mm').format(message.createdAtDT))}",
                         style: TextStyle(
                           color: NAVIGATION_NORMAL_TEXT_COLOR,
                           fontSize: 12,)) : Container(),
                    SizedBox(height: 15,)
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          FirebaseFirestore.instance
              .collection(FB.CHAT_COLLECTION)
              .doc(_event.id.toString())
              .collection(userId.toString()).get().then((value) {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance.collection(FB.MESSAGE_COLLECTION)
                      .doc(userId.toString())
                      .collection(FB.UNREAD_COLLECTION)
                      .doc(element.id).delete();
                  FirebaseFirestore.instance.collection(FB.CHAT_COLLECTION)
                      .doc(_event.id.toString())
                      .collection(userId.toString())
                      .doc(element.id).delete();
                });
          });
          navigateToMessageScreen(context, _event);
        }
      );
      
    return _event.participantsAccepted.length > 0 ? GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 11),
          height: 75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                child: GFAvatar(
                    backgroundImage: CachedNetworkImageProvider(_event.imageUrl ?? ''),
                    shape: GFAvatarShape.standard),
              ),
              Container(
                margin: EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2,),
                    Text(
                      _event.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                    ),
                    SizedBox(height: 2,),
                     Text(
                       _event.isFlexibleDate ? LocaleKeys.global_flexible.tr() : getDateTimeString(_event.startDT),
                       style: TextStyle(
                           color: NAVIGATION_NORMAL_TEXT_COLOR,
                           fontSize: 13,
                           fontWeight: FontWeight.w600),),
                    SizedBox(height: 7,),
                    (_event.id != null && message != null && message.senderId != null)
                        ? Builder(
                        builder: (context) {
                          return Text(
                              message.text.length > 30 ? '${message.text.substring(0, 29)}...' : '${message.text}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),);
                        }) : Text('No messages for this event yet!',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: BORDER_COLOR,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Expanded(child: SizedBox(),),
              Container(
                child: Column(
                  children: <Widget>[
                     SizedBox(height: 2,),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(FB.CHAT_COLLECTION)
                          .doc(_event.id.toString())
                          .collection(userId.toString())
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) return Container();
                        if ((snap.data?.docs ?? []).length > 0)
                        return GFBadge(
                          shape: GFBadgeShape.circle,
                          size: GFSize.LARGE,
                          child: Text(
                            "${snap.data.docs.length}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        );
                        else return Container();
                      },
                    ),
                    Expanded(child: SizedBox(),),
                    message?.createdAtDT != null
                     ? Text("${(DateFormat('hh:mm').format(message.createdAtDT))}",
                         style: TextStyle(
                           color: NAVIGATION_NORMAL_TEXT_COLOR,
                           fontSize: 12,)) : Container(),
                    SizedBox(height: 15,)
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          FirebaseFirestore.instance
              .collection(FB.CHAT_COLLECTION)
              .doc(_event.id.toString())
              .collection(userId.toString()).get().then((value) {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance.collection(FB.MESSAGE_COLLECTION)
                      .doc(userId.toString())
                      .collection(FB.UNREAD_COLLECTION)
                      .doc(element.id).delete();
                  FirebaseFirestore.instance.collection(FB.CHAT_COLLECTION)
                      .doc(_event.id.toString())
                      .collection(userId.toString())
                      .doc(element.id).delete();
                });
          });
          navigateToMessageScreen(context, _event);
        }) : Container();
  }

  Widget buildSeparator(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Divider(
        color: SEPARATOR_COLOR,
        height: 1,
      ),
    );
  }

  Widget showNoChatRooms() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[SvgPicture.asset('assets/empty_chatbox.svg')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 15,
                        color: BORDER_COLOR,
                        fontWeight: FontWeight.w500),
                    text: LocaleKeys.message_no_messages.tr() + "\n",
                    children: <TextSpan>[
                      TextSpan(
                          text: LocaleKeys.message_create_event.tr(),
                          style: TextStyle(decoration: TextDecoration.underline)),
                      TextSpan(text: ' ' + LocaleKeys.account_confirm_or.tr() +' '),
                      TextSpan(
                          text: LocaleKeys.message_join_event.tr(),
                          style: TextStyle(decoration: TextDecoration.underline))
                    ]),
              ),
            )
          ],
        )
      ],
    );
  }
}
