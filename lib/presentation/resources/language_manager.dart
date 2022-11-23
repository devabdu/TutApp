import 'package:flutter/material.dart';

enum LanguageType {
  english,
  arabic,
}

const String english = "en";
const String arabic = "ar";

const String assetPathLocalization = "assets/translations";

const Locale englishLocal = Locale( "en", "US");
const Locale arabicLocal = Locale("ar", "SA");

extension LanguageTypeExtension on LanguageType{
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return english;
      case LanguageType.arabic:
        return arabic;
    }
  }
}