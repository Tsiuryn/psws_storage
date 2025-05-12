import 'package:flutter/material.dart';
import 'package:psws_storage/res/app_localizations.dart';

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
