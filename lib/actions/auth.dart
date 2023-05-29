import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/screens/screens.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

String fetchFirstName(String displayName) {
  if (displayName.contains(' ')) {
    return displayName.split(' ').first;
  } return displayName;
}

ThunkAction<AppState> logInWithGoogle(String deviceType, String deviceId) {
  return (Store<AppState> store) async {
    if (debug) print("logInWithGoogle Thunk");
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
        'email',
        'profile',
      ]);
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var authResult = await firebaseAuth.signInWithCredential(credential);
      final User firebaseUser = firebaseAuth.currentUser;
      assert(authResult.user.uid == firebaseUser.uid);
      assert(firebaseUser.email != null);
      assert(firebaseUser.displayName != null);
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);        
      String _token = await FirebaseMessaging.instance.getToken();
      var appUser = await NodeAuthService().requestEmailCheck(firebaseUser.email);
      UserModel user;  
      if (appUser?.length == 0) {
        user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          username: fetchFirstName(firebaseUser.displayName),
          googleId: googleUser.id,
          isEmailVerified: firebaseUser.emailVerified,
          avatar: firebaseUser.photoURL,
          registerType: RegisterType.google,
          deviceType: enumHelper.str2enum(DeviceType.values, deviceType),
          deviceId: deviceId,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          // location: _location,
          fcmToken: _token
        );
        try {
          var apiResult = await NodeAuthService().createSocialUser(user.toFB());
          user = user.copyWith(
            uid: apiResult['_id']
          );
          if(!firebaseUser.emailVerified) {
            try{
              await firebaseUser.sendEmailVerification();
              return firebaseUser.uid;
            }catch(e){
              print("An error occured while trying to send email verification");
              print(e.message);
            }
          }
        } catch (error) {
          if (debug) print(error);
        }
      } else {
        user = UserModel.fromJson(appUser);
        user = user.copyWith(
          googleId: googleUser.id,
          fcmToken: _token,
          registerType: RegisterType.google,
          deviceType: enumHelper.str2enum(DeviceType.values, deviceType),
          deviceId: deviceId,
          isEmailVerified: !user.isEmailVerified ? firebaseUser.emailVerified : false,
          isAcceptPrivacyPolicy : true,
          isAcceptTermsUse: true
        );
        try {
          var result = await NodeAuthService().updateUser(user.toFB(), user.uid);
          user = user.copyWith(
            apiToken: result['apiToken']
          );
        } catch (error) {
          if (debug) print(error);
        }
      }

      Permission.location.isGranted.then((result) async{
        if(result) {
          Position _position = await Geolocator.getCurrentPosition();
          GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: _position.latitude, geoLongitude: _position.longitude);
          SetGeoLocationData(geoLocationData);
          store.dispatch(updateUser(user.copyWith(
              id: 'firebase uid',
              fcmToken: _token,
              location: (user.location ?? LocationModel()).copyWith(
                coordinates: [_position.latitude, _position.longitude],
              ),
              uid: user.uid,
          )));
        }
      });
      

      store.dispatch(LogInSuccessful(
          firebaseUser: firebaseUser,
          appUser: user,
          userToken: googleAuth.accessToken,
          socialId: googleUser.id));
    } catch (error) {
      if (debug) print(error);
      store.dispatch(LogInFail(error));
    }
  };
}

ThunkAction<AppState> logInWithFacebook(String deviceType, String deviceId) {
  return (Store<AppState> store) async {
    try {
      final facebookLogin = FacebookLogin();
      if (await facebookLogin.isLoggedIn) await facebookLogin.logOut();
      final result = await facebookLogin.logIn(['email']);
      final facebookToken = result.accessToken.token;
      AuthCredential credential = FacebookAuthProvider.credential(facebookToken);
      var authResult = await firebaseAuth.signInWithCredential(credential);
      final User firebaseUser = firebaseAuth.currentUser;
      assert(authResult.user.uid == firebaseUser.uid);
      assert(firebaseUser.email != null);
      assert(firebaseUser.displayName != null);
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);
      var appUser = await NodeAuthService().requestEmailCheck(firebaseUser.email);
      UserModel user;
      String _token = await FirebaseMessaging.instance.getToken();
     
      if (appUser?.length == 0) {
        user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            username: fetchFirstName(firebaseUser.displayName),
            facebookId: result.accessToken.userId,
            isEmailVerified: firebaseUser.emailVerified,
            avatar: firebaseUser.photoURL,
            registerType: RegisterType.facebook,
            deviceType: enumHelper.str2enum(DeviceType.values, deviceType),
            deviceId: deviceId,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
            // location: _location,
            fcmToken: _token
        );
        try {
          var apiResult = await NodeAuthService().createSocialUser(user.toFB());
          user = user.copyWith(
              uid: apiResult['_id']
          );
          if(!firebaseUser.emailVerified) {
            try{
              await firebaseUser.sendEmailVerification();
              return firebaseUser.uid;
            }catch(e){
              print("An error occured while trying to send email        verification");
              print(e.message);
            }
          }
        } catch (error) {
          if (debug) print(error);
        }
      } else {
        user = UserModel.fromJson(appUser);
        user = user.copyWith(
          facebookId: result.accessToken.userId,
          fcmToken: _token,
          // location: _location,
          registerType: RegisterType.facebook,
          deviceType: enumHelper.str2enum(DeviceType.values, deviceType),
          deviceId: deviceId,
          isEmailVerified: !user.isEmailVerified ? firebaseUser.emailVerified : false,
          isAcceptPrivacyPolicy : true,
          isAcceptTermsUse: true
        );
        try {
          var result = await NodeAuthService().updateUser(user.toFB(), user.uid);
          user = user.copyWith(
              apiToken: result['apiToken']
          );
        } catch (error) {
          if (debug) print(error);
        }
      }

      Permission.location.isGranted.then((result) async{
        if(result) {
          Position _position = await Geolocator.getCurrentPosition();
          GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: _position.latitude, geoLongitude: _position.longitude);
          SetGeoLocationData(geoLocationData);
          store.dispatch(updateUser(user.copyWith(
              id: 'firebase uid',
              fcmToken: _token,
              location: (user.location ?? LocationModel()).copyWith(
                coordinates: [_position.latitude, _position.longitude],
              ),
              uid: user.uid,
          )));
        }
      });
      
      store.dispatch(LogInSuccessful(
          firebaseUser: firebaseUser,
          appUser: user,
          userToken: result.accessToken.token,
          socialId: result.accessToken.userId));
    } catch (error) {
      if (debug) print(error);
      store.dispatch(LogInFail(error));
    }
  };
}

class LogInSuccessful {
  final User firebaseUser;
  final UserModel appUser;
  final String userToken;
  final String socialId;

  LogInSuccessful(
      {@required this.firebaseUser,
      this.appUser,
      this.userToken,
      @required this.socialId});

  reducer(AppState appState) {
    if (debug) print("LogInSuccessful ${firebaseUser.toString()}");
    return appState.copyWith(user: appUser, userToken: userToken);
  }

  @override
  String toString() {
    return 'LogIn{user: $firebaseUser}';
  }
}

class LogInFail {
  final dynamic error;

  LogInFail(this.error);

  @override
  String toString() {
    return 'LogIn{There was an error loggin in: $error}';
  }
}

class LogOut {}

class LogOutSuccessful {
  LogOutSuccessful();

  @override
  String toString() {
    return 'LogOut{user: null}';
  }
}
