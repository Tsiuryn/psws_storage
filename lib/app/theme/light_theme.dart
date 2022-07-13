import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: Theme.of(context).textTheme.headline6,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Color(0xFF91969E),
      selectedItemColor: Color(0xFF14181F),
      elevation: 0,
      showUnselectedLabels: true,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        primary: const Color(0xFFE5E5E5),
        onSurface: const Color(0xFFE5E5E5),
        backgroundColor: Colors.transparent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        primary: const Color(0xFFE5E5E5),
        onSurface: const Color(0xFFE5E5E5),
        backgroundColor: const Color(0xFF286EEB),
      ),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      secondary: const Color(0xFF286EEB),
      primary: const Color(0xFF1D5CCA),
      onPrimary: const Color(0xFF6F7276),
      onSecondary: const Color(0xFFF5F6F7),
      onBackground: const Color(0xFFFFFFFF),
    ),
    backgroundColor: const Color(0xFFEDEFF2),
    primaryColor: const Color(0xFFE5E5E5),
    unselectedWidgetColor: const Color(0xFF91969E),
    primaryColorLight: const Color(0xFFEDF2FA),
    primaryColorDark: const Color(0xFF14181F),
    indicatorColor: const Color(0xFF48505E),
    hintColor: const Color(0xFF91969E),
    iconTheme: const IconThemeData(
      color: Color(0xFF48505E),
    ),
  );
}
