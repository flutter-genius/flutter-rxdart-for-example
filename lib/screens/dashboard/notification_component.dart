import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/notification.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/widgets/notification_list_item.dart';
import 'package:hittapa/global_export.dart';

class NotificationComponent extends StatelessWidget {
  final Function onClick;

  const NotificationComponent({Key key, this.onClick}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return Scaffold(
            backgroundColor: BACKGROUND_COLOR,
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FB.NOTIFICATION_COLLECTION)
                  .doc(user.uid)
                  .collection(FB.NOTIFICATION_COLLECTION)
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                if (snap.data.docs.isEmpty) return emptyWidget();
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: 65),
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) {
                    NotificationModel _notification = NotificationModel.fromFB(snap.data.docs[index]);
                    if (_notification.type != NotificationType.adminNotification)
                      return NotificationListItem(
                        notification: _notification,
                        user: user
                      );
                    else return Container();
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      child: Divider(
                        color: SEPARATOR_COLOR,
                        height: 1,
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }

  Widget emptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/empty_notification.svg')
          ],
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
                    text:
                    LocaleKeys.notification_no_notification.tr(),
                    children: <TextSpan>[
                      TextSpan(
                          text: LocaleKeys.message_create_event.tr(),
                          style: TextStyle(
                              decoration: TextDecoration.underline)),
                      TextSpan(text: LocaleKeys.message_or.tr(),),
                      TextSpan(
                          text: LocaleKeys.message_join_event.tr(),
                          style: TextStyle(
                              decoration: TextDecoration.underline))
                    ]),
              ),
            )
          ],
        )
      ],
    );
  }
}
