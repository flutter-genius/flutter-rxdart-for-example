import 'package:flutter/foundation.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'model_class.dart';

@immutable
class VenueOpenTimesModel extends DataModel {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClose;

  VenueOpenTimesModel({
    this.day,
    this.openTime,
    this.closeTime,
    this.isClose,
  });

  factory VenueOpenTimesModel.fromFB(Map<String, dynamic> map) {
    if (map == null) return null;
    var json = JSON(map);

    return VenueOpenTimesModel(
      day: json.getVal<String>('day'),
      openTime: json.getVal<String>('openTime'),
      closeTime: json.getVal<String>('closeTime'),
      isClose: json.getVal<bool>('isClose'),
    );
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'day': day,
        'openTime': openTime,
        'closeTime': closeTime,
        'isClose': isClose,
      });

  @override
  Map<String, dynamic> toJson() {
    var map = toFB();
    return map;
  }

  VenueOpenTimesModel copyWith({
    String day,
    String openTime,
    String closeTime,
    bool isClose,
  }) {
    return VenueOpenTimesModel(
      day: day ?? this.day,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClose: isClose ?? this.isClose,
    );
  }
}
