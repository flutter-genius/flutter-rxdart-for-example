import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'model_class.dart';

enum NotificationType {
  other,
  eventReminder,
  requestAccepted,
  requestReceived,
  feedbackReminder,
  chatMessage,
  requestStandby,
  requestDeclined,
  adminNotification,
  eventOwner,
}

const List<String> notificationTypes = <String>[
  'other',
  'event reminder',
  'accepted',
  'event request',
  'feedback reminder',
  'new message',
  'request standby',
  'request declined',
  'admin notification',
  'eventOwner',
];

const notificationRef = [
  NotificationType.other,
  NotificationType.eventReminder,
  NotificationType.requestAccepted,
  NotificationType.requestReceived,
  NotificationType.feedbackReminder,
  NotificationType.chatMessage,
  NotificationType.requestStandby,
  NotificationType.requestDeclined,
  NotificationType.adminNotification,
  NotificationType.eventOwner,
];

class NotificationModel extends DataModel {
  final FirebaseId id;
  final NotificationType type;
  final String title;
  final String body;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FirebaseId eventId;
  final String eventImage;
  final FirebaseId userId;
  final String avatar;
  final String age;


  NotificationModel({
    this.id,
    this.userId,
    this.avatar,
    this.age,
    this.type,
    this.title,
    this.body,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.eventId,
    this.eventImage,
  });

  factory NotificationModel.initial() {
    return NotificationModel();
  }

  factory NotificationModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return NotificationModel.fromJson(json, snapshot.id);
  }

  factory NotificationModel.fromJson(Map<String, dynamic> map, String id) {
    if (map == null) return null;
    var json = JSON(map);

    return NotificationModel(
      id: FirebaseId(id),
      userId: json.getVal<FirebaseId>('user_id'),
      type: enumHelper.str2enum(NotificationType.values, json.getVal<String>('type')),
      title: json.getVal<String>('title'),
      status: json.getVal<bool>('status'),
      body: json.getVal<String>('body'),
      avatar: json.getVal<String>('avatar'),
      age: json.getVal<String>('age'),
      eventId: json.getVal<FirebaseId>('event_id'),
      eventImage: json.getVal<String>('event_image'),
      updatedAt: json.getVal<DateTime>('updated_at').toLocal(),
      createdAt: json.getVal<DateTime>('created_at').toLocal()
    );
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'user_id': this.userId.toString(),
    'type': enumHelper.enum2str(this.type),
    'title': this.title,
    'status': this.status,
    'body': this.body,
    'avatar': this.avatar,
    'age': this.age,
    'event_id': this.eventId.toString(),
    'event_image': this.eventImage,
    'updated_at': this.updatedAt.toUtc()?.millisecondsSinceEpoch,
    'created_at': this.createdAt.toUtc()?.millisecondsSinceEpoch
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  NotificationModel copyWith({
    FirebaseId id,
    NotificationType type,
    String title,
    String body,
    bool status,
    DateTime createdAt,
    DateTime updatedAt,
    FirebaseId eventId,
    String eventImage,
    FirebaseId userId,
    String avatar,
    String age
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      eventImage: eventImage ?? this.eventImage,
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      age: age ?? this.age,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt
    );
  }



}
