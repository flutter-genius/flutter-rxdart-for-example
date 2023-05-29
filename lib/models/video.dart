import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';
import 'package:hittapa/models/models.dart';

@immutable
class VideoModel extends DataModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String thumbNail;
  final String gender;
  final int stopAge;
  final int startAge;
  final DateTime stopDate;
  final DateTime startDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  VideoModel({
    this.id,
    this.title,
    this.stopDate,
    this.startDate,
    this.description,
    this.url,
    this.thumbNail,
    this.gender,
    this.stopAge,
    this.startAge,
    this.createdAt,
    this.updatedAt,
  });

  factory VideoModel.initial() {
    return VideoModel();
  }

  factory VideoModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return VideoModel.fromJson(json);
  }

  factory VideoModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = VideoModel(
      title: json.getVal<String>('title'),
      description: json.getVal<String>('description'),
      url: json.getVal<String>('url'),
      thumbNail: json.getVal<String>('thumb_nail'),
      stopDate: json.getVal<DateTime>('stopDate')?.toLocal(),
      startDate: json.getVal<DateTime>('startDate')?.toLocal(),
      startAge: json.getVal<int>('startAge'),
      stopAge: json.getVal<int>('stopAge'),
      gender: json.getVal<String>('gender'),
      createdAt: json.getVal<DateTime>('createdAt')?.toLocal(),
      updatedAt: json.getVal<DateTime>('updatedAt')?.toLocal(),
      id: json.getVal<String>('_id'),
    );
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'title': title,
    'description': description,
    'url': url,
    'thumb_nail': thumbNail,
    'gender': gender,
    'stopDate': stopDate.toUtc()?.millisecondsSinceEpoch,
    'startDate': startDate.toUtc()?.millisecondsSinceEpoch,
    'startAge': startAge,
    'stopAge': stopAge,
    'createdAt': createdAt.toUtc()?.millisecondsSinceEpoch,
    'updatedAt': updatedAt.toUtc()?.millisecondsSinceEpoch,
    'id': id,
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  VideoModel copyWith({
    String title,
    String description,
    String url,
    String thumbNail,
    String gender,
    DateTime stopDate,
    DateTime startDate,
    int startAge,
    int stopAge,
    DateTime createdAt,
    DateTime updatedAt,
    String id,
  }) => VideoModel(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      thumbNail: thumbNail ?? this.thumbNail,
      gender: gender ?? this.gender,
      stopDate: stopDate ?? this.stopDate,
      startDate: startDate ?? this.startDate,
      startAge: startAge ?? this.startAge,
      stopAge: stopAge ?? this.stopAge,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
  );


}
