import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/auth.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/global_export.dart';

class GoogleButton extends StatelessWidget {
  final Function onLoading;
  final Function onDone;
  final String deviceType;
  final String deviceId;

  GoogleButton({@required this.onLoading, @required this.onDone, this.deviceType, this.deviceId});

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
                      'assets/google-icon.svg',
                      height: 20,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "CONTINUE WITH GMAIL",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: GOOGLE_COLOR),
                    )
                  ],
                ),
              ),
              onPressed: () async{
                await onLoading();
                await dispatch(logInWithGoogle(deviceType, deviceId));
                onDone();
              },
              color: Colors.white,
            ),
          );
        });
  }
}
