import 'package:flutter/material.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/models/models.dart';

const _debug = true; // || debug;

@immutable
class AppState extends DataModel {
  final bool firstRun;
  final DateTime dataUpdateTime;

  /// Place to store data from Event Creator
  final EventModel newEvent;

  /// Autoupdating Event categories cache
  final List<EventCategoryModel> eventCategories;

  final FilterModel eventFilter;

  /// background image
  final BackgroundImageModel backgroundImage;

  /// Logged in user
  final UserModel user;
  final bool loggedIn;
  final String userToken;
  final int cacheModelVersion;

  final bool isTop;

  final GeoLocationModel geoLocationData;

  static DateTime zeroTS = DateTime.fromMillisecondsSinceEpoch(0);

  AppState({
    this.cacheModelVersion = CACHE_MODEL_VERSION,
    this.firstRun = true,
    this.dataUpdateTime,

    /// place to keep event creator data
    this.newEvent,
    this.eventCategories,
    this.backgroundImage,

    this.eventFilter,

    /// Logged in user
    this.user,
    this.loggedIn = false,

    /// Firebase user token
    this.userToken,
    // this.venues,

    /// this is the top of screen by scrollable
    this.isTop = true,

    this.geoLocationData,
  });

  factory AppState.initial() {
    return AppState(
      dataUpdateTime: AppState.zeroTS,
    );
  }

  // the json must be of dynamic type due to Redux Persist requirement
  static AppState fromJson(dynamic json) {
    if (_debug) print("LOAD State $json");

    // when we open app for the first time, hdd is empty and redux persist returns null.
    if (json == null || json["cacheModelVersion"] != CACHE_MODEL_VERSION) {
      if (_debug) print("AppState JSON is null");
      return AppState.initial();
    }

    // XXX Redux persist expects function(dynamic), but we save JSON with object in the root, The following line 'converts' dynamic to Map.
    Map<String, dynamic> data = json;

    print(data['recentSubcategories']);

    return AppState(
      cacheModelVersion: data['cacheModelVersion'],
      firstRun: data['firstRun'],
      dataUpdateTime:
          DateTime.fromMillisecondsSinceEpoch(data['dataUpdateTime']),
      userToken: data['userToken'],
      user: UserModel.fromReduxJson(data['user']),
      eventFilter: FilterModel.fromMap(data['filter'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    if (_debug) print("AppState.toJson SAVE STATE");
    return {
      "cacheModelVersion": CACHE_MODEL_VERSION,
      "firstRun": this.firstRun,
      "dataUpdateTime": this.dataUpdateTime.toUtc()?.millisecondsSinceEpoch,
      "userToken": this.userToken,
      "user": this.user?.toJson(),
      "filter": this.eventFilter?.toMap(),
    };
  }

  AppState copyWith({
    bool firstRun,
    bool loggedIn,
    DateTime dataUpdateTime,
    EventModel newEvent,
    List<EventCategoryModel> eventCategories,
    UserModel user,
    String userToken,
    FilterModel filter,
    BackgroundImageModel backgroundImage,
    bool isTop,
    GeoLocationModel geoLocationData,
  }) {
    return AppState(
      firstRun: firstRun ?? this.firstRun,
      loggedIn: loggedIn ?? this.loggedIn,
      dataUpdateTime: dataUpdateTime ?? this.dataUpdateTime,
      newEvent: newEvent ?? this.newEvent,
      eventCategories: eventCategories ?? this.eventCategories,
      user: user ?? this.user,
      userToken: userToken ?? this.userToken,
      eventFilter: filter ?? this.eventFilter,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      isTop: isTop ?? this.isTop,
      geoLocationData: geoLocationData ?? this.geoLocationData,
    );
  }

  @override
  int get hashCode {
    return hashValues(
      firstRun.hashCode,
      dataUpdateTime.hashCode,
      newEvent.hashCode,
      loggedIn.hashCode,
      userToken.hashCode,
    );
  }

  bool operator ==(other) {
    if (other is! AppState) return false;
    return this.firstRun == other.firstRun &&
        this.dataUpdateTime == other.dataUpdateTime &&
        this.loggedIn == other.loggedIn &&
        this.newEvent == other.newEvent &&
        this.user == other.owner &&
        this.userToken == other.userToken;
  }
}
