import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/jsonHelpers.dart';
import 'model_class.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/enumHelpers.dart';

@immutable
class FeedbackModel extends DataModel {
  final String comment;
  final int rating;
  final String username;
  final int age;
  final String avatar;
  final DateTime createdAt;
  final String userId;
  final bool isAnnoys;
  final GenderType gender;

  FeedbackModel({
    this.comment,
    this.rating,
    this.username,
    this.avatar,
    this.age,
    this.createdAt,
    this.userId,
    this.isAnnoys,
    this.gender,
  });

  factory FeedbackModel.initial() {
    return FeedbackModel();
  }

  factory FeedbackModel.fromFB(DocumentSnapshot snapshot) {
    var json = snapshot.data();
    return FeedbackModel.fromJson(json);
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> map) {
    var json = JSON(map);
    var r = FeedbackModel(
      username: json.getVal<String>('username'),
      avatar: json.getVal<String>('avatar'),
      age: json.getVal<int>('age'),
      comment: json.getVal<String>('comment'),
      rating: json.getVal<int>('rating'),
      createdAt: json.getVal<DateTime>('created_at')?.toLocal(),
      userId: json.getVal<String>('user_id'),
      isAnnoys: json.getVal<bool>('isAnnoys'),
      gender: enumHelper.str2enum(GenderType.values, json.getVal<String>('gender') ?? ''),
    );
    return r;
  }

  Map<String, dynamic> toFB() => Map<String, dynamic>.from({
    'username': username,
    'avatar': avatar,
    'age': age,
    'comment': comment,
    'rating': rating,
    'created_at': createdAt.toUtc()?.millisecondsSinceEpoch,
    'user_id': userId,
    'isAnnoys' : isAnnoys,
    'gender': enumHelper.enum2str(gender),
  });

  @override
  Map<String, dynamic> toJson() => toFB();

  @override
  FeedbackModel copyWith({
    String comment,
    int rating,
    String username,
    int age,
    String avatar,
    DateTime createdAt,
    FirebaseId userId,
    bool isAnnoys,
    GenderType gender,
  }) => FeedbackModel(
      username: username ?? this.username,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      userId: userId ?? this.userId,
      isAnnoys: isAnnoys ?? this.isAnnoys,
      gender: gender ?? this.gender
  );


}
