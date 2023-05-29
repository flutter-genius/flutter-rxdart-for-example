import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../global.dart';
import 'package:hittapa/global_export.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrow-back.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.global_privacy_policy.tr(),
          style: TextStyle(
              color: TITLE_TEXT_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 21),
        ),
        centerTitle: true,
      ),
    );
  }
}
