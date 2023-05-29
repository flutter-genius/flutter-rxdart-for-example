import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/jsonHelpers.dart';

import 'feedback.dart';
import 'post_requirement.dart';
import 'location.dart';
import 'model_class.dart';

const _debug = true; // || debug;

enum EventStatusType { open, closed }
enum ApplicantStatusType { my, pending, accepted, standby, declined, full, pastMy, pastAttendees, past, guest }

// const eventModelVersion = EventModelVersion(1);

@immutable
class EventModel extends DataModel {
  final String id;
  final bool isAdminEvent;
  final String categoryId;
  final String subcategoryId;
  final String ownerId;
  final String ownerImageUrl;
  final String name;
  final String description;
  final String imageUrl;
  final String thumbnail;
  final List<String> imageUrls;
  final List<String> imageUrlsNames;
  final List<String> participantsAccepted;
  final List<String> participantsPending;
  final List<String> participantsDeclined;
  final List<String> participantsStandby;
  final List<FeedbackModel> feedback;
  final LocationModel location;
  final String venueId;
  final DateTime startDT;
  final DateTime endDT;
  final EventStatusType status;
  final List<PostRequirement> requirements;
  final GenderType gender;
  final int maxParticipantsNo;
  final bool isFlexibleDate;
  final bool isFlexibleStartTime;
  final bool isFlexibleEndTime;
  final bool unLimitedMaxParticipantsNo;
  final bool isDeleted;
  final String language;
  final DateTime createdAtDT;
  final DateTime updatedAtDT;

  EventModel({
    this.id,
    this.isAdminEvent,
    this.categoryId,
    this.subcategoryId,
    this.ownerId,
    this.venueId,
    this.ownerImageUrl,
    this.requirements,
    this.gender,
    this.name,
    this.description,
    this.imageUrl,
    this.participantsPending,
    this.participantsAccepted,
    this.participantsDeclined,
    this.participantsStandby,
    this.feedback,
    this.imageUrls,
    this.imageUrlsNames,
    this.thumbnail,
    this.location,
    this.maxParticipantsNo = 0,
    this.startDT,
    this.endDT,
    this.status,
    this.isFlexibleDate = false,
    this.isFlexibleStartTime = false,
    this.isFlexibleEndTime = false,
    this.unLimitedMaxParticipantsNo = false,
    this.isDeleted = false,
    this.language,
    this.createdAtDT,
    this.updatedAtDT,
  });

  factory EventModel.initial() {
    return EventModel();
  }

