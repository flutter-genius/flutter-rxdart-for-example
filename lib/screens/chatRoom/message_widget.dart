import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/message.dart';
import 'package:hittapa/models/user.dart';
import 'package:intl/intl.dart';
import 'package:hittapa/global_export.dart';


enum UserType { sender, receiver }

class MessagesWidget extends StatelessWidget {
  final MessageModel message;
  final UserType userType;
  final UserModel user;
  final Function onTap;

  MessagesWidget({
    @required this.message,
    @required this.userType,
    @required this.user,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          UserModel sender = user;
          switch (userType) {
            case UserType.sender:
              switch (message.content) {
                case MessageContentType.text:
                  return senderTextBox(message, context);
                case MessageContentType.image:
                  return senderImageBox(message, context);
                case MessageContentType.location:
                  return senderLocationBox(message, context);
                case MessageContentType.video:
                  return senderVideoBox(message, context);
                case MessageContentType.alarm:
                  return senderAlamBox(message, context);
                default:
                  return Container();
              }
              break;
            case UserType.receiver:
              switch (message.content) {
                case MessageContentType.text:
                  return receiverTextBox(sender, message, context);
                case MessageContentType.image:
                  return receiverImageBox(sender, message, context);
                case MessageContentType.location:
                  return receiverLocationBox(message, context);
                case MessageContentType.video:
                  return receiverVideoBox(message, context);
                case MessageContentType.alarm:
                  return receiverAlamBox(message, context);
                case MessageContentType.nalarm:
                  return receiverNAlamBox(message, context);
                default:
                  return Container();
              }
              break;
            default:
              return Container();
          }
        });
  }


  Widget senderAlamBox(MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6 + 25),
                padding: const EdgeInsets.only(top: 5, left: 10, bottom: 15, right: 3),
                decoration: BoxDecoration(
                  color: CHECKED_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 5),
                          child: GFAvatar(
                            backgroundImage: CachedNetworkImageProvider(message.senderAvatar ?? DEFAULT_AVATAR),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "${message.senderName + ', ' + (DateTime.now().year - message.senderBirthday.year).toString() + message.senderGender??'user'  }",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .6+10,
                          ),
                          child: Text(
                            "${message.text}",
                            style: Theme.of(context).textTheme.bodyText2.apply(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: (){
                        //     print('in herer');
                        //     onTap();
                        //   },
                        //   child: Icon(Icons.more_vert, size: 18,),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Text(
            "${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      )
    );
  }

  Widget senderTextBox(MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: GOOGLE_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: message.quoteExist != null && message.quoteExist ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      padding: EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Colors.white))

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(
                          "\" ${message.quoteText}",
                          style: TextStyle(
                            fontSize: 14, color: Colors.white,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        Text("${message.quoteName}, at ${DateFormat("HH:mm").format(message.quoteDate)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          )
                        )
                      ],)
                    ),
                    Text(
                      "${message.text}",
                      style: Theme.of(context).textTheme.bodyText1.apply(
                            color: Colors.white,
                      ),
                    ),

                  ],
                ) : Text(
                      "${message.text}",
                      style: Theme.of(context).textTheme.bodyText1.apply(
                            color: Colors.white,
                      ),
                    ),
              ),
            ],
          ),
          Text(
            "${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.grey),
          ),
        ],
      )
    );
  }

  Widget senderImageBox(MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.grey),
          ),
          SizedBox(width: 15),
          Container(
            margin: EdgeInsets.only(right: 5),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: message.text ?? '',
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, err) => Center(
                  child: Icon(Icons.image),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget senderLocationBox(MessageModel message, BuildContext context) {
    return Container();
  }

  // if (message.text == "Instance of 'Address'") return Container();
  // double lat = double.parse(message.text.split(',')[0]);
  // double lon = double.parse(message.text.split(',')[1]);
  // MarkerId _id = MarkerId('message_point_${message.text}');
  // markers[_id] = Marker(
  //     markerId: _id,
  //     position: LatLng(
  //       11.052992,
  //       106.681612,
  //     ));
  // return Padding(
  //   padding: const EdgeInsets.symmetric(vertical: 7.0),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         "${DateFormat("HH:mm").format(message.createdAt)}",
  //         style:
  //             Theme.of(context).textTheme.body2.apply(color: Colors.grey),
  //       ),
  //       SizedBox(width: 15),
  //       Container(
  //         margin: EdgeInsets.only(right: 5),
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * .6,
  //         ),
  //         height: 115,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           child: GoogleMap(
  //             scrollGesturesEnabled: false,
  //             onMapCreated: (c) => _onCreateMap(c, lat, lon),
  //             initialCameraPosition:
  //                 CameraPosition(target: LatLng(lat, lon), zoom: 11),
  //             markers: Set<Marker>.of(markers.values),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  Widget senderVideoBox(MessageModel message, BuildContext context) {
    return Container();
  }

  Widget receiverTextBox(UserModel sender, MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 5),
                child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(message.senderAvatar ?? DEFAULT_AVATAR),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 3),
                decoration: BoxDecoration(
                  color: MESSAGE_BACKGROUND_COLOR,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child:  message.quoteExist != null && message.quoteExist ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      padding: EdgeInsets.only(bottom: 3),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .6-18),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Colors.grey))

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(
                          "\" ${message.quoteText}",
                          style: TextStyle(
                            fontSize: 14, color: Colors.grey,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        Text(message.quoteName != null ? "${message.quoteName}, at ${DateFormat("HH:mm").format(message.quoteDate)}" : "",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )
                        )
                      ],)
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6-40,
                          ),
                          child: Text(
                            "${message.text}",
                            style: Theme.of(context).textTheme.bodyText2.apply(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            print('in herer');
                            onTap();
                          },
                          child: Icon(Icons.more_vert, size: 18,),
                        ),
                      ],
                    ),
                  ],
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .6-40,
                      ),
                      child: Text(
                        "${message.text}",
                        style: Theme.of(context).textTheme.bodyText2.apply(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        print('in herer');
                        onTap();
                      },
                      child: Icon(Icons.more_vert, size: 18,),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "${message.senderName??'user'}, ${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.caption,
          ),
        ]
      )
    );
  }

  Widget receiverImageBox(
      UserModel sender, MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: 5),
            child: GFAvatar(
              backgroundImage: CachedNetworkImageProvider(message.senderAvatar ?? DEFAULT_AVATAR),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${sender.username}",
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: message.text ?? '',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, err) => Center(
                      child: Icon(Icons.image),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
          Text(
            "${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget receiverLocationBox(MessageModel message, BuildContext context) {
    return Container();
  }

  Widget receiverVideoBox(MessageModel message, BuildContext context) {
    return Container();
  }

  Widget receiverAlamBox(MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 5),
                child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(DEFAULT_AVATAR),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .6 + 25),
                    padding: const EdgeInsets.only(top: 5, left: 10, bottom: 15, right: 3),
                    decoration: BoxDecoration(
                      color: CHECKED_COLOR,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(left: 5),
                              child: GFAvatar(
                                backgroundImage: CachedNetworkImageProvider(message.senderAvatar ?? DEFAULT_AVATAR),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "${message.senderName + ', ' + (DateTime.now().year - message.senderBirthday.year).toString() + message.senderGender??'user'  }",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .6+10,
                              ),
                              child: Text(
                                "${message.text}",
                                style: Theme.of(context).textTheme.bodyText2.apply(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // InkWell(
                            //   onTap: (){
                            //     print('in herer');
                            //     onTap();
                            //   },
                            //   child: Icon(Icons.more_vert, size: 18,),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ), 
            ],
          ),
          Text(
            "User, ${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      )
    );
  }

  Widget receiverNAlamBox(MessageModel message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 5),
                child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(message.senderAvatar ?? DEFAULT_AVATAR),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .6 + 25),
                    padding: const EdgeInsets.only(top: 5, left: 10, bottom: 15, right: 3),
                    decoration: BoxDecoration(
                      color: REMINDER_COLOR,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .6+10,
                              ),
                              child: Text(
                                "${message.text}",
                                style: Theme.of(context).textTheme.bodyText2.apply(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // InkWell(
                            //   onTap: (){
                            //     print('in herer');
                            //     onTap();
                            //   },
                            //   child: Icon(Icons.more_vert, size: 18,),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ), 
            ],
          ),
          Text(
            "${message.senderName}, ${DateFormat("HH:mm").format(message.createdAtDT)}",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      )
    );
  }
}
