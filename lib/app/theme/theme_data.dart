import 'package:flutter/material.dart';

//rename
CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static const bool _isDarkTheme = false;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  //TODO: chose theme
  void toggleTheme() {
    notifyListeners();
  }
}
