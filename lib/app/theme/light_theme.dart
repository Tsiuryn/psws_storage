import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData.light(useMaterial3: false).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      const AppColorsExt(
        textColor: Color(0xFF000000),
        appBarColor: Color(0xFFC0C0C0),
        bodyColor: Color(0xFFDADADA),
        cardColor: Color(0xFF6D6D6D),
        negativeActionColor: Color(0xFF9D0000),
        positiveActionColor: Color(0xFF002ABD),
        dividerColor: Color(0xFF8A8A8A),
      ),
      const AppTextStyleExt(
        subtitle: TextStyle(
          color: Color(0xFF000000),
          fontSize: AppDim.twelve,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF000000),
          fontSize: AppDim.fourteen,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF000000),
          fontSize: AppDim.twentyFour,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
    appBarTheme: const AppBarTheme(
      elevation: 5,
      backgroundColor: Color(0xFFC0C0C0),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFC0C0C0),
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF8A8A8A),
      space: 1,
      thickness: 1,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDim.eight)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF000000),
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDim.eight)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF002ABD),
          )),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // primary: const Color(0xFFE5E5E5),
        // onSurface: const Color(0xFFE5E5E5),
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
        // primary: const Color(0xFFE5E5E5),
        // onSurface: const Color(0xFFE5E5E5),
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
    backgroundColor: const Color(0xFFDADADA),
    scaffoldBackgroundColor: const Color(0xFFDADADA),
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
