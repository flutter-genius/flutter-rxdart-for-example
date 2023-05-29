import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'model_class.dart';

class ReportModel extends DataModel {
   final String id;
   final String reportId;
   final String reportAvatar;
   final String reportName;
   final String senderName;
   final String senderId;
   final String senderAvatar;
   final String reportOption;
   final String content;
   final DateTime createdAt;
   final DateTime updatedAt;

  // final DateTime updatedAtDT;

  ReportModel({
    this.id,
    this.senderId,
    this.reportId,
    this.reportAvatar,
    this.senderAvatar,
    this.reportName,
    this.senderName,
    this.reportOption,
    this.content,
    this.createdAt,
    this.updatedAt
    // this.updatedAtDT,
  });

  factory ReportModel.initial() {
    return ReportModel();
  }

  factory ReportModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return ReportModel.fromJson(json);
  }

  factory ReportModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = ReportModel(
      id: json.getVal<String>('_id'),
      reportId: json.getVal<String>('reportId'),
      reportAvatar: json.getVal<String>('reportAvatar'),
      senderId: json.getVal<String>('senderId'),
      senderAvatar: json.getVal<String>('senderAvatar'),
      reportName: json.getVal<String>('reportName'),
      senderName: json.getVal<String>('senderName'),
      reportOption: json.getVal<String>('reportOption'),
      content: json.getVal<String>('content'),
      createdAt: json.getVal<DateTime>('createdAt')?.toLocal(),
      updatedAt: json.getVal<DateTime>('updatedAt')?.toLocal(),
      // updatedAtDT: json.getVal<DateTime>('updatedAtDT')?.toLocal(),
    );
    if ([r.senderId, r.reportId].contains(null)) {
      return null;
    }
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'id': id?.toString(),
    'reportId': reportId?.toString(),
    'reportAvatar': reportAvatar?.toString(),
    'senderId': senderId?.toString(),
    'senderAvatar': senderAvatar?.toString(),
    'reportOption': reportOption?.toString(),
    'senderName': senderName?.toString(),
    'reportName': reportName?.toString(),
    'content': enumHelper.enum2str(content),
    'createdAt': createdAt?.toUtc()?.millisecondsSinceEpoch,
    'updatedAt': updatedAt?.toUtc()?.millisecondsSinceEpoch,

    // 'updatedAtDT': updatedAtDT?.?.toUtc()?.millisecondsSinceEpoch,
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  ReportModel copyWith({
    int id,
    String reportId,
    String reportAvatar,
    String senderId,
    String senderAvatar,
    String senderName,
    String reportName,
    String reportOption,
    String content,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      ReportModel(
        id: id ?? this.id,
        reportId: reportId ?? this.reportId,
        reportAvatar: reportAvatar ?? this.reportAvatar,
        senderId: senderId ?? this.senderId,
        senderAvatar: senderAvatar ?? this.senderAvatar,
        reportOption: reportOption ?? this.reportOption,
        senderName: senderName ?? this.senderName,
        reportName: reportName ?? this.reportName,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
