import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/notification.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationModel notification;
  final UserModel user;

  NotificationListItem({@required this.notification, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: notification.status ? Colors.white : UNREAD_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: getWidget(context),
        onPressed: () async {
          if (!notification.status) {
            await FirebaseFirestore.instance.collection(FB.NOTIFICATION_COLLECTION)
              .doc(user.uid.toString())
              .collection(FB.NOTIFICATION_COLLECTION)
              .doc(notification.id.toString())
              .update(notification.copyWith(status: true).toFB());
          }
          if (notification.type == NotificationType.adminNotification) {
            navigateToMessageScreen(context, AdminEvent);
            return;
          }
          var _result = notification.eventId !=null ? await NodeService().getEventById(notification.eventId.toString()) : null;
          if(_result != null && _result['data']!=null){
            EventModel _event = EventModel.fromJson(_result['data']);
            navigateToDetailScreen(context, _event); 
          }
        },
      ),
    );
  }

  Widget getWidget(context) {
    switch (notification.type) {
      case NotificationType.requestAccepted:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width-128,
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/checked_icon.svg',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(
                        LocaleKeys.event_join_request_accepted.tr().toUpperCase(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: CHECKED_COLOR),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    notification.title,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getDateTimeString(new DateTime.fromMillisecondsSinceEpoch(int.parse(notification.body))),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      )
                    ]
                  )
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.requestReceived:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              width: MediaQuery.of(context).size.width-128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: 35,
                        height: 35,
                        child: GFAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                          notification.avatar ?? DEFAULT_AVATAR,
                        )),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width-190,
                        child: RichText(
                          text: TextSpan(
                            text: notification.age ?? "",
                            style: TextStyle(
                              letterSpacing: -0.5,
                                color: NAVIGATION_NORMAL_TEXT_COLOR,
                                fontSize: MediaQuery.of(context).size.width < 380 && notification.age.length > 12 ? 11 : 13,
                                fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(text: '. '),
                              TextSpan(
                                  text: LocaleKeys.event_request_join.tr().toUpperCase(),
                                  style: TextStyle(
                                      color: REMINDER_COLOR,),
                              )
                            ]
                          ),
                        )
                      )
                    ]
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    notification.title,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateTimeString(new DateTime.fromMillisecondsSinceEpoch(int.parse(notification.body))),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      notification.eventImage ?? ''),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.requestDeclined:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              width: MediaQuery.of(context).size.width-128,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/calendar-outline.svg',
                        width: 14,
                        height: 16,
                        color: REMINDER_COLOR,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        LocaleKeys.event_declined_join.tr().toUpperCase(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: REMINDER_COLOR),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    notification.title,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    notification.body,
                    style: TextStyle(
                        color: BORDER_COLOR,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.eventReminder:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              width: MediaQuery.of(context).size.width-128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/calendar-outline.svg',
                    width: 14,
                    height: 16,
                    color: REMINDER_COLOR,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    LocaleKeys.notification_upcoming_event_reminder.tr().toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: REMINDER_COLOR),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    notification.title,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateTimeString(new DateTime.fromMillisecondsSinceEpoch(int.parse(notification.body))),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.requestStandby:
        return Row(
          children: <Widget>[
            SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/calendar-outline.svg',
                      width: 14,
                      height: 16,
                      color: REMINDER_COLOR,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      LocaleKeys.notification_standby_join.tr().toUpperCase(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: REMINDER_COLOR),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  notification.title,
                  style: TextStyle(
                      color: TITLE_TEXT_COLOR,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  notification.body,
                  style: TextStyle(
                      color: BORDER_COLOR,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  getDateTimeString(notification.createdAt),
                  style: TextStyle(
                      color: BORDER_COLOR,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.feedbackReminder:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              width: MediaQuery.of(context).size.width-128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/calendar-outline.svg',
                    width: 14,
                    height: 16,
                    color: REMINDER_COLOR,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    LocaleKeys.notification_feedback_reminder.tr().toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: REMINDER_COLOR),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    notification.title,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateTimeString(new DateTime.fromMillisecondsSinceEpoch(int.parse(notification.body))),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            ),
           
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.chatMessage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              width: MediaQuery.of(context).size.width-128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 35,
                        height: 35,
                        child: GFAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                          notification.avatar ?? DEFAULT_AVATAR,
                        )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${notification.title}, ',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: CHECKED_COLOR),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    LocaleKeys.notification_sent_you_an.tr().toUpperCase(),
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    notification.body,
                    style: TextStyle(
                        color: BORDER_COLOR,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
                      Text(
                        getDateTimeStringAgo(notification.createdAt),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ]
                  )
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: GFAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      notification.eventImage ?? DEFAULT_AVATAR),
                  shape: GFAvatarShape.standard),
            )
          ],
        );
      case NotificationType.adminNotification:
        return Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.notification_from_hittapa_support.tr().toUpperCase(),
                   style: TextStyle(color: REMINDER_COLOR,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(notification.title.toUpperCase(), style: TextStyle(color: DART_TEXT_COLOR,
                                fontSize: 13,
                                fontWeight: FontWeight.w200),),
                          ),
                          Text(
                            getDateTimeString(notification.createdAt),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          notification.body.toString(),
                          style: TextStyle(color: DART_TEXT_COLOR, fontSize: 14, fontWeight: FontWeight.w100),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    child: GFAvatar(
                        backgroundImage: CachedNetworkImageProvider(DEFAULT_AVATAR),
                        shape: GFAvatarShape.standard),
                  )
                ],
              )
            ],
          ),
        );
      default:
        return SizedBox(
          height: 0,
        );
    }
  }
}