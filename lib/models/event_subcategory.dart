import 'package:flutter/foundation.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

@immutable
class EventSubcategoryModel extends DataModel {
  final String categoryId;
  final String id;
  final String name;
  final String desc;
  final String logo;
  final String banner;
  final bool status;
  final bool isSuspended;
  final bool isRestrict;
  final String thumbnail;
  final List<int> requirements;
  final List<ImageListModel> imageLists;

  EventSubcategoryModel({
    this.categoryId,
    this.id,
    this.name,
    this.desc,
    this.logo,
    this.banner,
    this.status,
    this.thumbnail,
    this.requirements,
    this.isRestrict,
    this.isSuspended,
    this.imageLists
  });

  factory EventSubcategoryModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return EventSubcategoryModel(
      categoryId: json.getVal<String>('category_id'),
      id: json.getVal<String>('_id'),
      name: json.getVal<String>('name'),
      desc: json.getVal<String>('description'),
      logo: json.getVal<String>('logo'),
      status: json.getVal<bool>('status'),
      isSuspended: json.getVal<bool>('isSuspended'),
      requirements: json.getList<int>('requirements') ?? [],
      isRestrict: json.getVal<bool>('isRestrict'),
      banner: json.getVal<String>('banner'),
      thumbnail: json.getVal<String>('thumbnail'),
      imageLists: json?.json['imageLists']
          ?.map<ImageListModel>((e) => ImageListModel.fromJson(e))
          ?.toList(),
    );
  }

  factory EventSubcategoryModel.fromFB(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return EventSubcategoryModel(
      categoryId: json.getVal<String>('category_id'),
      id: json.getVal<String>('id'),
      name: json.getVal<String>('name_en'),
      desc: json.getVal<String>('desc_en'),
      logo: json.getVal<String>('logo'),
      banner: json.getVal<String>('banner'),
      status: json.getVal<bool>('status'),
      isRestrict: json.getVal<bool>('is_restrict'),
      isSuspended: json.getVal<bool>('is_suspended'),
      thumbnail: json.getVal<String>('thumbnail'),
      requirements: json.getList<int>('requirements'),
      imageLists: json.getList<ImageListModel>('imageLists'),
    );
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'category_id' : categoryId.toString(),
        '_id': id.toString(),
        'name': name,
        'description': desc,
        'logo': logo,
        'banner': banner,
        'status': status,
        'thumbnail': thumbnail,
        'requirements': requirements,
        'isSuspended': isSuspended,
        'isRestrict': isRestrict,
        'imageLists': imageLists,
      });

  @override
  Map<String, dynamic> toJson() {
    var map = toFB();
    return map;
  }

  EventSubcategoryModel copyWith({
    String categoryId,
    FirebaseId id,
    String name,
    String desc,
    String logo,
    String banner,
    bool status,
    bool isRestrict,
    bool isSuspended,
    String thumbnail,
    List<int> requirements,
    List<ImageListModel> imageLists,
  }) {
    return EventSubcategoryModel(
      categoryId: categoryId ?? this.categoryId,
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      logo: logo ?? this.logo,
      banner: banner ?? this.banner,
      status: status ?? this.status,
      thumbnail: thumbnail ?? this.thumbnail,
      requirements: requirements ?? this.requirements,
      isRestrict: isRestrict ?? this.isRestrict,
      isSuspended: isSuspended ?? this.isSuspended,
      imageLists:  imageLists ?? this.imageLists,
    );
  }
}


class ImageListModel extends DataModel {
  final String url;
  final String name;

  ImageListModel({
    this.url,
    this.name
  });

  factory ImageListModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return ImageListModel(
      url: json.getVal<String>('url'),
      name: json.getVal<String>('name')
    );
  }

  factory ImageListModel.fromFB(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return ImageListModel(
      url: json.getVal<String>('url'),
      name: json.getVal<String>('name'),
    );
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'url': url.toString(),
    'name': name
  });

  @override
  Map<String, dynamic> toJson() {
    var map = toFB();
    return map;
  }

  ImageListModel copyWith({
    String url,
    String name
  }) {
    return ImageListModel(
        url: url ?? this.url,
        name: name ?? this.name
    );
  }
}
