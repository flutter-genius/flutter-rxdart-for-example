import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';

@immutable
class GeoLocationModel extends DataModel {
  final double geoLatitude;
  final double geoLongitude;

  GeoLocationModel({
    this.geoLatitude,
    this.geoLongitude,
  });

  factory GeoLocationModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return GeoLocationModel.fromJson(json);
  }

  factory GeoLocationModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    return GeoLocationModel(
      geoLatitude: json.getVal<double>('geoLatitude'),
      geoLongitude: json.getVal<double>('geoLongitude')
    );
  }

  @override
  copyWith({
    double geoLatitude,
    double geoLongitude,
  }) {
    return GeoLocationModel(
      geoLatitude: geoLatitude ?? this.geoLatitude,
      geoLongitude: geoLongitude ?? this.geoLongitude
    );
  }

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from({
    'geoLatitude': this.geoLatitude,
    'geoLongitude': this.geoLongitude
  });

}