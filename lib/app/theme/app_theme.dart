import 'package:flutter/material.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';

class AppTheme {
  final BuildContext context;

  AppTheme(this.context);

  AppColorsExt? get appColors => Theme.of(context).extension<AppColorsExt>();

  AppTextStyleExt? get appTextStyles =>
      Theme.of(context).extension<AppTextStyleExt>();
}

extension BuildContextExtension on BuildContext {
  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;

  AppTextStyleExt get appTextStyles =>
      Theme.of(this).extension<AppTextStyleExt>()!;
}
