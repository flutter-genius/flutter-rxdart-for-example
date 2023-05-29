import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class BankButton extends StatelessWidget {
  final bool isActive;
  BankButton({this.isActive=false});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(colors: [BORDER_COLOR, GOOGLE_COLOR]) : LinearGradient(colors: [NAVIGATION_NORMAL_COLOR, NAVIGATION_NORMAL_COLOR]),
          borderRadius: BorderRadius.circular(24)),
      child: FlatButton(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/bank-id-logo.svg',
              height: 27,
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              LocaleKeys.account_confirm_with_bankid.tr(),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
        onPressed: () {},
      ),
    );
  }
}