  factory EventModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return EventModel.fromJson(json);
  }

  factory EventModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = EventModel(
      id: json.getVal<String>('_id'),
      isAdminEvent: json.getVal<bool>('isAdminEvent') ?? false,
      categoryId: json.getVal<String>('categoryId'),
      subcategoryId: json.getVal<String>('subcategoryId'),
      ownerId: json.getVal<String>('ownerId'),
      ownerImageUrl: json.getVal<String>('ownerImageUrl'),
      name: json.getVal<String>('name'),
      description: json.getVal<String>('desc'),
      requirements: json.getList<dynamic>('requirements')?.map((e) => PostRequirement.fromMap(e))?.toList(),
      imageUrl: json.getVal<String>('imageUrl'),
      imageUrls: json.getList<String>('imageUrls'),
      imageUrlsNames: json.getList<String>('imageUrls_names'),
      thumbnail: json.getVal<String>('thumbnail'),
      gender: enumHelper.str2enum(GenderType.values, json.getVal<String>('gender') ?? ''),
      participantsAccepted: json.getList<String>('participantsAccepted') ?? [],
      participantsPending: json.getList<String>('participantsPending') ?? [],
      participantsDeclined: json.getList<String>('participantsDeclined') ?? [],
      participantsStandby: json.getList<String>('participantsStandby') ?? [],
      feedback: json.getList<dynamic>('feedback')?.map((e) => FeedbackModel.fromJson(e))?.toList(),
      location: LocationModel.fromJson(json.getVal<dynamic>('location')),
      venueId: json.getVal<String>('venueId'),
      startDT: json.getVal<DateTime>('startDT')?.toLocal(),
      endDT: json.getVal<DateTime>('endDT')?.toLocal(),
      status: enumHelper.str2enum(EventStatusType.values, json.getVal<String>('status')),
      maxParticipantsNo: json.getVal<int>('maxParticipantsNo', 0),
      isFlexibleDate: json.getVal<bool>('isFlexibleDate'),
      isFlexibleStartTime: json.getVal<bool>('isFlexibleStartTime'),
      isFlexibleEndTime: json.getVal<bool>('isFlexibleEndTime'),
      unLimitedMaxParticipantsNo: json.getVal<bool>('isUnLimitActivities'),
      isDeleted: json.getVal<bool>('isDeleted'),
      language: json.getVal<String>('language'),
      createdAtDT: json.getVal<DateTime>('createdAtDT')?.toLocal(),
      updatedAtDT: json.getVal<DateTime>('updatedAtDT')?.toLocal(),
    );
    if ([r.id, r.name, r.description, r.imageUrl].contains(null)) {
      if (_debug) print("BAD EVENT: $r");
      return null;
    }
    return r;
  }

  // factory fromJSON(dynamic map) {

  // }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
        'id': id,
        'isAdminEvent': isAdminEvent,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'ownerId': ownerId,
        'ownerImageUrl': ownerImageUrl,
        'name': name,
        'desc': description,
        'imageUrl': imageUrl,
        'thumbnail': thumbnail,
        'imageUrls': imageUrls,
        'imageUrls_names': imageUrlsNames,
        'participantsAccepted': participantsAccepted.map((e) => e).toList(),
        'participantsPending': participantsPending.map((e) => e).toList(),
        'participantsDeclined': participantsDeclined.map((e) => e).toList(),
        'participantsStandby': participantsStandby.map((e) => e).toList(),
        'feedback': feedback?.map((e) => e.toFB())?.toList(),
        'location': location?.toFB(),
        'venueId': venueId?.toString(),
        'startDT': startDT?.toUtc()?.millisecondsSinceEpoch,
        'gender': enumHelper.enum2str(gender),
        'endDT': endDT?.toUtc()?.millisecondsSinceEpoch,
        'status': enumHelper.enum2str(status),
        'requirements': requirements?.map((e) => e.toMap())?.toList(),
        'maxParticipantsNo': maxParticipantsNo,
        'isFlexibleDate': isFlexibleDate,
        'isFlexibleStartTime': isFlexibleStartTime,
        'isFlexibleEndTime': isFlexibleEndTime,
        'isUnLimitActivities': unLimitedMaxParticipantsNo,
        'isDeleted': isDeleted,
        'language': language,
        'createdAtDT': createdAtDT?.toUtc()?.millisecondsSinceEpoch,
        'updatedAtDT': updatedAtDT?.toUtc()?.millisecondsSinceEpoch,
      });

  @override
  Map<String, dynamic> toJson() => toFB();

  EventModel copyWith({
    String id,
    bool isAdminEvent,
    String categoryId,
    String subcategoryId,
    String ownerId,
    String ownerImageUrl,
    String name,
    String description,
    String imageUrl,
    String thumbnail,
    List<String> imageUrls,
    List<String> imageUrlsNames,
    List<String> participantsAccepted,
    List<String> participantsPending,
    List<String> participantsDeclined,
    List<String> participantsStandby,
    List<FeedbackModel> feedback,
    LocationModel location,
    String venueId,
    DateTime startDT,
    DateTime endDT,
    EventStatusType status,
    GenderType gender,
    List<PostRequirement> requirements,
    int maxParticipantsNo,
    bool isFlexibleDate,
    bool isFlexibleStartTime,
    bool isFlexibleEndTime,
    bool isUnLimitActivities,
    bool isDeleted,
    String language,
    DateTime createdAtDT,
    DateTime updatedAtDT,
  }) =>
      EventModel(
        id: id ?? this.id,
        isAdminEvent: isAdminEvent ?? this.isAdminEvent,
        categoryId: categoryId ?? this.categoryId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        ownerId: ownerId ?? this.ownerId,
        ownerImageUrl: ownerImageUrl ?? this.ownerImageUrl,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        thumbnail: thumbnail ?? this.thumbnail,
        imageUrls: imageUrls ?? this.imageUrls,
        imageUrlsNames: imageUrlsNames ?? this.imageUrlsNames,
        participantsAccepted: participantsAccepted ?? this.participantsAccepted ?? [],
        participantsPending: participantsPending ?? this.participantsPending ?? [],
        participantsDeclined: participantsDeclined ?? this.participantsDeclined ?? [],
        participantsStandby: participantsStandby ?? this.participantsStandby ?? [],
        feedback: feedback ?? this.feedback ?? [],
        location: location ?? this.location,
        venueId: venueId ?? this.venueId,
        gender: gender ?? this.gender,
        startDT: startDT ?? this.startDT,
        endDT: endDT ?? this.endDT,
        status: status ?? this.status,
        requirements: requirements ?? this.requirements,
        maxParticipantsNo: maxParticipantsNo ?? this.maxParticipantsNo,
        isFlexibleDate: isFlexibleDate ?? this.isFlexibleDate,
        isFlexibleStartTime: isFlexibleStartTime ?? this.isFlexibleStartTime,
        isFlexibleEndTime: isFlexibleEndTime ?? this.isFlexibleEndTime,
        unLimitedMaxParticipantsNo: isUnLimitActivities ?? this.unLimitedMaxParticipantsNo,
        isDeleted: isDeleted ?? this.isDeleted,
        language: language ?? this.language,
        createdAtDT: createdAtDT ?? this.createdAtDT,
        updatedAtDT: updatedAtDT ?? this.updatedAtDT,
      );

  ApplicantStatusType statusType(String firebaseId) {
    if (isPassed) {
      if (ownerId == firebaseId) return ApplicantStatusType.pastMy;
      if (participantsAccepted.contains(firebaseId)) return ApplicantStatusType.pastAttendees;
      return ApplicantStatusType.past;
    } else {
      if (ownerId == firebaseId) return ApplicantStatusType.my;
      if (participantsAccepted.contains(firebaseId)) return ApplicantStatusType.accepted;
      if (participantsPending.contains(firebaseId)) return ApplicantStatusType.pending;
      if (participantsStandby.contains(firebaseId)) return ApplicantStatusType.standby;
      if (participantsDeclined.contains(firebaseId)) return ApplicantStatusType.declined;
      if (unLimitedMaxParticipantsNo ?? false) return ApplicantStatusType.guest;
      if (participantsAccepted.length >= maxParticipantsNo ?? 0) return ApplicantStatusType.full;
      return ApplicantStatusType.guest;
    }
  }

  // ignore: null_aware_before_operator
  bool get isPassed => startDT.toUtc()?.millisecondsSinceEpoch < DateTime.now().toUtc()?.millisecondsSinceEpoch;
  bool isGivenFeedback(String userId) => (feedback ?? []).indexWhere((element) => element.userId == userId) >= 0;
}
