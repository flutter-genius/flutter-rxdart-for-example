import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'model_class.dart';

enum MessageContentType { text, image, location, video, alarm, nalarm }

class MessageModel extends DataModel {
  final String id;
  final String senderId;
  final String senderAvatar;
  final String senderName;
  final String senderGender;
  final DateTime senderBirthday;
  final String text;
  final MessageContentType content;
  final DateTime createdAtDT;
  final List<String> userLists;
  final String quoteText;
  final String quoteName;
  final DateTime quoteDate;
  final bool quoteExist;
  final List<String> fcmLists;

  // final DateTime updatedAtDT;

  MessageModel({
    this.id,
    this.text,
    this.senderId,
    this.senderAvatar,
    this.senderGender,
    this.content,
    this.createdAtDT,
    this.userLists,
    this.senderName,
    this.senderBirthday,
    this.quoteText,
    this.quoteName,
    this.quoteDate,
    this.quoteExist,
    this.fcmLists,
    // this.updatedAtDT,
  });

  factory MessageModel.initial() {
    return MessageModel();
  }

  factory MessageModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return MessageModel.fromJson(json);
  }

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = MessageModel(
      id: json.getVal<String>('id'),
      text: json.getVal<String>('text'),
      senderId: json.getVal<String>('senderId'),
      senderAvatar: json.getVal<String>('senderAvatar'),
      senderGender: json.getVal<String>('senderGender'),
      content: enumHelper.str2enum(MessageContentType.values, json.getVal<String>('content')),
      createdAtDT: json.getVal<DateTime>('createdAtDT')?.toLocal(),
      senderBirthday: json.getVal<DateTime>('senderBirthday')?.toLocal(),
      userLists: json.getList<String>('userLists') ?? [],
      senderName: json.getVal<String>('senderName'),
      quoteText: json.getVal<String>('quoteText'),
      quoteName: json.getVal<String>('quoteName'),
      quoteDate: json.getVal<DateTime>('quoteDate')?.toLocal(),
      quoteExist: json.getVal<bool>('quoteExist'),
      fcmLists: json.getList<String>('fcmLists') ?? [],
      // updatedAtDT: json.getVal<DateTime>('updatedAtDT')?.toLocal(),
    );
    if ([r.senderId, r.text].contains(null)) {
      return null;
    }
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'id': id?.toString(),
        'text': text,
        'senderId': senderId?.toString(),
        'senderAvatar': senderAvatar?.toString(),
        'senderName':senderName?.toString(),
        'senderGender' : senderGender?.toString(),
        'content': enumHelper.enum2str(content),
        'createdAtDT': createdAtDT?.toUtc()?.millisecondsSinceEpoch,
        'senderBirthday': senderBirthday?.toUtc()?.millisecondsSinceEpoch,
        'userLists': userLists.map((e) => e).toList(),
        'quoteText': quoteText?.toString(),
        'quoteName' : quoteName?.toString(),
        'quoteDate' : quoteDate?.toUtc()?.millisecondsSinceEpoch,
        'quoteExist' : quoteExist,
        'fcmLists' : fcmLists,
        // 'updatedAtDT': updatedAtDT?.?.toUtc()?.millisecondsSinceEpoch,
      });

  @override
  Map<String, dynamic> toJson() => toFB();

  MessageModel copyWith({
    int id,
    String text,
    String senderId,
    String senderAvatar,
    String senderName,
    MessageContentType content,
    DateTime createdAtDT,
    DateTime senderBirthday,
    List<String> userLists,
    DateTime updatedAtDT,
    String senderGender,
    String quoteName,
    String quoteText,
    DateTime quoteDate,
    bool quoteExist,
    List<String> fcmLists,
  }) =>
      MessageModel(
        id: id ?? this.id,
        text: text ?? this.text,
        senderId: senderId ?? this.senderId,
        senderName: senderName ?? this.senderName,
        senderAvatar: senderAvatar ?? this.senderAvatar,
        content: content ?? this.content,
        userLists: userLists ?? this.userLists,
        senderGender: senderGender ?? this.senderGender,
        createdAtDT: createdAtDT ?? this.createdAtDT,
          senderBirthday: senderBirthday ?? this.senderBirthday,
        quoteText: quoteText ?? this.quoteText,
        quoteName: quoteName ?? this.quoteName,
        quoteDate: quoteDate ?? this.quoteDate,
        quoteExist: quoteExist ?? this.quoteExist,
        fcmLists: fcmLists ?? this.fcmLists,
      );
}
