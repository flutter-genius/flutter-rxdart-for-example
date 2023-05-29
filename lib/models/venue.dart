import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'location.dart';
import 'location_requirement.dart';
import 'model_class.dart';
import 'open_day_time.dart';

@immutable
class VenueModel extends DataModel {
  final String id;
  final LocationModel location;
  final String name;
  final String desc;
  final String ownerId;
  final String image;
  final String logo;
  final int reviews;
  final double point;
  final bool is24Opened;
  final String websiteUrl;
  final String phoneNumber;
  final List<VenueOpenTimesModel> openTimes;
  final List<LocationCategoryModel> eventCategories;
  final List<String> imageUrls;
  final List<dynamic> eventIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<LocationRequirement> categories;

  VenueModel({
    this.id,
    this.ownerId,
    this.location,
    this.name,
    this.desc,
    this.reviews,
    this.image,
    this.logo,
    this.point,
    this.eventCategories,
    this.createdAt,
    this.eventIds,
    this.imageUrls,
    this.is24Opened,
    this.openTimes,
    this.phoneNumber,
    this.updatedAt,
    this.websiteUrl,

    this.categories,
  });

  factory VenueModel.initial() {
    return VenueModel();
  }

  factory VenueModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return VenueModel.fromJson(json);
  }

  factory VenueModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);

    return VenueModel(
      id: json.getVal<String>('_id'),
      location: LocationModel.fromJson(json.getVal<dynamic>('location')),
      ownerId: json.getVal<String>('ownerId'),
      name: json.getVal<String>('name'),
      reviews: json.getVal<int>('reviews'),
      image: json.getVal<String>('image'),
      logo: json.getVal<String>('logo'),
      point: double.parse(json.getVal<String>('point')),
      eventCategories: (json.getList<dynamic>('eventCategories')??{}).map((el) => LocationCategoryModel.fromJson(el)).toList(),
      createdAt: json.getVal<DateTime>('createdAt'),
      eventIds: json.getList<dynamic>('eventIds').map((el) => (el)).toList(),
      imageUrls: json.getList<String>('imageUrls'),
      is24Opened: json.getVal<bool>('is24Opened'),
      openTimes: json.getList<dynamic>('openTimes').map((el) => VenueOpenTimesModel.fromFB(el)).toList(),
      phoneNumber: json.getVal<String>('phoneNumber'),
      updatedAt: json.getVal<DateTime>('updatedAt'),
      websiteUrl: json.getVal<String>('webSite'),
      desc: json.getVal<String>('desc'),

      categories: json.getList<dynamic>('categories')?.map((e) => LocationRequirement.fromMap(e))?.toList(),
    );
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'id': id.toString(),
        'location': location.toFB(),
        'name': name,
        'desc': desc,
        'reviews': reviews,
        'ownerId': ownerId.toString(),
        'image': image,
        'is24Opened': is24Opened,
        'webSite': websiteUrl,
        'phoneNumber': phoneNumber,
        'openTimes': openTimes.map((time) => time.toFB()).toList(),
        'categories': eventCategories.map((e) => e.toJson()).toList(),
        'imageUrls': imageUrls,
        'eventIds': eventIds.map((id) => id.toString()).toList(),
        'createdAt': createdAt.toUtc()?.millisecondsSinceEpoch,
        'updatedAt': updatedAt.toUtc()?.millisecondsSinceEpoch,
        'logo': logo,
        'point': point,
      });

  @override
  Map<String, dynamic> toJson() => toFB();

  VenueModel copyWith({
    String id,
    LocationModel location,
    String name,
    String desc,
    int reviews,
    String ownerId,
    String image,
    String logo,
    bool is24Opened,
    String webSite,
    String phoneNumber,
    List<VenueOpenTimesModel> openTimes,
    List<LocationCategoryModel> eventCategories,
    List<String> imageUrls,
    List<dynamic> eventIds,
    DateTime createdAt,
    DateTime updatedAt,

    List<LocationRequirement> categories,
  }) {
    return VenueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      ownerId: ownerId ?? this.ownerId,
      image: image ?? this.image,
      reviews: reviews ?? this.reviews,
      logo: logo ?? this.logo,
      is24Opened: is24Opened ?? this.is24Opened,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      openTimes: openTimes ?? this.openTimes,
      eventCategories: eventCategories ?? this.eventCategories,
      imageUrls: imageUrls ?? this.imageUrls,
      eventIds: eventIds ?? this.eventIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      desc: desc ?? this.desc,
      categories: categories ?? this.categories,
    );
  }
}
