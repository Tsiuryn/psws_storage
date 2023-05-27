class Environment {
  final ThemeType themeType;
  final AppLocale appLocale;
  final LocalAuth localAuth;
  final HideScreen hideScreen;

  Environment({
    required this.themeType,
    required this.appLocale,
    required this.localAuth,
    required this.hideScreen,
  });

  Environment.empty()
      : appLocale = AppLocale.rus,
        themeType = ThemeType.dark,
        localAuth = LocalAuth.pin,
        hideScreen = HideScreen.yes;

  Environment copyWith({
    ThemeType? themeType,
    AppLocale? appLocale,
    LocalAuth? localAuth,
    HideScreen? hideScreen,
  }) {
    return Environment(
      themeType: themeType ?? this.themeType,
      appLocale: appLocale ?? this.appLocale,
      localAuth: localAuth ?? this.localAuth,
      hideScreen: hideScreen ?? this.hideScreen,
    );
  }
}

enum ThemeType { light, dark }

enum AppLocale { rus, eng }

enum LocalAuth { pin, fingerprint }

enum HideScreen { no, yes }
