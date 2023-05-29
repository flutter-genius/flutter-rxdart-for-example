import 'package:firebase_auth/firebase_auth.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/services/http_service.dart';

import '../config.dart';
import '../models/user.dart';
import 'package:hittapa/global.dart';

class NodeAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String sessionUid;

  Future<User> createNewAccount(UserModel user, String password) async {
    try {
      var _result = await _auth.createUserWithEmailAndPassword(email: user.email, password: password);
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
      var _result = await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      var _user = _result.user.uid;
      sessionUid = _user;
      if (debug) print("sessionUid $sessionUid");
      return _result.user;
    } catch (e) {
      if (debug) print("error: ${e.toString()}");
      return null;
    }
  }

  Future<dynamic> requestEmailCheck(String email) async {
    try {
      Map data = {'email': email};
      Map _methods = await requestUnAuthPost(AUTH_EMAIL_URL, data);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return false;
  }

  /// create user
  Future<dynamic> createUser(Map<String, dynamic> data) async {
    try {
      print(data);
      Map _methods = await requestUnAuthPost(AUTH_REGISTER_URL, data);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  /// create the social user (google and facebook)
  Future<dynamic> createSocialUser(Map<String, dynamic> data) async {
    try {
      Map _methods = await requestUnAuthPost(AUTH_SOCIAL_URL, data);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  Future<dynamic> updateUser(Map<String, dynamic> data, String uid) async {
    try {
      Map _methods = await requestPatch(USER_UPDATE_URL, data, uid);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  Future<dynamic> addUser(Map<String, dynamic> data) async {
    try {
      Map _methods = await requestAuthPost(USER_ADD_URL, data, apiToken);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
      return error;
    }
  }

  /// upload file to the node.js server
  Future<String> uploadFile(String base64Image, String type, String extension) async {
    try {
      Map data = {'base64Image': base64Image, 'type': type, 'extension': extension};
      Map _methods = await requestUnAuthPost(FILE_UPLOAD_URL, data);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  /// upload avatar to the node.js server
  Future<String> uploadAvatar(String base64Image, String uid, String extension) async {
    try {
      Map data = {'base64Image': base64Image, 'uid': uid, 'extension': extension};
      Map _methods = await requestUnAuthPost(AVATAR_UPLOAD_URL, data);
      return _methods['data'];
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  /// login
  Future<dynamic> login(String email, String password, String deviceType, String deviceId) async {
    try {
      Map data = {'email': email, 'password': password, 'deviceType': deviceType, 'deviceId': deviceId};
      Map _methods = await requestUnAuthPost(AUTH_LOGIN_URL, data);
      return _methods;
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  /// get user using mongodb uid
  Future<dynamic> getUser(String uid, String token) async {
    try {
      token = token == null ? apiToken : token;
      Map _methods = await requestAuthGet(GET_USER_URL, uid, token);
      return _methods;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// get agora token
  Future<dynamic> getAgoraToken(String channel, String role) async {
    try {
      Map _data = {'channel': channel, 'role': role};
      Map _methods = await requestAuthPost(USER_GET_AGORA_TOKEN, _data, apiToken);
      return _methods;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// update user fcm token api
  Future<dynamic> updateUserToken(String fcmToken) async {
    try {
      Map _data = {'fcm_token': fcmToken};
      if (apiToken != null) {
        Map _result = await requestAuthPost(USER_UPDATE_FCMTOKEN, _data, apiToken);
        print(_result);
      } else {
        print('@@@@@ there is no apitoken in the app');
      }
    } catch (e) {
      print('@@@@@ this is the update fcmtoken api error');
      print(e.toString());
    }
  }

  /// send notification and welcome message to the use when register
  Future<dynamic> sendNotiApi(Map<String, dynamic> _data) async {
    try {
      if (apiToken != null) {
        Map _result = await requestAuthPost(USER_SEND_NOTIFICATION, _data, apiToken);
        print(_result);
      } else {
        print('@@@@@ there is no apitoken in the app');
      }
    } catch (e) {
      print('@@@@@ this is the update fcmtoken api error');
      print(e.toString());
    }
  }

  Future<String> getUid() async {
    User fireUser = FirebaseAuth.instance.currentUser;
    String uid = fireUser.uid;
    print(uid);
    return uid;
  }

  // forgot password send request
  Future<dynamic> forgotPassword(String email) async {
    try {
      Map data = {
        'email': email,
      };
      Map _methods = await requestUnAuthPost(AUTH_FORGOTPASSWORD_URL, data);
      return _methods;
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  // Check verify code url
  Future<dynamic> checkVerifyCode(Map<String, dynamic> _data) async {
    try {
      Map _methods = await requestUnAuthPost(AUTH_CHECKVERIFYCODE_URL, _data);
      return _methods;
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

  // reset password resetPassword
  Future<dynamic> resetPassword(Map<String, dynamic> _data) async {
    try {
      Map _methods = await requestUnAuthPost(AUTH_RESETPASSWORD_URL, _data);
      return _methods;
    } catch (error) {
      if (error.code == 'ERROR_INVALID_EMAIL' || error.code == 'ERROR_USER_NOT_FOUND') {
        if (debug) print(error.code);
      } else {
        if (debug) print(error.code);
      }
    }
    return null;
  }

// Future<String> getUserName() async{
//   String _uid = await getUid();
//   DocumentSnapshot _documentSnapshot = await Firestore.instance.document('users/$_uid').get();
//   String _name = _documentSnapshot['firstname'];
//   return _name;
// }
}
