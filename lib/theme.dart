import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme() {
    // COLORS
  }

  // COLORS
  static const Color textColor = Color(0xff000000);
  static const Color backgroundColor = Color(0xffeeeeee);
  static const Color whiteBackgroundColor = Color(0xffffffff);
  static const FACEBOOK_COLOR = Color(0xFF3B5998);
  static const GOOGLE_COLOR = Color(0xFF657795);
  static const GRADIENT_COLOR_ONE = Color(0xFFFF3001);
  static const GRADIENT_COLOR_TWO = Color(0xFFFF6500);
  static const GRAY_COLOR = Color(0xFFDDDDDD);
  static const BORDER_COLOR = Color(0xFF657795);
  static const HINT_COLOR = Color(0x64657795);
  static const DART_TEXT_COLOR = Color(0xFF2B2B2B);
  static const TITLE_TEXT_COLOR = Color(0xFF393939);
  static const CIRCLE_AVATAR_COLOR = Color(0xFFD8D8D8);
  static const NAVIGATION_ACTIVE_COLOR = Color(0xFF88898D);
  static const NAVIGATION_NORMAL_COLOR = Color(0xFFB4B5B7);
  static const NAVIGATION_NORMAL_TEXT_COLOR = Color(0xFF1F1F1F);
  static const BACKGROUND_COLOR = Color(0xFFF9FAFC);
  static const SEPARATOR_COLOR = Color(0xFF979797);
  static const SHADOW_COLOR = Color(0xFF979797);
  static const CARD_BORDER_COLOR = Color(0xFFC8CFD9);
  static const CARD_BACKGROUND_COLOR = Color(0xFFF4F5F7);
  static const CHECKED_COLOR = Color(0xFF02BC5C);
  static const REMINDER_COLOR = Color(0xFFFF3201);
  static const UNREAD_COLOR = Color(0x33FF3201);
  static const PRIMARY_COLOR = Color(0xFF007AFF);
  static const MESSAGE_BACKGROUND_COLOR = Color(0xFFF7F7F7);
  static const SEPARATOR2_COLOR = Color(0xFFEAECF3);
  static const PENDING_COLOR = Color(0xFFE7DE6C);
  static const LOCATION_LABEL_COLOR = Color(0xFF5872DB);
  static const EVENT_BACKGROUND_COLOR = Color(0xFFECF5FC);
  static const LOCATION_LABEL_BACKGROUND_COLOR = Color(0xFFBBBBBB); // FONTS
  final String fontFamily1 = 'SF-Pro-Text';
  final String fontFamily2 = 'SF-Pro-Display';
}

MaterialColor getMaterialColor(int color) {
  Color c = Color(color);
  Map<int, Color> swatch = {
    50: c.withOpacity(.1),
    100: c.withOpacity(.2),
    200: c.withOpacity(.3),
    300: c.withOpacity(.4),
    400: c.withOpacity(.5),
    500: c.withOpacity(.6),
    600: c.withOpacity(.7),
    700: c.withOpacity(.8),
    800: c.withOpacity(.9),
    900: c.withOpacity(1),
  };
  return MaterialColor(color, swatch);
}
