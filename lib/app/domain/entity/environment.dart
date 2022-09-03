class Environment {
  final ThemeType themeType;
  final AppLocale appLocale;

  Environment({required this.themeType, required this.appLocale});

  Environment.empty()
      : appLocale = AppLocale.rus,
        themeType = ThemeType.dark;

  Environment copyWith({
    ThemeType? themeType,
    AppLocale? appLocale,
  }) {
    return Environment(
      themeType: themeType ?? this.themeType,
      appLocale: appLocale ?? this.appLocale,
    );
  }
}

enum ThemeType { light, dark }

enum AppLocale { rus, eng }
