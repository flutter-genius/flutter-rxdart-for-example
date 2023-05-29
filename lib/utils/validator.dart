import 'package:hittapa/global_export.dart';

String validateEmail(String value) {
  if (value.isEmpty) return LocaleKeys.validate_email.tr();
  final RegExp nameExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (!nameExp.hasMatch(value)) return LocaleKeys.validate_email_invalid.tr();
  return null;
}

String validateName(String value) {
  if (value.isEmpty) return LocaleKeys.validate_name.tr();
  final RegExp nameExp = RegExp(r'^[A-za-z ]+$');
  if (!nameExp.hasMatch(value))
    return LocaleKeys.validate_name_invalid.tr();
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) return LocaleKeys.validate_password.tr();
  if (value.length < 6)
    return LocaleKeys.validate_password_invalid.tr();
  return null;
}

String validateCode(String code) {
  if (code.isEmpty) return LocaleKeys.validate_code.tr();
  return null;
}

String validateBirthDay(DateTime date) {
  if (date == null) return LocaleKeys.validate_birthday.tr();
  if (date.year + 10 > DateTime.now().year)
    return LocaleKeys.validate_age.tr();
  return null;
}

String validateRequired(String value) {
  if (value.isEmpty) return LocaleKeys.validate_empty.tr();
  return null;
}

String validateUrl(String value) {
  bool _validURL = Uri.parse(value).isAbsolute;
  if (value.isEmpty) {
    return LocaleKeys.validate_url.tr();
  } else if (_validURL) {
    return LocaleKeys.validate_url_invalid.tr();
  }
  return null;
}
