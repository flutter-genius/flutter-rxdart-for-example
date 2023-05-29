import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';

class HittapaRoundGradientButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color startColor;
  final Color endColor;
  final bool isDisable;
  final bool isLogo;

  HittapaRoundGradientButton({this.onClick, this.text, this.startColor, this.endColor, this.isDisable = false, this.isLogo = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: isDisable ? [NAVIGATION_NORMAL_COLOR, NAVIGATION_NORMAL_COLOR] : [startColor, endColor]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLogo
                ? Container(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset('assets/hittapa_logo.svg', color: BACKGROUND_COLOR, height: 26),
                  )
                : Container(),
            Text(
              text,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        onPressed: isDisable ? null : onClick,
      ),
    );
  }
}
