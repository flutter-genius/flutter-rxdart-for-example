import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/login_gender_selecter.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:intl/intl.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';

import 'package:device_info/device_info.dart';
import 'dart:io';

class CreateEmailAccountScreen extends StatefulWidget {
  final String email;

  CreateEmailAccountScreen({@required this.email});

  @override
  _CreateEmailAccountScreenState createState() =>
      _CreateEmailAccountScreenState();
}

class _CreateEmailAccountScreenState extends State<CreateEmailAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState _buttonStatus = ButtonState.normal;

  final dateFormat = DateFormat("dd.MMM.yyyy");
  String password;
  String _username;
  DateTime _birthday;
  String _gender;
  String identifier;
  String deviceType;
  TextEditingController _usernameController, _passwordController;

  _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceType = "android";
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceType = "ios";
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailController.text = widget.email;
    });
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
    _getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          var user = state.user;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Complete profile",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: TITLE_TEXT_COLOR
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Text(
                            LocaleKeys.create_account_email.tr(),
                            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
                          ),
                        ),
                        HittapaOutline(
                          height: 48,
                          round: 10,
                          child: TextField(
                            controller: _emailController,
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontSize: 15,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            autofocus: true,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Text(
                            LocaleKeys.create_account_password.tr(),
                            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
                          ),
                        ),
                        HittapaOutline(
                          height: 48,
                          round: 10,
                          child: TextFormField(
                            onSaved: (value) {
                              password = value;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(
                                fontSize: 15,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0)),
                            validator: validatePassword,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Text(
                            LocaleKeys.create_account_first_name.tr(),
                            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
                          ),
                        ),
                        HittapaOutline(
                          height: 48,
                          round: 10,
                          child: TextFormField(
                            controller: _usernameController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => _username = value,
                            style: TextStyle(
                                fontSize: 15,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            autofocus: true,
                            validator: validateName,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Text(
                            LocaleKeys.create_account_date_of_birth.tr(),
                            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
                          ),
                        ),
                        HittapaOutline(
                          round: 10,
                          height: 48,
                          child: InkWell(
                            onTap: () {
                              navigateToBirthDayScreen(context, _birthday)
                                .then((data) {
                                  if (data != null) {
                                    setState(() {
                                      _birthday = data;
                                    });
                                  }
                              });                        
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _birthday != null ? dateFormat.format(_birthday) : "",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/calendar-outline.svg',
                                  ),
                                ],
                              )
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  AuthGenderSelector(
                    onTaped: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    selected: _gender ?? ' ',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          child: ProgressButton(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: HittapaRoundButton(
                                    text: "CONFIRM REGISTRATION",
                                    isGoogleColor: true,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () => onCreateAccount(dispatch),
                            backgroundColor: Colors.transparent,
                            buttonState: _buttonStatus,
                            progressColor: GRADIENT_COLOR_ONE,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),              
          );
        });
  }

  // request SignUp function
  onCreateAccount(Function dispatch) async {

    if (_usernameController.text == null || _usernameController.text == "") {
      hittaPaToast(LocaleKeys.toast_input_first_name.tr(), 1);
      return;
    }

    if (_passwordController.text == null || _passwordController.text == "") {
      hittaPaToast(LocaleKeys.toast_input_password.tr(), 1);
      return;
    }

    if (_gender == null) {
      hittaPaToast(LocaleKeys.toast_select_gender.tr(), 1);
      return;
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      try {
        await dispatch(createUserAccount(
            UserModel(
              email: widget.email,
              birthday: _birthday,
              username: _username,
              password: password,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
              gender: enumHelper.str2enum(GenderType.values, _gender,),
              deviceType: enumHelper.str2enum(DeviceType.values, deviceType),
              deviceId: identifier,
              registerType: RegisterType.email,
              isAcceptTermsUse: false,
              isAcceptPrivacyPolicy: false,
            )));
        navigateToPreviewProfileScreen(context);
      } catch (err) {
        print(err.toString());
        hittaPaToast(LocaleKeys.toast_signup_failed.tr(), 1);
      }
      setState(() {
        _buttonStatus = ButtonState.normal;
      });
    } else {
      hittaPaToast(LocaleKeys.toast_select_your_birthday.tr(), 1);
      return;
    }
  }
}
