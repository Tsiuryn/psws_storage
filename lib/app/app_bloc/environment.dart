import 'package:flutter/material.dart';

class Environment {
  final String id;
  final ThemeMode themeType;

  Environment({required this.id, required this.themeType});

  Environment.empty()
      : id = '',
        themeType = ThemeMode.dark;

  Environment copyWith({
    String? id,
    ThemeMode? themeType,
  }) {
    return Environment(
      id: id ?? this.id,
      themeType: themeType ?? this.themeType
    );
  }
}

enum ThemeType { light, dark }
