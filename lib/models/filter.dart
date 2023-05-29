import 'package:hittapa/models/event_category.dart';
import 'package:hittapa/models/models.dart';

class FilterModel {
  int _distance;
  EventCategoryModel _category;
  DateTime _fromDate;
  DateTime _toDate;
  String _language;
  bool _isOpenUnLimit;
  bool _isChildrenEvent;
  String _gender;
  LocationModel _location;

  int get distance => this._distance;

  EventCategoryModel get category => this._category;

  DateTime get fromDate => this._fromDate;

  DateTime get toDate => this._toDate;

  String get language => this._language;

  bool get isOpenUnLimit => this._isOpenUnLimit;

  bool get isChildrenEvent => this._isChildrenEvent;

  String get gender => this._gender;

  LocationModel get location => this._location;

  FilterModel(
      {int distance,
      EventCategoryModel category,
      DateTime fromDate,
      DateTime toDate,
      String language,
      bool isOpenUnLimit,
      bool isChildrenEvent,
      String gender,
      LocationModel location
      }) {
    this._distance = distance;
    this._category = category;
    this._fromDate = fromDate;
    this._toDate = toDate;
    this._language = language;
    this._isOpenUnLimit = isOpenUnLimit;
    this._isChildrenEvent = isChildrenEvent;
    this._gender = gender;
    this._location = location;
  }

  int getCount() {
    int n = 0;
    if (this._distance != null) n++;
    if (this._category != null) n++;
    if (this._fromDate != null) n++;
    if (this._toDate != null) n++;
    if (this._language != null) n++;
    if (this._isOpenUnLimit ?? false) n++;
    if (this._isChildrenEvent ?? false) n++;
    if (this._gender != null) n++;
    // if (this._location != null) n++;
    return n;
  }

  set distance(int value) {
    this._distance = value;
  }

  set category(EventCategoryModel value) {
    this._category = value;
  }

  set fromDate(DateTime value) {
    this._fromDate = value;
  }

  set toDate(DateTime value) {
    this._toDate = value;
  }

  set language(String value) {
    this._language = value;
  }

  set isOpenUnLimit(bool value) {
    this._isOpenUnLimit = value;
  }

  set isChildrenEvent(bool value) {
    this._isChildrenEvent = value;
  }

  set gender(String value) {
    this._gender = value;
  }

  set location(LocationModel value) {
    this._location = value;
  }

  FilterModel.map(dynamic obj) {
    this._distance = obj['distance'];
    this._category = obj['category'] == null
        ? null
        : EventCategoryModel.fromJson(obj['category']);
    this._fromDate = obj['from_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(obj['from_date']).toLocal()
        : null;
    this._toDate = obj['to_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(obj['to_date']).toLocal()
        : null;
    this._language = obj['language'];
    this._isOpenUnLimit = obj['is_open_unlimit'];
    this._isChildrenEvent = obj['is_children_event'];
    this._gender = obj['gender'];
    this._location = obj['location']== null ? null : LocationModel.fromJson(obj['category']);
  }

  FilterModel.fromMap(Map<String, dynamic> obj) {
    this._distance = obj['distance'];
    this._category = obj['category'] == null
        ? null
        : EventCategoryModel.fromJson(obj['category']);
    this._fromDate = obj['from_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(obj['from_date']).toLocal()
        : null;
    this._toDate = obj['to_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(obj['to_date']).toLocal()
        : null;
    this._language = obj['language'];
    this._isOpenUnLimit = obj['is_open_unlimit'];
    this._isChildrenEvent = obj['is_children_event'];
    this._gender = obj['gender'];
    this._location = obj['location'] == null ? null : LocationModel.fromJson(obj['location']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['distance'] = this._distance;
    if (this._category != null)
      map['category'] = this._category.toFB();
    else
      map['category'] = null;
    if (this._fromDate != null)
      map['from_date'] = this._fromDate.toUtc()?.millisecondsSinceEpoch;
    else
      map['from_date'] = null;
    if (this._toDate != null)
      map['to_date'] = this._toDate.toUtc()?.millisecondsSinceEpoch;

    map['language'] = this._language;

    map['is_open_unlimit'] = this._isOpenUnLimit;

    map['is_children_event'] = this._isChildrenEvent;
    map['gender'] = this._gender;
    if (this._location != null) map['location'] = this._location.toJson();
    return map;
  }
}
