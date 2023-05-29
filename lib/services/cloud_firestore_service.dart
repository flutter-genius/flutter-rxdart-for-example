import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hittapa/models/user.dart';

import '../config.dart';

@immutable
class FirebaseId {
  final String id;

  FirebaseId(this.id);

  String toString() => id;

  bool get isNotEmpty => id.isNotEmpty;

  bool get isEmpty => id.isEmpty;

  @override
  int get hashCode {
    return id.hashCode;
  }

  bool operator ==(other) {
    return id == other.id;
  }
}

class FB {
  static const CHAT_COLLECTION = 'chat';

  static const EVENT_COLLECTION = 'events';
  static const CATEGORIES_COLLECTION = 'event_categories';
  static const USERS_COLLECTION = 'users';
  static const EVENT_CHATROOM_COLLECTION = 'chatroom';
  static const LOCATION_COLLECTION = 'locations';
  static const LOCATION_CATEGORIES_COLLECTION = 'location_categories';
  static const NOTIFICATION_COLLECTION = 'notifications';
  static const UNREAD_COLLECTION = 'unread_messages';
  static const MESSAGE_COLLECTION = 'messages';


  static createUser(String uid, Map<String, dynamic> map) async {
    try {
      var docRef = FirebaseFirestore.instance.doc('users/$uid');
      await docRef.set(map);
    } catch (error) {
      if (debug) print(error);
    }
  }

  static updateDbAccount(Map<String, dynamic> map, String uid) {
    try {
      FirebaseFirestore.instance.doc('users/$uid').update(map);
    } catch (error) {
      print(error);
    }
  }

  static Future<bool> checkIfUserExists(String uid) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return !snapshot.exists || snapshot == null;
  }

  static Future<DocumentSnapshot> getFirestoreDocument(String url) async {
    if (debug) print('getFirestoreDocument, $url');
    try {
      var r = FirebaseFirestore.instance.doc(url);
      return await r.get();
    } catch (error) {
      if (debug) print(error);
      return null;
    }
  }

  static Future<UserModel> getFirestoreUser(FirebaseId uid) async {
    try {
      final docRef = FirebaseFirestore.instance.doc('users/${uid.toString()}');
      final response = await docRef.get();
      return UserModel.fromFB(response);
    } catch (error) {
      if (debug) print('Error in getFirestoreUser $error');
      return null;
    }
  }

  static Future<String> postNewFirestoreDocumentInCollection(
      String url, Map<String, dynamic> map) async {
    if (debug) print('postFirestoreDocument, $url');
    try {
      DocumentReference ref = await FirebaseFirestore.instance.collection(url).add(map);
      return ref.toString();
    } catch (error) {
      print(error);
      return null;
    }
  }

  static updateFirestoreDocument(String url, Map<String, dynamic> map) {
    try {
      FirebaseFirestore.instance.doc(url).set(map);
    } catch (error) {
      print(error);
    }
  }
}
