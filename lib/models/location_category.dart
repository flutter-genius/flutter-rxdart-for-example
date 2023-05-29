import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';

@immutable
class LocationCategoryModel extends DataModel {
  final FirebaseId id;
  final String name;
  final String thumbnail;
  final String image;

  LocationCategoryModel({
    this.id,
    this.name,
    this.thumbnail,
    this.image,});

  factory LocationCategoryModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();    
    return LocationCategoryModel.fromJson(json);
  }

  factory LocationCategoryModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    return LocationCategoryModel(
      id: json.getVal<FirebaseId>('id'),
      image: json.getVal<String>('image'),
      name: json.getVal<String>('name'),
      thumbnail: json.getVal<String>('thumbnail')
    );
  }

  @override
  copyWith({
    FirebaseId id,
    String name,
    String thumbnail,
    String image,
  }) {
    return LocationCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      image: image ?? this.image
    );
  }

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from({
    'id': this.id.toString(),
    'name': this.name,
    'thumbnail': this.thumbnail,
    'image': this.image
  });

}