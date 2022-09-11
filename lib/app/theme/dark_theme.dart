import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      const AppColorsExt(
        textColor: Color(0xFFFFFFFF),
        appBarColor: Color(0xFF212121),
        bodyColor: Color(0xFF3C3B3B),
        cardColor: Color(0xFF858585),
        negativeActionColor: Color(0xFF9D0000),
        positiveActionColor: Color(0xFF002ABD),
        dividerColor: Color(0xFFBBB6B6),
      ),
      const AppTextStyleExt(
        subtitle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: AppDim.twelve,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: AppDim.fourteen,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: AppDim.twentyFour,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
    appBarTheme: const AppBarTheme(
      elevation: 5,
      backgroundColor: Color(0xFF212121),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF212121),
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDim.eight)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFFFFFFF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDim.eight)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFFFFFFF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDim.eight)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFF002ABD),
        ),
      ),
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
    dividerTheme: const DividerThemeData(
      color: Color(0xFFBBB6B6),
      space: 1,
      thickness: 1,
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
    backgroundColor: const Color(0xFF3C3B3B),
    scaffoldBackgroundColor: const Color(0xFF3C3B3B),
    primaryColor: const Color(0xFF212325),
    unselectedWidgetColor: const Color(0xFF6C6D70),
    primaryColorLight: const Color(0xFF262F40),
    primaryColorDark: const Color(0xFFFFFFFF),
    indicatorColor: const Color(0xFFC4C4C4),
    hintColor: const Color(0xFF91969E),
  );
}
