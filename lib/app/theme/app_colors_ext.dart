import 'package:flutter/material.dart';

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.textColor,
    required this.appBarColor,
    required this.bodyColor,
    required this.cardColor,
    required this.negativeActionColor,
    required this.positiveActionColor,
    required this.dividerColor,
  });

  final Color? textColor;
  final Color? appBarColor;
  final Color? bodyColor;
  final Color? cardColor;
  final Color? negativeActionColor;
  final Color? positiveActionColor;
  final Color? dividerColor;

  @override
  AppColorsExt copyWith({
    Color? textColor,
    Color? appBarColor,
    Color? bodyColor,
    Color? cardColor,
    Color? negativeActionColor,
    Color? positiveActionColor,
    Color? dividerColor,
  }) {
    return AppColorsExt(
      textColor: textColor ?? this.textColor,
      appBarColor: appBarColor ?? this.appBarColor,
      bodyColor: bodyColor ?? this.bodyColor,
      cardColor: cardColor ?? this.cardColor,
      negativeActionColor: negativeActionColor ?? this.negativeActionColor,
      positiveActionColor: positiveActionColor ?? this.positiveActionColor,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) {
      return this;
    }
    return AppColorsExt(
      textColor: Color.lerp(textColor, other.textColor, t),
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t),
      bodyColor: Color.lerp(appBarColor, other.bodyColor, t),
      cardColor: Color.lerp(appBarColor, other.cardColor, t),
      negativeActionColor:
          Color.lerp(appBarColor, other.negativeActionColor, t),
      positiveActionColor:
          Color.lerp(appBarColor, other.positiveActionColor, t),
      dividerColor: Color.lerp(appBarColor, other.dividerColor, t),
    );
  }
}
