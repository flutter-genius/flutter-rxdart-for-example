import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';
import 'package:hittapa/models/models.dart';

@immutable
class BackgroundImageModel extends DataModel {
  final String id;
  final String description;
  final String image;
  final String name;
  final String title;
  final String viewMore;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BackgroundImageModel({
    this.id,
    this.description,
    this.image,
    this.name,
    this.title,
    this.status,
    this.viewMore,
    this.createdAt,
    this.updatedAt,
  });

  factory BackgroundImageModel.initial() {
    return BackgroundImageModel();
  }

  factory BackgroundImageModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return BackgroundImageModel.fromJson(json);
  }

  factory BackgroundImageModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = BackgroundImageModel(
      description: json.getVal<String>('description'),
      image: json.getVal<String>('image'),
      name: json.getVal<String>('name'),
      title: json.getVal<String>('title'),
      viewMore: json.getVal<String>('viewMore'),
      status: json.getVal<bool>('status'),
      createdAt: json.getVal<DateTime>('createdAt')?.toLocal(),
      updatedAt: json.getVal<DateTime>('updatedAt')?.toLocal(),
      id: json.getVal<String>('_id'),
    );
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'description': description,
    'image': image,
    'name': name,
    'title': title,
    'viewMore': viewMore,
    'createdAt': createdAt.toUtc()?.millisecondsSinceEpoch,
    'updatedAt': updatedAt.toUtc()?.millisecondsSinceEpoch,
    'id': id,
    'status' : status,
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  BackgroundImageModel copyWith({
    String description,
    String image,
    String name,
    String title,
    String viewMore,
    DateTime createdAt,
    DateTime updatedAt,
    String id,
    bool status,
  }) => BackgroundImageModel(
      description: description ?? this.description,
      image: image ?? this.image,
      name: name ?? this.name,
      title: title ?? this.title,
      viewMore: viewMore ?? this.viewMore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      status: status ?? this.status
  );


}
