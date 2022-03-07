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
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      headline4: TextStyle(
        fontSize: 28,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      overline: TextStyle(
        fontSize: 10,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      caption: TextStyle(
        fontSize: 12,
        height: 1.5,
        color: Color(0xFF14181F),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
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
        backgroundColor: const Color(0xFF286EEB),
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
