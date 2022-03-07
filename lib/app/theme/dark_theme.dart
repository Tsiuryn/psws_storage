import 'package:flutter/material.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: Theme.of(context).textTheme.headline6,
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
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      headline4: TextStyle(
        fontSize: 28,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      overline: TextStyle(
        fontSize: 10,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFFF2F3F5),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      caption: TextStyle(
        fontSize: 12,
        height: 1.5,
        color: Color(0xFFF2F3F5),
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
        primary: const Color(0xFF212325),
        onSurface: const Color(0xFF212325),
        backgroundColor: const Color(0xFF538BEF),
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
    ),
    backgroundColor: const Color(0xFF303847),
    primaryColor: const Color(0xFF212325),
    unselectedWidgetColor: const Color(0xFF6C6D70),
    primaryColorLight: const Color(0xFF262F40),
    primaryColorDark: const Color(0xFFF2F3F5),
    indicatorColor: const Color(0xFFC4C4C4),
    hintColor: const Color(0xFF91969E),
    iconTheme: const IconThemeData(
      color: Color(0xFFC4C4C4),
    ),
  );
}
