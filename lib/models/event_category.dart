import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'event_subcategory.dart';
import 'model_class.dart';

@immutable
class EventCategoryModel extends DataModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final bool status;
  final String thumbnail;
  final List<EventSubcategoryModel> subcategories;

  EventCategoryModel(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.status,
      this.subcategories,
      this.thumbnail});

  factory EventCategoryModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return EventCategoryModel(
      id: json.getVal<String>('_id'),
      name: json.getVal<String>('name'),
      description: json.getVal<String>('description'),
      image: json.getVal<String>('image'),
      status: json.getVal<bool>('status'),
      subcategories: json?.json['subcategories']
          ?.map<EventSubcategoryModel>((e) => EventSubcategoryModel.fromJson(e))
          ?.toList(),
      thumbnail: json.getVal<String>('thumbnail'),
    );
  }

  factory EventCategoryModel.fromJsonfb(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return EventCategoryModel(
      id: json.getVal<String>('id'),
      name: json.getVal<String>('name_en'),
      description: json.getVal<String>('description_en'),
      image: json.getVal<String>('image'),
      status: json.getVal<bool>('status'),
      subcategories: json?.json['subcategories']
          ?.map<EventSubcategoryModel>((e) => EventSubcategoryModel.fromFB(e))
          ?.toList(),
      thumbnail: json.getVal<String>('thumbnail'),
    );
  }

  factory EventCategoryModel.fromFB(DocumentSnapshot snap) {
    var json = snap.data();
    return EventCategoryModel.fromJsonfb(json);
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'id': id.toString(),
        'name_en': name,
        'description_en': description,
        'image': image,
        'status': status,
        'subcategories':
            subcategories?.map((subcategory) => subcategory.toFB())?.toList(),
        'thumbnail': thumbnail
      });

  @override
  Map<String, dynamic> toJson() {
    var map = toFB();
    return map;
  }

  EventCategoryModel copyWith({
    FirebaseId id,
    String name,
    String description,
    String image,
    bool status,
    List<EventSubcategoryModel> subcategories,
    String thumbnail,
  }) {
    return EventCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      status: status ?? this.status,
      subcategories: subcategories ?? this.subcategories,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
