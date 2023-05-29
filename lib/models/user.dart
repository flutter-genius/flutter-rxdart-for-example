import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import '../config.dart';
import '../services/cloud_firestore_service.dart';

const _debug = true; // || debug;

enum GenderType { male, female, non_binary, all_gender }

enum DeviceType { ios, android }

enum RegisterType { email, facebook, google, bank }

@immutable
class UserModel extends DataModel {
  final String id;
  final String username; // in most cases this is the first name
  final String email;
  final String avatar;
  final GenderType gender;
  final DateTime birthday;
  final String facebookId;
  final String googleId;
  final LocationModel location;
  final String mobile;
  final DeviceType deviceType;
  final String deviceId;
  final RegisterType registerType;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> acceptedEventIds;
  final bool isEnableNotificationAppliedEvent;
  final bool isEnableNotificationAcceptEvent;
  final bool isEnableNotificationMessage;
  final bool isEnableNotificationReminderActivity;
  final bool isEnableNotificationReminderFeedback;
  final String fcmToken;
  final String apiToken;
  final String password;
  final String uid;

  /// this is the id of user mongodb
  final List<LocationModel> savedLocations;
  final List<PostRequirement> requirements;
  final String eventLanguage;
  final List<String> recentLanguages;
  final List<EventSubcategoryModel> recentSubcategories;
  final bool isAcceptTermsUse;
  final bool isAcceptPrivacyPolicy;
  final int userRole;

  UserModel({
    this.id,
    this.username,
    this.email,
    // this.firstName,
    // this.lastName,
    this.avatar,
    this.gender,
    this.birthday,
    this.facebookId,
    this.googleId,
    this.location,
    this.mobile,
    this.deviceType,
    this.deviceId,
    this.registerType,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.createdAt,
    this.updatedAt,
    this.acceptedEventIds,
    this.isEnableNotificationAppliedEvent = true,
    this.isEnableNotificationAcceptEvent = true,
    this.isEnableNotificationMessage = true,
    this.isEnableNotificationReminderActivity = true,
    this.isEnableNotificationReminderFeedback = true,
    this.fcmToken,
    this.apiToken,
    this.password,
    this.uid,
    this.savedLocations,
    this.requirements,
    this.eventLanguage,
    this.recentLanguages,
    this.recentSubcategories,
    this.isAcceptTermsUse,
    this.isAcceptPrivacyPolicy,
    this.userRole,
  });

