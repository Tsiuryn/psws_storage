import 'package:flutter/material.dart';

class Environment {
  final String id;
  final ThemeMode themeType;
  final AppLocale appLocale;

  Environment(
      {required this.id, required this.themeType, required this.appLocale});

  Environment.empty()
      : id = '',
        appLocale = AppLocale.ru,
        themeType = ThemeMode.dark;

  Environment copyWith({
    String? id,
    ThemeMode? themeType,
    AppLocale? appLocale,
  }) {
    return Environment(
      id: id ?? this.id,
      themeType: themeType ?? this.themeType,
      appLocale: appLocale ?? this.appLocale,
    );
  }
}

enum ThemeType { light, dark }

enum AppLocale { ru, en }
