import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';
import 'package:hittapa/models/models.dart';

@immutable
class CovidModel extends DataModel {
  final String id;
  final String title;
  final String semiTitle;
  final String description;
  final String websiteLink;
  final String image;
  final List<ImageListModel> images;
  final DateTime publishDate;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CovidModel({
    this.id,
    this.title,
    this.semiTitle,
    this.description,
    this.publishDate,
    this.websiteLink,
    this.image,
    this.images,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CovidModel.initial() {
    return CovidModel();
  }

  factory CovidModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return CovidModel.fromJson(json);
  }

  factory CovidModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = CovidModel(
      title: json.getVal<String>('title'),
      semiTitle: json.getVal<String>('semiTitle'),
      description: json.getVal<String>('description'),
      websiteLink: json.getVal<String>('websiteLink'),
      image: json.getVal<String>('image'),
      publishDate: json.getVal<DateTime>('publishDate')?.toLocal(),
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
    'semiTitle': semiTitle,
    'description': description,
    'websiteLink': websiteLink,
    'image': image,
    'publishDate': publishDate.toUtc()?.millisecondsSinceEpoch,
    'status': status,
    'createdAt': createdAt.toUtc()?.millisecondsSinceEpoch,
    'updatedAt': updatedAt.toUtc()?.millisecondsSinceEpoch,
    'images': images,
    'id': id,
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  CovidModel copyWith({
    String title,
    String semiTitle,
    String description,
    String websiteLink,
    String image,
    DateTime publishDate,
    bool status,
    DateTime createdAt,
    DateTime updatedAt,
    String id,
    List<ImageListModel> images,
  }) => CovidModel(
      title: title ?? this.title,
      semiTitle: semiTitle ?? this.semiTitle,
      description: description ?? this.description,
      websiteLink: websiteLink ?? this.websiteLink,
      image: image ?? this.image,
      publishDate: publishDate ?? this.publishDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      status: status ?? this.status,
      images: images ?? this.images
  );


}
