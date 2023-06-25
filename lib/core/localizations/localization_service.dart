import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LocalizationService {
  static const localeAssetsPath = 'assets/locale';
  static const fallbackLocale = Locale('en', 'US');
  static const startLocale = Locale('en', 'US');

  static const supportedLocale = <Locale>[
    Locale('en', 'US'),
  ];

  Locale _currentLocale = startLocale;
  Locale get currentLocale => _currentLocale;
  void setCurrentLocale(Locale locale) {
    if (locale != _currentLocale) {
      _currentLocale = locale;
    }
  }
}
