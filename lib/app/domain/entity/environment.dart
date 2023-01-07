class Environment {
  final ThemeType themeType;
  final AppLocale appLocale;
  final LocalAuth localAuth;

  Environment({
    required this.themeType,
    required this.appLocale,
    required this.localAuth,
  });

  Environment.empty()
      : appLocale = AppLocale.rus,
        themeType = ThemeType.dark,
        localAuth = LocalAuth.pin;

  Environment copyWith({
    ThemeType? themeType,
    AppLocale? appLocale,
    LocalAuth? localAuth,
  }) {
    return Environment(
      themeType: themeType ?? this.themeType,
      appLocale: appLocale ?? this.appLocale,
      localAuth: localAuth ?? this.localAuth,
    );
  }
}

enum ThemeType { light, dark }

enum AppLocale { rus, eng }

enum LocalAuth { pin, fingerprint }
