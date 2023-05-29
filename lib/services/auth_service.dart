import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';

import '../config.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String sessionUid;

  Future<User> createNewAccount(UserModel user, String password) async {
    try {
      var _result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      var _userUid = _result.user.uid;
      FB.createUser(_userUid, user.toFB());
      sessionUid = _userUid;

      return _result.user;
    } catch (e) {
      if (debug) print(e.toString());
      return null;
    }
  }

  Future<User> signInEmail(String email, String pwd) async {
    try {
      var _result =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      var _user = _result.user.uid;
      sessionUid = _user;
      if (debug) print("sessionUid $sessionUid");
      return _result.user;
    } catch (e) {
      if (debug) print("error: ${e.toString()}");
      return null;
    }
  }

  Future<bool> requestEmailCheck(BuildContext context, String email) async {
    try {
      List<String> _methods =
          await _auth.fetchSignInMethodsForEmail(email);
      print(_methods);
      if (_methods.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' ||
          error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return false;
  }

  Future<String> getUid() async {
    User fireUser = FirebaseAuth.instance.currentUser;
    String uid = fireUser.uid;
    print(uid);
    return uid;
  }

}
