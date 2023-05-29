import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hittapa/actions/auth.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/location.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/store_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_header.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/screens/main/create_account_screen.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/models/models.dart';

import 'dart:io';
import 'package:device_info/device_info.dart';

class LoginScreen extends StatefulWidget {
  final String email;

  LoginScreen({@required this.email});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState _buttonStatus = ButtonState.normal;
  String password = '';

  String identifier;
  String deviceType;

  _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceType = "android";
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceType = "ios";
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _getDeviceInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          Function dispatch = store.dispatch;

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: HittapaHeader(),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: SvgPicture.asset('assets/arrow-back.svg'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  SizedBox(
                    width: 55,
                  )
                ],
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: HittapaOutline(
                        child: TextField(
                          controller: _emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 15, color: BORDER_COLOR),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                            labelText: LocaleKeys.login_email.tr(),
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: HittapaOutline(
                        child: TextFormField(
                          onSaved: (value) => this.password = value,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(fontSize: 15, color: BORDER_COLOR),
                          decoration: InputDecoration(
                              hintText: LocaleKeys.login_password.tr(),
                              hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              labelText: LocaleKeys.login_password.tr()),
                          validator: validatePassword,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                        child: InkWell(
                            onTap: () => navigateToForgotPasswordScreen(context, widget.email),
                            child: Text(
                              LocaleKeys.login_forgot_password.tr(),
                              style: TextStyle(color: GOOGLE_COLOR, fontSize: 13),
                            ))),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: ProgressButton(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: HittapaRoundButton(
                                      text: LocaleKeys.login_login.tr().toUpperCase(),
                                      isGoogleColor: true,
                                      //                              onClick: () => onLogin(),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => onLogin(dispatch),
                              backgroundColor: Colors.transparent,
                              buttonState: _buttonStatus,
                              progressColor: GRADIENT_COLOR_ONE,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ));
        });
  }

  // login request with email and password
  onLogin(Function dispatch) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      var result = await NodeAuthService().login(widget.email, password, deviceType, identifier);
      if (result == null || !result['status']) {
        hittaPaToast(result == null || result['data'] == null ? 'Login is failed!' : result['data'], 1);
      } else {
        String _token = await FirebaseMessaging.instance.getToken();
        UserModel _user = UserModel.fromJson(result['data']);
        Permission.location.isGranted.then((result) async {
          if (result) {
            Position _position = await Geolocator.getCurrentPosition();
            GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: _position.latitude, geoLongitude: _position.longitude);
            SetGeoLocationData(geoLocationData);
            dispatch(updateUser(_user.copyWith(
                id: 'firebase uid',
                fcmToken: _token,
                location: (_user?.location ?? LocationModel()).copyWith(
                  coordinates: [_position.latitude, _position.longitude],
                ),
                uid: _user?.uid,
                isAcceptPrivacyPolicy: true,
                isAcceptTermsUse: true)));
          } else {
            dispatch(updateUser(_user.copyWith(
                // id: user.uid,
                id: 'firebase uid',
                fcmToken: _token,
                uid: _user.uid,
                isAcceptPrivacyPolicy: true,
                isAcceptTermsUse: true)));
          }
        });
        User user;
        dispatch(LogInSuccessful(firebaseUser: user, appUser: _user, userToken: "firebase uid", socialId: ''));
        saveToken('firebase uid');
        if (_user?.avatar != null) navigateToPreviewProfileScreen(context);
        navigateToDashboardScreen(context, _user);
      }
      setState(() {
        _buttonStatus = ButtonState.normal;
      });
    }
  }
}
