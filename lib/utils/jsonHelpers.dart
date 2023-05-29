import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';

/// JSON accepts object as an object. If you have an array in the root, use List<JSON>.
@immutable
class JSON {
  final Map<String, dynamic> json;

  JSON(this.json);

  T _cast<T>(val, [T fallback]) {
    // if (_debug) print("_cast ${val.toString()}, $T");
    switch (T) {
      case dynamic:
        return val as T;
      case bool:
        return val as T;
      case double:
        return val as T;
      case num:
        return val as T;
      case GeoPoint:
        if (val is List)
          return val.length == 2 ? (GeoPoint(val[0], val[1]) as T) : null;
        return val as T;
      case int:
        return _getInt(val) as T;
      case String:
        return val.toString() as T;
      case DateTime:
        return _getDateTime(val) as T;
      case FirebaseId:
        return FirebaseId(val) as T;
      default:
        return fallback;
    }
  }

  T getVal<T>(String key, [T fallback]) {
    var val = _recursiveDescent(key);
    if (val == null) {
      return fallback;
    }
    return _cast<T>(val, fallback);
  }

  List<T> getList<T>(String key, [List<T> fallback]) {
    var val = _recursiveDescent(key);
    if (val == null) {
      return fallback;
    }
    return val.map<T>((e) => _cast<T>(e)).toList();
  }

  int _getInt(dynamic val) {
    if (val is String) return int.parse(val);
    if (val is int) return val;
    return null;
  }

  DateTime _getDateTime(dynamic val) {
    if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
    if (val is String) return DateTime.parse(val);
    return null;
  }

  /// Works only with object tree without arrays
  dynamic _recursiveDescent(String key) {
    dynamic data = json;
    for (String key in key.split('.')) {
      if (data != null && data.containsKey(key)) {
        data = data[key];
      } else {
        return null;
      }
    }
    return data;
  }
}
