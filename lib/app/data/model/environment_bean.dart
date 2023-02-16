import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';

part 'environment_bean.g.dart';

@JsonSerializable()
class EnvironmentBean {
  @JsonKey(name: 'themeType')
  final ThemeTypeBean themeType;

  @JsonKey(name: 'appLocale')
  final AppLocaleBean appLocale;

  @JsonKey(
    name: 'localAuth',
    defaultValue: LocalAuthBean.pin,
    includeIfNull: true,
  )
  final LocalAuthBean localAuth;

  const EnvironmentBean({
    required this.themeType,
    required this.appLocale,
    required this.localAuth,
  });

  factory EnvironmentBean.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentBeanFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentBeanToJson(this);
}

enum ThemeTypeBean {
  @JsonValue('LIGHT')
  light,
  @JsonValue('DARK')
  dark,
}

enum AppLocaleBean {
  @JsonValue('RU')
  ru,
  @JsonValue('EN')
  en,
}

enum LocalAuthBean {
  @JsonValue('PIN')
  pin,
  @JsonValue('FINGERPRINT')
  fingerprint,
}

extension EnvironmentBeanExt on EnvironmentBean {
  Environment fromBean() => Environment(
        themeType:
            themeType == ThemeTypeBean.dark ? ThemeType.dark : ThemeType.light,
        appLocale:
            appLocale == AppLocaleBean.ru ? AppLocale.rus : AppLocale.eng,
        localAuth: localAuth == LocalAuthBean.pin
            ? LocalAuth.pin
            : LocalAuth.fingerprint,
      );
}

extension EnvironmentExt on Environment {
  EnvironmentBean toBean() => EnvironmentBean(
        themeType: themeType == ThemeType.dark
            ? ThemeTypeBean.dark
            : ThemeTypeBean.light,
        appLocale:
            appLocale == AppLocale.rus ? AppLocaleBean.ru : AppLocaleBean.en,
        localAuth: localAuth == LocalAuth.pin
            ? LocalAuthBean.pin
            : LocalAuthBean.fingerprint,
      );
}
