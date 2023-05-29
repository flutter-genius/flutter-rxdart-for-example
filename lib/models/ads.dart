import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';
import 'package:hittapa/models/models.dart';

@immutable
class AdsModel extends DataModel {
  final String id;
  final String title;
  final String websiteLink;
  final String image;
  final List<ImageListModel> images;
  final DateTime stopDate;
  final DateTime startDate;
  final int priority;
  final String userGroup;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdsModel({
    this.id,
    this.title,
    this.websiteLink,
    this.image,
    this.stopDate,
    this.startDate,
    this.images,
    this.priority,
    this.userGroup,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AdsModel.initial() {
    return AdsModel();
  }

  factory AdsModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return AdsModel.fromJson(json);
  }

  factory AdsModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = AdsModel(
      title: json.getVal<String>('title'),
      websiteLink: json.getVal<String>('websiteLink'),
      image: json.getVal<String>('image'),
      stopDate: json.getVal<DateTime>('stopDate')?.toLocal(),
      startDate: json.getVal<DateTime>('startDate')?.toLocal(),
      priority: json.getVal<int>('priority'),
      userGroup: json.getVal<String>('userGroup'),
      status: json.getVal<bool>('status'),
      createdAt: json.getVal<DateTime>('createdAt')?.toLocal(),
      updatedAt: json.getVal<DateTime>('updatedAt')?.toLocal(),
      id: json.getVal<String>('_id'),
      images: json?.json['images']
          ?.map<ImageListModel>((e) => ImageListModel.fromJson(e))
          ?.toList(),
    );
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'title': title,
    'websiteLink': websiteLink,
    'image': image,
    'stopDate': stopDate.toUtc()?.millisecondsSinceEpoch,
    'startDate': startDate.toUtc()?.millisecondsSinceEpoch,
    'priority': priority,
    'userGroup': userGroup,
    'status': status,
    'createdAt': createdAt.toUtc()?.millisecondsSinceEpoch,
    'updatedAt': updatedAt.toUtc()?.millisecondsSinceEpoch,
    'images': images,
    'id': id,
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  AdsModel copyWith({
    String title,
    String websiteLink,
    String image,
    DateTime stopDate,
    DateTime startDate,
    int priority,
    String userGroup,
    bool status,
    DateTime createdAt,
    DateTime updatedAt,
    String id,
    List<ImageListModel> images,
  }) => AdsModel(
      title: title ?? this.title,
      websiteLink: websiteLink ?? this.websiteLink,
      image: image ?? this.image,
      stopDate: stopDate ?? this.stopDate,
      startDate: startDate ?? this.startDate,
      priority: priority ?? this.priority,
      userGroup: userGroup ?? this.userGroup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      status: status ?? this.status,
      images: images ?? this.images
  );


}
