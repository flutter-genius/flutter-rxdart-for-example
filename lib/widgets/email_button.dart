import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

class EmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          // gradient: LinearGradient(colors: [NAVIGATION_NORMAL_TEXT_COLOR, NAVIGATION_NORMAL_TEXT_COLOR]),
          borderRadius: BorderRadius.circular(24),
          color: BLACK_COLOR,
      ),
      child: FlatButton(
        child: Text(
          LocaleKeys.hittapa_sign_signup_or_signin.tr().toUpperCase(),
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: () => navigateToEmailCheckScreen(context),
      ),
    );
  }
}
