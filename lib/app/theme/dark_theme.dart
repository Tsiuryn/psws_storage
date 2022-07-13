import 'package:flutter/material.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      elevation: 5,
      backgroundColor: Colors.black54,
      titleTextStyle: Theme.of(context).textTheme.headline6,
    ),
    iconTheme: const IconThemeData(
      size: 24.0,
      color: Colors.yellow,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Color(0xFF91969E),
      selectedItemColor: Color(0xFFF2F3F5),
      elevation: 0,
      showUnselectedLabels: true,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        primary: const Color(0xFF212325),
        onSurface: const Color(0xFF212325),
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
        primary: const Color(0xFF212325),
        onSurface: const Color(0xFF212325),
        backgroundColor: const Color(0xFF538BEF),
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: const Color(0xFF538BEF),
        primary: const Color(0xFF3C71CD),
        onPrimary: const Color(0xFF8B8E94),
        onSecondary: const Color(0xFF101112),
        onBackground: const Color(0xFF212325),
        surface: Colors.red),
    backgroundColor: const Color(0xFF303847),
    primaryColor: const Color(0xFF212325),
    unselectedWidgetColor: const Color(0xFF6C6D70),
    primaryColorLight: const Color(0xFF262F40),
    primaryColorDark: const Color(0xFFFFFFFF),
    indicatorColor: const Color(0xFFC4C4C4),
    hintColor: const Color(0xFF91969E),
  );
}
