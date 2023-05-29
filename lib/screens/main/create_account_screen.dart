import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/widgets/email_button.dart';
import 'package:hittapa/widgets/facebook_button.dart';
import 'package:hittapa/widgets/google_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global_export.dart';

import 'package:device_info/device_info.dart';
import 'dart:io';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isLoading = false;
  String identifier;
  String deviceType;

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
      setState(() {});
    } catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/main_screen.jpeg'),
                fit: BoxFit.fitHeight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[          
              Container(
                padding: EdgeInsets.only(top: 70),
                child: SvgPicture.asset(
                  'assets/svg/hittapa_logo.svg',
                  height: MediaQuery.of(context).size.width * 0.45,
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Text(
                        "Welcom to HittaPå! Create/join fun activities\n around you free of charge",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 260,
                      margin: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                      child: FacebookButton(
                        deviceId: identifier,
                        deviceType: deviceType,
                        onDone: () {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onLoading: () {
                          setState(() {
                            isLoading = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 260,
                      margin: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                      child: GoogleButton(
                        deviceId: identifier,
                        deviceType: deviceType,
                        onDone: () {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onLoading: () {
                          setState(() {
                            isLoading = true;
                          });
                        },
                      )
                    ),
                    Container(
                      height: 48,
                      width: 260,
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      child: EmailButton()
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 14, right: 14, bottom: 40),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: LocaleKeys.hittapa_sign_by_clicking_continue.tr() + " ",
                            style: TextStyle(color: GRAY_COLOR, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: LocaleKeys.global_terms_of_use.tr(),
                                  style:
                                      TextStyle(decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        await launchURL('hittapa.com/terms');
                                      }
                                  ),
                              TextSpan(
                                text: ' ' + LocaleKeys.hittapa_sign_and_acknowledging.tr() + ' ',
                              ),
                              TextSpan(
                                  text: LocaleKeys.global_privacy_policy.tr(),
                                  style:
                                      TextStyle(decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        await launchURL('hittapa.com/privacy');
                                      }
                                  ),
                              TextSpan(
                                text: ' and\n our',
                              ),
                              TextSpan(
                                  text: "Cookies policy.",
                                  style:
                                      TextStyle(decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        await launchURL('hittapa.com/privacy');
                                      }
                                  ),
                            ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
