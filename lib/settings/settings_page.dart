import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/icon_with_tooltip.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/presentation/bloc/settings_bloc.dart';
import 'package:psws_storage/settings/presentation/bloc/settings_state.dart';
import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';

class SettingsPage extends StatelessWidget with PswsDialogs {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';
    final appTheme = AppTheme(context);
    final mainBloc = getIt.get<AppBloc>();
    final environment = mainBloc.state;

    return LifeCycleWidget(
      router: context.router,
      currentRouteName: SettingsRoute.name,
      child: BlocProvider<SettingsBloc>(
        create: (BuildContext context) {
          return getIt.get<SettingsBloc>();
        },
        child: BlocConsumer<SettingsBloc, SettingsState>(
          builder: (context, state) {
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
              body: SingleChildScrollView(
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
                              groupValue: environment.themeType == ThemeType.dark ? ThemeType.dark : ThemeType.light,
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
                              groupValue: environment.appLocale == AppLocale.rus ? AppLocale.rus : AppLocale.eng,
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
                        informationMessage: l10n?.settings_page__export_tooltip ?? '',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  context.read<SettingsBloc>().checkPermission(ImportExportPageType.export);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      l10n?.settings_page__export_btn ?? '',
                                      style: appTheme.appTextStyles?.subtitle,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.icExport,
                                      color: appTheme.appColors?.textColor,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      SettingsItem(
                        title: l10n?.settings_page__import ?? '',
                        informationMessage: l10n?.settings_page__import_tooltip ?? '',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  context.read<SettingsBloc>().checkPermission(ImportExportPageType.import);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      l10n?.settings_page__import_btn ?? '',
                                      style: appTheme.appTextStyles?.subtitle,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.icImport,
                                      color: appTheme.appColors?.textColor,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      SettingsItem(
                          title: l10n?.import_mtn_settings_title ?? '',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.router.push(const ImportMtnRoute());
                                },
                                child: Text(
                                  l10n?.import_mtn_settings_btn_title ?? '',
                                  style: appTheme.appTextStyles?.subtitle,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
          listener: _settingsBlocListener,
        ),
      ),
    );
  }

  void _settingsBlocListener(BuildContext context, SettingsState state) {
    final bloc = context.read<SettingsBloc>();
    if (state is ShowPermissionDialog) {
      state.model;
      _showOkDialog(context, tapOk: () {
        bloc.checkPermission(state.type);
      });
    }
    if (state is ShowSettings) {
      _showOkDialog(context, tapOk: () {
        openAppSettings();
        context.popRoute();
      });
    }
    if (state is StoragePermissionGranted) {
      context.pushRoute(ImportExportRoute(type: state.type));
    }
  }

  void _showOkDialog(BuildContext context, {required VoidCallback tapOk}) {
    final l10n = AppLocalizations.of(context)!;
    createOkDialog(context,
        title: l10n.settings_page__ok_dialog_title,
        message: l10n.settings_page__ok_dialog_description,
        tapOk: tapOk,
        tapNo: () {});
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
              ? AppLocalizations.of(context)!.main_appbar_bottom_theme_title_dark.toUpperCase()
              : AppLocalizations.of(context)!.main_appbar_bottom_theme_title_light.toUpperCase(),
          style: TextStyle(color: Theme.of(context).primaryColorDark, height: 1.5),
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
          style: TextStyle(color: Theme.of(context).primaryColorDark, height: 1.5),
        ),
      );
    }

    return map;
  }
}

class SettingsItem extends StatelessWidget {
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
                  title,
                  style: appTheme.appTextStyles?.titleMedium,
                ),
              ),
              Visibility(
                visible: informationMessage.isNotEmpty,
                child: IconWithTooltip(
                  message: informationMessage,
                  icon: SvgPicture.asset(
                    AppIcons.icInformation,
                    color: appTheme.appColors?.textColor,
                  ),
                ),
              )
            ],
          ),
          child,
          const SizedBox(
            height: AppDim.sixteen,
          ),
          const Divider()
        ],
      ),
    );
  }
}
