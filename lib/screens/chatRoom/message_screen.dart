import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/message.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/screens/chatRoom/message_widget.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/utils/navigator.dart';

import 'package:hittapa/widgets/add_asset_dialog.dart';
import 'package:hittapa/widgets/event_asset_dialog.dart';

import 'package:hittapa/widgets/image_picker_handler.dart';
import 'package:hittapa/services/socket_service.dart';
import 'package:intl/intl.dart';

const _messageCreatedAtField = 'createdAtDT';

class MessageScreen extends StatefulWidget {
  final EventModel event;

  MessageScreen({@required this.event});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with TickerProviderStateMixin, ImagePickerListener {
  var _textController = TextEditingController();
  AnimationController _controller;
  MessageDialog locationDialog;
  ChattingMoreDialog moreDialog;
  UserReportDialog userReportDialog;
  File image;
  Map newMessage;
  int itemCount = 0;
  String nextUrl;
  String previousUrl;
  final SocketService socketService = injector.get<SocketService>();
  EventModel event;
  List<UserModel> otherUsers = [];
  bool isQote = false;
  String quoteText = '';
  String quoteName = '';
  DateTime quoteDate;

  @override
  void initState() {
    super.initState();
    // socketService.socket.connect();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    locationDialog = new MessageDialog(
      context: context,
      controller: _controller,
      event: widget.event,
    );
    userReportDialog = new UserReportDialog(
      context: context,
      controller: _controller,
      event: widget.event,
    );
    moreDialog = ChattingMoreDialog(
      controller: _controller,
      context: context,
      event: widget.event,
      listener: new ImagePickerHandler(this, _controller),
      onSelect: (value) {},
    );
    locationDialog.initState();
    moreDialog.initState();
    userReportDialog.initState();
    event = widget.event;
    _loadSocket();
  }

  _loadSocket() async {
    List<String> _lists = event.participantsAccepted;
    _lists.add(widget.event.ownerId);
    var _data = {'lists': _lists.toSet().toList()};
    var _result = await NodeService().getUsers(_data);
    if (_result != null && _result['data'] != null) {
      var dd = _result['data'];
      for (int i = 0; i < dd.length; i++) {
        UserModel userModel = UserModel.fromJson(dd[i]);
        if (userModel.uid != widget.event.ownerId) {
          otherUsers.add(userModel);
        }
      }
    }
    socketService.socket.on("send_event", (data) {
      EventModel _event = EventModel.fromJson(data);
      if (mounted) {
        setState(() {
          event = _event;
        });
      }
    });
  }

