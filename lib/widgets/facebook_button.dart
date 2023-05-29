import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/auth.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/global_export.dart';

class FacebookButton extends StatelessWidget {
  final Function onLoading;
  final Function onDone;
  final String deviceId;
  final String deviceType;

  FacebookButton({this.onDone, this.onLoading, this.deviceId, this.deviceType});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          Function dispatch = store.dispatch;
          return Container(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/facebook_icon.svg',
                      height: 20,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "CONTINUE WITH FACEBOOK",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              onPressed: () async{
                await onLoading();
                await dispatch(logInWithFacebook(deviceType, deviceId));
                onDone();
              },
              color: FACEBOOK_COLOR,
            ),
          );
        });
  }
}
