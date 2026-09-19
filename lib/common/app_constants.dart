import 'dart:io';

import '../db/app_database.dart';
import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'Drivo Driver';
  static const String baseUrl = 'https://drivo.org.in/';
  static String firbaseApiKey = (Platform.isAndroid)
      ? "AIzaSyD5DjsmqCfntRL_kmPuBwsYIvk6I70sewg"
      : "ios firebase api key";
  static String firebaseAppId = (Platform.isAndroid)
      ? "1:417891932059:android:7d4cfbc1f40e1fb518333e"
      : "ios firebase app id";
  static String firebasemessagingSenderId = (Platform.isAndroid)
      ? "417891932059"
      : "ios firebase sender id";
  static String firebaseProjectId = (Platform.isAndroid)
      ? "drivo-bec2e"
      : "ios firebase project id";

  static String mapKey = (Platform.isAndroid)
      ? 'AIzaSyA_usa-2matJnaEuxFvNag8qhXL51w4vJM'
      : 'ios map key';

  static const String stripPublishKey = '';

  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    LocaleLanguageList(name: 'Azerbaijani', lang: 'az'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es'),
    LocaleLanguageList(name: 'Albanian', lang: 'sq'),
    LocaleLanguageList(name: 'Vietnamese', lang: 'vi'),
  ];
  static String packageName = '';
  static String signKey = '';
}

bool showBubbleIcon = false;
bool subscriptionSkip = false;
String choosenLanguage = 'en';
String mapType = '';
bool isAppMapChange = false;

AppDatabase db = AppDatabase();