  _sendMessageToServer(var data, String eventId) {
    var _result = NodeService().sendEventMessage(data, eventId);
    print(_result);
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    socketService.socket.dispose();
    // _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          var user = state.user;
          otherUsers = otherUsers.where((element) => element.uid != user.uid).toList();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: SvgPicture.asset('assets/arrow-back.svg'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              backgroundColor: Colors.white,
              title: Text(
                widget.event.name,
                style: TextStyle(color: TITLE_TEXT_COLOR, fontWeight: FontWeight.w600, fontSize: 21),
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/more_icon.svg',
                    color: TITLE_TEXT_COLOR,
                  ),
                  onPressed: () async {
                    if (otherUsers.length > 0) {
                      var _value = await locationDialog.showAddDialog(context, otherUsers, user);
                      if (_value != null) {
                        List<UserModel> _otherUsers = otherUsers;
                        _otherUsers.add(user);
                        // ignore: non_constant_identifier_names
                        UserModel _selected_user = _otherUsers.firstWhere((element) => element.uid == _value);
                        if (_value == user.uid) {
                          final List<String> _list = [];
                          _list.addAll(event.participantsAccepted ?? []);
                          _list.add(event.ownerId);

                          /// this is only for the user withraw, no owner sign withdraw action
                          final MessageModel newMessage = MessageModel(
                              senderId: _selected_user.uid,
                              text: 'Unfortunately I can not attend this event, I hope you guys have fun.',
                              content: MessageContentType.nalarm,
                              createdAtDT: DateTime.now(),
                              userLists: _list,
                              senderAvatar: _selected_user.avatar,
                              senderName: _selected_user.username,
                              senderBirthday: _selected_user.birthday,
                              senderGender: getGenderCharacter(_selected_user.gender));
                          FB.postNewFirestoreDocumentInCollection(
                            '${FB.CHAT_COLLECTION}/${event.id}/${FB.EVENT_CHATROOM_COLLECTION}',
                            newMessage.toFB(),
                          );
                          _sendMessageToServer(newMessage.toFB(), event.id);
                          // Navigator.of(context).pop();
                          navigateToDashboardScreen(context, user);
                        }
                        if (_value != user.uid) {
                          final List<String> _list = [];
                          _list.addAll(event.participantsAccepted ?? []);
                          _list.add(event.ownerId);

                          /// sign withdraw action
                          final MessageModel newMessage = MessageModel(
                              senderId: user.uid,
                              text: 'Unforturnately I can not go to this event but I am glad to assign ${_selected_user.username} as the admin. Have fun.',
                              content: MessageContentType.alarm,
                              createdAtDT: DateTime.now(),
                              userLists: _list,
                              senderAvatar: _selected_user.avatar,
                              senderName: _selected_user.username,
                              senderBirthday: _selected_user.birthday,
                              senderGender: getGenderCharacter(_selected_user.gender));
                          FB.postNewFirestoreDocumentInCollection(
                            '${FB.CHAT_COLLECTION}/${event.id}/${FB.EVENT_CHATROOM_COLLECTION}',
                            newMessage.toFB(),
                          );
                          _sendMessageToServer(newMessage.toFB(), event.id);
                          Navigator.of(context).pop();
                          navigateToDashboardScreen(context, user);
                        }
                      }
                    }
                  },
                )
              ],
            ),
            body: Builder(builder: (context) {
              List<String> chatParticipantsList = [];
              chatParticipantsList.addAll(event.participantsAccepted ?? []);
              chatParticipantsList.add(event.ownerId);
              chatParticipantsList = chatParticipantsList.toSet().toList();

              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('${FB.CHAT_COLLECTION}/${widget.event.id}/${FB.EVENT_CHATROOM_COLLECTION}')
                      // .where('userLists', arrayContains: user.uid)
                      .orderBy(_messageCreatedAtField, descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                    reverse: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        // ignore: missing_return
                                        (BuildContext context, int index) {
                                      final MessageModel _message = MessageModel.fromFB(snapshot.data.docs[index]);
                                      UserType userType;
                                      // UserModel sender = user;
                                      if (_message.senderId != user.uid) {
                                        userType = UserType.receiver;
                                        // sender = otherUsers.firstWhere((element) => element.uid == _message.senderId);
                                      } else {
                                        userType = UserType.sender;
                                      }
                                      if (_message.userLists.contains(user.uid))
                                        return MessagesWidget(
                                            message: _message,
                                            userType: userType,
                                            user: user,
                                            onTap: () async {
                                              if (event.id != ADMINMESSAGEID) {
                                                isQote = await userReportDialog.showAddDialog(context, user, _message);
                                                if (isQote) {
                                                  quoteText = _message.text;
                                                  quoteName = _message.senderName;
                                                  quoteDate = _message.createdAtDT;
                                                } else {
                                                  quoteText = '';
                                                  quoteName = '';
                                                  quoteDate = null;
                                                }
                                                setState(() {});
                                              }
                                            });
                                    }),
                              ),
                              event.id == ADMINMESSAGEID
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.only(top: 8.0, bottom: 10, left: 0, right: 15),
                                      height: isQote ? 95 : 65,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          isQote
                                              ? Container(
                                                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 5),
                                                  padding: EdgeInsets.only(bottom: 3),
                                                  width: MediaQuery.of(context).size.width - 32,
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                    Text("\"" + quoteText,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        )),
                                                    Text("$quoteName, at ${DateFormat("HH:mm").format(quoteDate)}",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                        ))
                                                  ]))
                                              : Container(),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(35.0),
                                                      boxShadow: [BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)],
                                                      border: Border.all(color: BORDER_COLOR, width: 1)),
                                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                                  child: TextField(
                                                    controller: _textController,
                                                    decoration: InputDecoration(hintText: LocaleKeys.message_write_message.tr(), border: InputBorder.none),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              SizedBox(
                                                width: 60,
                                                height: 35,
                                                child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    color: GRADIENT_COLOR_ONE,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                    onPressed: () {
                                                      if (_textController.text.isNotEmpty) {
                                                        List<String> fcmLists = [];
                                                        for (var i = 0; i < otherUsers.length; i++) {
                                                          if (otherUsers[i].fcmToken != null) fcmLists.add(otherUsers[i].fcmToken);
                                                        }

                                                        final MessageModel newMessage = MessageModel(
                                                          senderId: user.uid,
                                                          text: _textController.text,
                                                          content: MessageContentType.text,
                                                          createdAtDT: DateTime.now(),
                                                          userLists: chatParticipantsList,
                                                          senderAvatar: user.avatar,
                                                          senderName: user.username,
                                                          senderBirthday: user.birthday,
                                                          quoteExist: isQote,
                                                          quoteText: quoteText,
                                                          quoteName: quoteName,
                                                          quoteDate: quoteDate,
                                                          fcmLists: fcmLists,
                                                        );
                                                        FB.postNewFirestoreDocumentInCollection(
                                                          '${FB.CHAT_COLLECTION}/${widget.event.id}/${FB.EVENT_CHATROOM_COLLECTION}',
                                                          newMessage.toFB(),
                                                        );
                                                        _sendMessageToServer(newMessage.toFB(), widget.event.id);
                                                        _textController.text = '';
                                                        // quote clear
                                                        isQote = false;
                                                        quoteDate = null;
                                                        quoteName = '';
                                                        quoteText = '';
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.send,
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            }),
          );
        });
  }

  @override
  userImage(File _image) {
    return null;
  }
}
