import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config.dart';

class HittapaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'HittaPå',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 27,
              decoration: TextDecoration.none,
              fontFamily: appTheme.fontFamily2),
        ),
        SizedBox(
          width: 15,
        ),
        SvgPicture.asset(
          'assets/hittapa_logo.svg',
          height: 22,
          width: 18,
        )
      ],
    ));
  }
}
