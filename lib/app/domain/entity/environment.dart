class Environment {
  final ThemeType themeType;
  final AppLocale appLocale;
  final LocalAuth localAuth;
  final HideScreen hideScreen;
  final Sort sort;

  Environment({
    required this.themeType,
    required this.appLocale,
    required this.localAuth,
    required this.hideScreen,
    required this.sort,
  });

  Environment.empty()
      : appLocale = AppLocale.rus,
        themeType = ThemeType.dark,
        localAuth = LocalAuth.pin,
        hideScreen = HideScreen.yes,
        sort = const Sort.def();

  Environment copyWith({
    ThemeType? themeType,
    AppLocale? appLocale,
    LocalAuth? localAuth,
    HideScreen? hideScreen,
    Sort? sort,
  }) {
    return Environment(
      themeType: themeType ?? this.themeType,
      appLocale: appLocale ?? this.appLocale,
      localAuth: localAuth ?? this.localAuth,
      hideScreen: hideScreen ?? this.hideScreen,
      sort: sort ?? this.sort,
    );
  }
}

class Sort {
  final bool folderInclude;
  final SortBy sortBy;
  final SortType sortType;

  const Sort({
    required this.folderInclude,
    required this.sortBy,
    required this.sortType,
  });

  const Sort.def()
      : folderInclude = true,
        sortBy = SortBy.name,
        sortType = SortType.desc;

  Sort copyWith({
    bool? folderInclude,
    SortBy? sortBy,
    SortType? sortType,
  }) {
    return Sort(
      folderInclude: folderInclude ?? this.folderInclude,
      sortBy: sortBy ?? this.sortBy,
      sortType: sortType ?? this.sortType,
    );
  }
}

enum SortBy { name, date }

enum SortType { asc, desc }

enum ThemeType { light, dark }

enum AppLocale { rus, eng }

enum LocalAuth { pin, fingerprint }

enum HideScreen { no, yes }
