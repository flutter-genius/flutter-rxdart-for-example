import 'package:flutter/foundation.dart';
import 'package:hittapa/theme.dart';
import 'package:hittapa/utils/language.dart';

import 'models/user.dart';

const appTitle = 'HittaPå';

AppTheme appTheme = AppTheme();

const bool debug = kDebugMode;

const CACHE_MODEL_VERSION = 1;

const MINIMAL_USER_AGE = 17;

const DEFAULT_USER_GENDER = GenderType.non_binary;

class NotImplementedYet extends Error {}

class MapConfig{
  static String googleMapKey = 'AIzaSyCjpgBMTPJhCEw6Yi0kP_8ECx4LMR0ZbCc';
  static String language = 'se';
  static String countryCode = 'SE';
  static String type = '(regions)';
  static String kGoogleApiKey = "AIzaSyBE-5QgYsnFaBUSUR8LL7f-IETuPc29frs";
}

final Language defaultLanguage = Language(languageCode: 'en', countryCode: 'US', name: 'English US');

final List<Language> hittaPaSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'se', countryCode: 'SE', name: 'Swedish'),
    Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
    Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
    Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
    Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
    Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
    Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
    Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
    Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
    Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
    Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
];


