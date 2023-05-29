import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

@immutable
class LocationModel extends DataModel {
  final List<double> coordinates;
  final String address;
  final String city;
  final String street;
  final String country;
  final String state;
  final String postCode;

  LocationModel(
      {this.coordinates,
      this.address = '',
      this.city = '',
      this.street = '',
      this.country = '',
      this.state = '',
      this.postCode = ''});

  factory LocationModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return LocationModel.fromJson(json);
  }

  factory LocationModel.fromJson(Map<String, dynamic> map)  {
    if (map == null) return null;
    var json = JSON(map);
    if (map['coordinates'] != null && map['coordinates'].length > 1) {
      if (map['coordinates'][0] != null) {
        map['coordinates'][0] = map['coordinates'][0].toDouble();
      }
      if (map['coordinates'][1] != null) {
        map['coordinates'][1] = map['coordinates'][1].toDouble();
      }
    }
    var _location = LocationModel(
      coordinates: json.getList<double>('coordinates'),
      address: json.getVal<String>('address'),
      city: json.getVal<String>('city'),
      street: json.getVal<String>('street'),
      country: json.getVal<String>('country'),
      state: json.getVal<String>('state'),
      postCode: json.getVal<String>('postCode'),
    );
    return _location;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'coordinates': coordinates,
        'city': city,
        'address': address,
        'street': street,
        'country': country,
        'state': state,
        'postCode': postCode,
      });

  @override
  Map<String, dynamic> toJson() {
     var map = toFB();
     if(coordinates ==null || coordinates.length <2) {
       map['coordinates'] = [null, null];
     } else {
       map['coordinates'] = [coordinates[0], coordinates[1]];
     }
     return map;
  }

  LocationModel copyWith(
      {List<double> coordinates,
      String address,
      String city,
      String street,
      String country,
      String state,
      String postCode}) {
    return LocationModel(
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
      state: state ?? this.state,
      postCode: postCode ?? this.postCode,
    );
  }
}
