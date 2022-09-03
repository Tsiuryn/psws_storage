import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';
    final appTheme = AppTheme(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.settings_page__title ?? '',
          style: appTheme.appTextStyles?.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: appTheme.appColors?.textColor,
          ),
          onPressed: context.popRoute,
        ),
        bottom: const PreferredSize(
          child: Divider(),
          preferredSize: Size.fromHeight(1),
        ),
      ),
      body: BlocBuilder<AppBloc, Environment>(
          bloc: getIt.get<AppBloc>(),
          builder: (context, environment) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppDim.sixteen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SettingsItem(
                      title: titleTheme,
                      child: Row(
                        children: [
                          Text(
                            environment.themeType == ThemeType.dark
                                ? l10n?.settings_page__color_scheme_night ?? ''
                                : l10n?.settings_page__color_scheme_day ?? '',
                            style: appTheme.appTextStyles?.subtitle,
                          ),
                          const Expanded(child: SizedBox()),
                          CupertinoSlidingSegmentedControl<ThemeType>(
                            children: ThemeTypeExt.toMap(context),
                            groupValue: environment.themeType == ThemeType.dark
                                ? ThemeType.dark
                                : ThemeType.light,
                            onValueChanged: (newValue) {
                              if (newValue != null) {
                                context.read<AppBloc>().changeTheme(newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SettingsItem(
                      title: titleLocale,
                      child: Row(
                        children: [
                          Text(
                              environment.appLocale == AppLocale.rus
                                  ? l10n?.settings_page__language_rus ?? ''
                                  : l10n?.settings_page__language_eng ?? '',
                              style: appTheme.appTextStyles?.subtitle),
                          const Expanded(child: SizedBox()),
                          CupertinoSlidingSegmentedControl<AppLocale>(
                            children: AppLocaleExt.toMap(context),
                            groupValue: environment.appLocale == AppLocale.rus
                                ? AppLocale.rus
                                : AppLocale.eng,
                            onValueChanged: (newValue) {
                              if (newValue != null) {
                                context.read<AppBloc>().changeLocale(newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SettingsItem(
                      title: l10n?.settings_page__export ?? '',
                      informationMessage:
                          l10n?.settings_page__export_tooltip ?? '',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text(
                                    l10n?.settings_page__export_btn ?? '',
                                    style: appTheme.appTextStyles?.subtitle,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/ic_export.svg',
                                    color: appTheme.appColors?.textColor,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    SettingsItem(
                      title: l10n?.settings_page__import ?? '',
                      informationMessage:
                          l10n?.settings_page__import_tooltip ?? '',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text(
                                    l10n?.settings_page__import_btn ?? '',
                                    style: appTheme.appTextStyles?.subtitle,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/ic_import.svg',
                                    color: appTheme.appColors?.textColor,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

extension ThemeTypeExt on ThemeType {
  static Map<ThemeType, Widget> toMap(BuildContext context) {
    Map<ThemeType, Widget> map = {};
    for (var e in ThemeType.values) {
      map[e] = SizedBox(
        height: 24,
        child: Text(
          e == ThemeType.dark
              ? AppLocalizations.of(context)!
                  .main_appbar_bottom_theme_title_dark
                  .toUpperCase()
              : AppLocalizations.of(context)!
                  .main_appbar_bottom_theme_title_light
                  .toUpperCase(),
          style:
              TextStyle(color: Theme.of(context).primaryColorDark, height: 1.5),
        ),
      );
    }

    return map;
  }
}

extension AppLocaleExt on AppLocale {
  static Map<AppLocale, Widget> toMap(BuildContext context) {
    Map<AppLocale, Widget> map = {};
    for (var e in AppLocale.values) {
      map[e] = SizedBox(
        height: 24,
        child: Text(
          e.name.toUpperCase(),
          style:
              TextStyle(color: Theme.of(context).primaryColorDark, height: 1.5),
        ),
      );
    }

    return map;
  }
}

class SettingsItem extends StatefulWidget {
  final String title;
  final Widget child;
  final String informationMessage;

  const SettingsItem({
    Key? key,
    required this.title,
    required this.child,
    this.informationMessage = '',
  }) : super(key: key);

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDim.sixteen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppDim.sixteen,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: appTheme.appTextStyles?.titleMedium,
                ),
              ),
              Visibility(
                visible: widget.informationMessage.isNotEmpty,
                child: Tooltip(
                  key: tooltipKey,
                  message: widget.informationMessage,
                  margin: const EdgeInsets.symmetric(horizontal: AppDim.eight),
                  child: IconButton(
                    onPressed: () {
                      tooltipKey.currentState?.ensureTooltipVisible();
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_information.svg',
                      color: appTheme.appColors?.textColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          widget.child,
          const SizedBox(
            height: AppDim.sixteen,
          ),
          const Divider()
        ],
      ),
    );
  }
}