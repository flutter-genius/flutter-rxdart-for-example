import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:shimmer/shimmer.dart';

class HittapaRoundButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final bool isNormal;
  final bool isOutline;
  final bool isPopUp;
  final bool isGoogleColor;
  final bool isGreenColor;
  final bool isDisable;
  final bool isLoading;

  HittapaRoundButton(
      {this.onClick, this.text, this.isNormal = false, this.isOutline = false, this.isPopUp = false, this.isGoogleColor = false, this.isGreenColor=false, this.isDisable=false, this.isLoading=false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: GRADIENT_COLOR_TWO,
        highlightColor: GRAY_COLOR,
        child: Container(
          height: 48,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isDisable ? [NAVIGATION_NORMAL_COLOR, NAVIGATION_NORMAL_COLOR] :  isGreenColor ? [CHECKED_COLOR, CHECKED_COLOR]
                      : isGoogleColor ? [GOOGLE_COLOR, BORDER_COLOR]
                      : isNormal
                      ? isPopUp ? [Colors.transparent, Colors.transparent]
                      : [CARD_BACKGROUND_COLOR, CARD_BACKGROUND_COLOR]
                      : [GRADIENT_COLOR_ONE, GRADIENT_COLOR_TWO]),
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: isOutline ? GRADIENT_COLOR_ONE : isPopUp ? Colors.transparent : CARD_BACKGROUND_COLOR)),
          child: FlatButton(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: isPopUp ? 18 : 13,
                  fontWeight: FontWeight.w600,
                  color: isNormal
                      ? (isOutline ? GRADIENT_COLOR_ONE : isPopUp ? Colors.white : BORDER_COLOR)
                      : Colors.white),
            ),
            onPressed: null,
          ),
        ),
      );
    }
    return Container(
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isDisable ? [NAVIGATION_NORMAL_COLOR, NAVIGATION_NORMAL_COLOR] :  isGreenColor ? [CHECKED_COLOR, CHECKED_COLOR]
                  : isGoogleColor ? [GOOGLE_COLOR, BORDER_COLOR]
                  : isNormal
                  ? isPopUp ? [Colors.transparent, Colors.transparent]
                  : [CARD_BACKGROUND_COLOR, CARD_BACKGROUND_COLOR]
                  : [GRADIENT_COLOR_ONE, GRADIENT_COLOR_TWO]),
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: isOutline ? GRADIENT_COLOR_ONE : isPopUp ? Colors.transparent : CARD_BACKGROUND_COLOR)),
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(
              fontSize: isPopUp ? 18 : 13,
              fontWeight: FontWeight.w600,
              color: isNormal
                  ? (isOutline ? GRADIENT_COLOR_ONE : isPopUp ? Colors.white : BORDER_COLOR)
                  : Colors.white),
        ),
        onPressed: isDisable ? null : onClick,
      ),
    );
  }
}
