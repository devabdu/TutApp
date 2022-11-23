import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tut_app/presentation/resources/language_manager.dart';

const String prefsKeyLang = "PREFS_KEY_LANGUAGE";
const String prefsKeyOnBoardingScreenViewed =
    "PREFS_KEY_OnBOARDING_SCREEN_VIEWED";
const String prefsKeyIsUserLoggedIn = "PREFS_KEY_IS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.english.getValue());
    } else {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      return arabicLocal;
    } else {
      return englishLocal;
    }
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreenViewed, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreenViewed) ?? false;
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(prefsKeyIsUserLoggedIn);
  }
}