  factory UserModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return UserModel.fromJson(json);
  }

  factory UserModel.fromReduxJson(Map<String, dynamic> map) {
    if (_debug) print("UserModel.fromJson ${map['birthday']}");
    var json = JSON(map);
    var r = UserModel(
      id: json.getVal<String>('id'),
      username: json.getVal<String>('username'),
      uid: json.getVal<String>('uid'),
      email: json.getVal<String>('email'),
      // firstName: json.getVal<String>('firstName'),
      // lastName: json.getVal<String>('lastName'),
      avatar: json.getVal<String>('avatar'),
      gender: enumHelper.str2enum(GenderType.values, json.getVal<String>('gender')),
      birthday: json.getVal<DateTime>('birthday'),
      facebookId: json.getVal<String>('facebookId'),
      googleId: json.getVal<String>('googleId'),
      location: LocationModel.fromJson(json.getVal<dynamic>('location')),
      mobile: json.getVal<String>('mobile'),
      deviceType: enumHelper.str2enum(DeviceType.values, json.getVal<String>('deviceType')),
      deviceId: json.getVal<String>('deviceId'),
      registerType: enumHelper.str2enum(RegisterType.values, json.getVal<String>('registerType')),
      isEmailVerified: json.getVal<bool>('isEmailVerified'),
      isPhoneVerified: json.getVal<bool>('isPhoneVerified'),
      createdAt: json.getVal<DateTime>('createdAt'),
      updatedAt: json.getVal<DateTime>('updatedAt'),
      acceptedEventIds: json.getList<String>('acceptedEventIds'),
      isEnableNotificationAppliedEvent: json.getVal<bool>('isEnableNotificationAppliedEvent'),
      isEnableNotificationAcceptEvent: json.getVal<bool>('isEnableNotificationAcceptEvent'),
      isEnableNotificationMessage: json.getVal<bool>('isEnableNotificationMessage'),
      isEnableNotificationReminderActivity: json.getVal<bool>('isEnableNotificationReminderActivity'),
      isEnableNotificationReminderFeedback: json.getVal<bool>('isEnableNotificationReminderFeedback'),
      fcmToken: json.getVal<String>('fcmToken'),
      apiToken: json.getVal<String>('apiToken'),
      password: json.getVal<String>('password'),
      savedLocations: json.getList<dynamic>('saved_locations')?.map((e) => LocationModel.fromJson(e))?.toList(),
      requirements: json.getList<dynamic>('requirements')?.map((e) => PostRequirement.fromMap(e))?.toList(),
      eventLanguage: json.getVal<String>('eventLanguage'),
      recentLanguages: json.getList<String>('recentLanguages'),
      recentSubcategories: json.getList<dynamic>('recentSubcategories')?.map((e) => EventSubcategoryModel.fromJson(e))?.toList(),
      isAcceptTermsUse: json.getVal<bool>('isAcceptTermsUse'),
      isAcceptPrivacyPolicy: json.getVal<bool>('isAcceptPrivacyPolicy'),
      userRole: json.getVal<int>('user_role'),
    );
    // This is check needed for OAuth. Google and FB gives only id and email
    if ([r.id, r.email].contains(null)) {
      if (_debug) print("BAD USER: $r");
      return null;
    }
    return r;
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    if (_debug) print("UserModel.fromJson ${map['birthday']}");
    var json = JSON(map);
    var r = UserModel(
      id: json.getVal<String>('id'),
      username: json.getVal<String>('username'),
      email: json.getVal<String>('email'),
      // firstName: json.getVal<String>('firstName'),
      // lastName: json.getVal<String>('lastName'),
      avatar: json.getVal<String>('avatar'),
      gender: enumHelper.str2enum(GenderType.values, json.getVal<String>('gender')),
      birthday: json.getVal<DateTime>('birthday'),
      facebookId: json.getVal<String>('facebookId'),
      googleId: json.getVal<String>('googleId'),
      location: LocationModel.fromJson(json.getVal<dynamic>('location')),
      mobile: json.getVal<String>('mobile'),
      deviceType: enumHelper.str2enum(DeviceType.values, json.getVal<String>('deviceType')),
      deviceId: json.getVal<String>('deviceId'),
      registerType: enumHelper.str2enum(RegisterType.values, json.getVal<String>('registerType')),
      isEmailVerified: json.getVal<bool>('isEmailVerified'),
      isPhoneVerified: json.getVal<bool>('isPhoneVerified'),
      createdAt: json.getVal<DateTime>('createdAt'),
      updatedAt: json.getVal<DateTime>('updatedAt'),
      acceptedEventIds: json.getList<String>('acceptedEventIds'),
      isEnableNotificationAppliedEvent: json.getVal<bool>('isEnableNotificationAppliedEvent'),
      isEnableNotificationAcceptEvent: json.getVal<bool>('isEnableNotificationAcceptEvent'),
      isEnableNotificationMessage: json.getVal<bool>('isEnableNotificationMessage'),
      isEnableNotificationReminderActivity: json.getVal<bool>('isEnableNotificationReminderActivity'),
      isEnableNotificationReminderFeedback: json.getVal<bool>('isEnableNotificationReminderFeedback'),
      fcmToken: json.getVal<String>('fcmToken'),
      apiToken: json.getVal<String>('apiToken'),
      password: json.getVal<String>('password'),
      uid: json.getVal<String>('_id'),
      savedLocations: json.getList<dynamic>('saved_locations')?.map((e) => LocationModel.fromJson(e))?.toList(),
      requirements: json.getList<dynamic>('requirements')?.map((e) => PostRequirement.fromMap(e))?.toList(),
      eventLanguage: json.getVal<String>('eventLanguage'),
      recentLanguages: json.getList<String>('recentLanguages'),
      recentSubcategories: json.getList<dynamic>('recentSubcategories')?.map((e) => EventSubcategoryModel.fromJson(e))?.toList(),
      isAcceptTermsUse: json.getVal<bool>('isAcceptTermsUse'),
      isAcceptPrivacyPolicy: json.getVal<bool>('isAcceptPrivacyPolicy'),
      userRole: json.getVal<int>('user_role') ?? 2,
    );
    // This is check needed for OAuth. Google and FB gives only id and email
    // if ([r.id, r.email].contains(null)) {
    //   if (_debug) print("BAD USER: $r");
    //   return null;
    // }
    if ([r.email].contains(null)) {
      if (_debug) print("BAD USER: $r");
      return null;
    }
    return r;
  }

  Map<String, dynamic> toFB() {
    return Map<String, dynamic>.from({
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'gender': enumHelper.enum2str(gender) ?? "hen",
      'birthday': birthday?.toUtc()?.millisecondsSinceEpoch,
      'facebookId': facebookId,
      'googleId': googleId,
      'location': location?.toFB(),
      'mobile': mobile,
      'deviceType': enumHelper.enum2str(deviceType),
      'deviceId': deviceId,
      'registerType': enumHelper.enum2str(registerType),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdAt': createdAt?.toUtc()?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.toUtc()?.millisecondsSinceEpoch,
      'acceptedEventIds': acceptedEventIds,
      'isEnableNotificationAppliedEvent': isEnableNotificationAppliedEvent,
      'isEnableNotificationAcceptEvent': isEnableNotificationAcceptEvent,
      'isEnableNotificationMessage': isEnableNotificationMessage,
      'isEnableNotificationReminderActivity': isEnableNotificationReminderActivity,
      'isEnableNotificationReminderFeedback': isEnableNotificationReminderFeedback,
      'fcmToken': fcmToken,
      'apiToken': apiToken,
      'password': password,
      'uid': uid,
      'saved_locations': savedLocations?.map((e) => e.toFB())?.toList(),
      'requirements': requirements?.map((e) => e.toMap())?.toList(),
      'eventLanguage': eventLanguage,
      'recentSubcategories': recentSubcategories?.map((subcategory) => subcategory.toFB())?.toList(),
      'recentLanguages': recentLanguages,
      'isAcceptTermsUse': isAcceptTermsUse,
      'isAcceptPrivacyPolicy': isAcceptPrivacyPolicy,
      'user_role': userRole,
    });
  }

  @override
  Map<String, dynamic> toJson() {
    var map = toFB();

    map['location'] = location?.toJson();
    if (_debug) print("UserModel.toJson: ${map.toString()}");
    return map;
  }

  UserModel copyWith({
    String id,
    String username,
    String email,
    // String firstName,
    // String lastName,
    String avatar,
    GenderType gender,
    DateTime birthday,
    String facebookId,
    String googleId,
    LocationModel location,
    String mobile,
    DeviceType deviceType,
    String deviceId,
    RegisterType registerType,
    bool isEmailVerified,
    bool isPhoneVerified,
    DateTime createdAt,
    DateTime updatedAt,
    List<FirebaseId> acceptedEventIds,
    bool isEnableNotificationAppliedEvent,
    bool isEnableNotificationAcceptEvent,
    bool isEnableNotificationMessage,
    bool isEnableNotificationReminderActivity,
    bool isEnableNotificationReminderFeedback,
    String fcmToken,
    String apiToken,
    String password,
    String uid,
    List<LocationModel> savedLocations,
    List<PostRequirement> requirements,
    String eventLanguage,
    List<String> recentLanguages,
    List<EventSubcategoryModel> recentSubcategories,
    bool isAcceptTermsUse,
    bool isAcceptPrivacyPolicy,
    int userRole,
  }) {
    if (_debug) print("UserModel.copyWith");
    return UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        // firstName: firstName ?? this.firstName,
        // lastName: lastName ?? this.lastName,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        facebookId: facebookId ?? this.facebookId,
        googleId: googleId ?? this.googleId,
        location: location ?? this.location,
        mobile: mobile ?? this.mobile,
        deviceType: deviceType ?? this.deviceType,
        deviceId: deviceId ?? this.deviceId,
        registerType: registerType ?? this.registerType,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        acceptedEventIds: acceptedEventIds ?? this.acceptedEventIds,
        isEnableNotificationAppliedEvent: isEnableNotificationAppliedEvent ?? this.isEnableNotificationAppliedEvent,
        isEnableNotificationAcceptEvent: isEnableNotificationAcceptEvent ?? this.isEnableNotificationAcceptEvent,
        isEnableNotificationMessage: isEnableNotificationMessage ?? this.isEnableNotificationMessage,
        isEnableNotificationReminderActivity: isEnableNotificationReminderActivity ?? this.isEnableNotificationReminderActivity,
        isEnableNotificationReminderFeedback: isEnableNotificationReminderFeedback ?? this.isEnableNotificationReminderFeedback,
        fcmToken: fcmToken ?? this.fcmToken,
        apiToken: apiToken ?? this.apiToken,
        password: password ?? this.password,
        uid: uid ?? this.uid,
        savedLocations: savedLocations ?? this.savedLocations,
        requirements: requirements ?? this.requirements,
        eventLanguage: eventLanguage ?? this.eventLanguage,
        recentLanguages: recentLanguages ?? this.recentLanguages,
        recentSubcategories: recentSubcategories ?? this.recentSubcategories,
        isAcceptTermsUse: isAcceptTermsUse ?? this.isAcceptTermsUse,
        isAcceptPrivacyPolicy: isAcceptPrivacyPolicy ?? this.isAcceptPrivacyPolicy,
        userRole: userRole ?? this.userRole);
  }
}
