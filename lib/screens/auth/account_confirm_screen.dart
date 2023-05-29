import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/screens/main/mainScreen.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/widgets/BankButton.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hittapa/global_export.dart';
import 'package:flutter/gestures.dart';
import 'package:hittapa/actions/actions.dart';

class AccountConfirmationScreen extends StatefulWidget {
  @override
  _AccountConfirmationScreenState createState() => _AccountConfirmationScreenState();
}

class _AccountConfirmationScreenState extends State<AccountConfirmationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (context, store) {
        var user = store.state.user;
        Function dispatch = store.dispatch;
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 28, bottom: 35, right: 14, left: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(27)),
                ),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.account_confirm_you_have.tr(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    user.isAcceptPrivacyPolicy != null && user.isAcceptPrivacyPolicy && user.isAcceptTermsUse
                        ? Container(
                            margin: EdgeInsets.only(top: 15, left: 14, right: 14, bottom: 40),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "For HittaPå to be a safe place for activities you most agreeing to the" + " ",
                                  style: TextStyle(color: GRAY_COLOR, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: LocaleKeys.global_terms_of_use.tr(),
                                        style: TextStyle(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await launchURL('hittapa.com/terms');
                                          }),
                                    TextSpan(
                                      text: ' ' + LocaleKeys.hittapa_sign_and_acknowledging.tr() + ' ',
                                    ),
                                    TextSpan(
                                        text: LocaleKeys.global_privacy_policy.tr(),
                                        style: TextStyle(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await launchURL('hittapa.com/privacy');
                                          }),
                                    TextSpan(
                                      text: ' and\n our',
                                    ),
                                    TextSpan(
                                        text: "Cookies policy.",
                                        style: TextStyle(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await launchURL('hittapa.com/privacy');
                                          }),
                                  ]),
                            ),
                          )
                        : SizedBox(
                            height: 50,
                          ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Accept terms use",
                            style: TextStyle(color: BACKGROUND_COLOR, fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                            height: 30,
                            child: CupertinoSwitch(
                              value: user?.isAcceptTermsUse ?? false,
                              onChanged: (v) {
                                dispatch(updateUser(user.copyWith(isAcceptTermsUse: v)));
                              },
                              trackColor: GRAY_COLOR,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Accept privacy policy",
                            style: TextStyle(color: BACKGROUND_COLOR, fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                            height: 30,
                            child: CupertinoSwitch(
                              value: user?.isAcceptPrivacyPolicy ?? false,
                              onChanged: (v) {
                                dispatch(updateUser(user.copyWith(isAcceptPrivacyPolicy: v)));
                              },
                              trackColor: GRAY_COLOR,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        LocaleKeys.account_confirm_use_bank.tr(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/bankid.svg",
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: BankButton(
                        isActive: user != null && user.isAcceptPrivacyPolicy != null && user.isAcceptPrivacyPolicy && user.isAcceptTermsUse ? true : false,
                      ),
                    ),
                    Container(
                      child: Text(
                        LocaleKeys.account_confirm_or.tr(),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: HittapaRoundButton(
                                isLoading: _isLoading,
                                onClick: () async {
                                  if (_isLoading) return;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (user.isAcceptPrivacyPolicy && user.isAcceptTermsUse) {
                                    bool _allow = await Permission.location.isGranted;
                                    if (!_allow) {
                                      var result = await Permission.location.request();
                                      if (result != PermissionStatus.granted) {
                                        hittaPaToast(LocaleKeys.toast_hittapa_want.tr(), 1);
                                        Timer(Duration(seconds: 1), () {
                                          openAppSettings();
                                        });
                                      } else {
                                        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async {
                                          Position _position = await Geolocator.getCurrentPosition();
                                          final coordinates = Coordinates(_position.latitude, _position.longitude);
                                          GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: _position.latitude, geoLongitude: _position.longitude);
                                          SetGeoLocationData(geoLocationData);
                                          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                                          Address selectedAddress = addresses.first;
                                          LocationModel _location = LocationModel(
                                            coordinates: [_position.latitude, _position.longitude],
                                            city: selectedAddress.locality,
                                            address: selectedAddress.addressLine,
                                            country: selectedAddress.countryName,
                                            state: selectedAddress.adminArea,
                                            street: selectedAddress.thoroughfare ?? selectedAddress.subAdminArea,
                                            postCode: selectedAddress.postalCode,
                                          );
                                          UserModel _user = user.copyWith(
                                            location: _location,
                                          );
                                          dispatch(UpdateUser(_user));
                                          await NodeAuthService().updateUser(user.toFB(), user.uid);
                                          Map<String, dynamic> _data = {'email': user.email};
                                          isCreatAccount = false;
                                          NodeService().sendMessage(_data);
                                          navigateToDashboardScreen(context, user);
                                          // Navigator.pushReplacementNamed(
                                          //     context, Routes.MAIN
                                          // );
                                        });
                                      }
                                    } else {
                                      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async {
                                        Position _position = await Geolocator.getCurrentPosition();
                                        final coordinates = Coordinates(_position.latitude, _position.longitude);
                                        GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: _position.latitude, geoLongitude: _position.longitude);
                                        SetGeoLocationData(geoLocationData);
                                        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                                        Address selectedAddress = addresses.first;
                                        LocationModel _location = LocationModel(
                                          coordinates: [_position.latitude, _position.longitude],
                                          city: selectedAddress.locality,
                                          address: selectedAddress.addressLine,
                                          country: selectedAddress.countryName,
                                          state: selectedAddress.adminArea,
                                          street: selectedAddress.thoroughfare ?? selectedAddress.subAdminArea,
                                          postCode: selectedAddress.postalCode,
                                        );
                                        UserModel _user = user.copyWith(
                                          location: _location,
                                        );
                                        dispatch(UpdateUser(_user));
                                        await NodeAuthService().updateUser(user.toFB(), user.uid);
                                        Map<String, dynamic> _data = {'email': user.email};
                                        isCreatAccount = false;
                                        NodeService().sendMessage(_data);
                                        navigateToDashboardScreen(context, user);
                                        // Navigator.pushReplacementNamed(
                                        //     context, Routes.MAIN
                                        // );
                                      });
                                    }
                                  }
                                },
                                text: LocaleKeys.account_confirm_without_bankid.tr(),
                                isGoogleColor: false,
                                isPopUp: true,
                                isDisable: user.isAcceptPrivacyPolicy != null && user.isAcceptPrivacyPolicy && user.isAcceptTermsUse ? false : true),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
