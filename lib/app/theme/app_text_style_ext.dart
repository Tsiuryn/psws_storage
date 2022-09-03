import 'package:flutter/material.dart';

@immutable
class AppTextStyleExt extends ThemeExtension<AppTextStyleExt> {
  const AppTextStyleExt({
    required this.titleLarge,
    required this.titleMedium,
    required this.subtitle,
  });

  final TextStyle? titleLarge;
  final TextStyle? titleMedium;
  final TextStyle? subtitle;

  @override
  AppTextStyleExt copyWith({
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? subtitle,
  }) {
    return AppTextStyleExt(
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  AppTextStyleExt lerp(ThemeExtension<AppTextStyleExt>? other, double t) {
    if (other is! AppTextStyleExt) {
      return this;
    }
    return AppTextStyleExt(
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t),
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t),
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t),
    );
  }
}
