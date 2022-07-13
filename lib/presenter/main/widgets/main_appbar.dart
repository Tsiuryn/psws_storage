import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/app_bloc/environment.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';

class MainAppBar extends StatelessWidget
    with PreferredSizeWidget, PswsSnackBar, PswsDialogs {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final folderName = l10n?.main_appbar_dialog_folder ?? '';
    final fileName = l10n?.main_appbar_dialog_note ?? '';
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';

    return BlocProvider(
      create: (context) => getIt.get<AppBloc>(),
      child: BlocBuilder<AppBloc, Environment>(builder: (context, state) {
        return AppBar(
          title: Row(children: [
            IconButton(
                onPressed: () {
                  createFileDialog(context, title: fileName, isFolder: false,
                      value: (value) {
                    bloc.addFile(value);
                  });
                },
                icon: const Icon(
                  Icons.add,
                )),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  createFileDialog(context, title: folderName, value: (value) {
                    bloc.addFolder(value);
                  });
                },
                icon: const Icon(
                  Icons.folder,
                )),
            const Expanded(
              child: SizedBox(),
            ),
            IconButton(
              onPressed: () {
                showBottomSheet(context, state: state);
              },
              icon: const Icon(
                Icons.menu,
              ),
              alignment: AlignmentDirectional.centerEnd,
            )
          ]),
        );
      }),
    );
  }

  void showBottomSheet(BuildContext context, {required Environment state}) {
    final l10n = AppLocalizations.of(context);
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 250,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDim.sixteen),
                  topRight: Radius.circular(AppDim.sixteen),
                ),
                color: Theme.of(context).primaryColor),
            child: Padding(
              padding: const EdgeInsets.all(AppDim.sixteen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    titleTheme,
                    style: const TextStyle(
                      fontSize: AppDim.twentyFour,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: AppDim.sixteen,
                  ),
                  CupertinoSlidingSegmentedControl<ThemeType>(
                    children: ThemeTypeExt.toMap(context),
                    groupValue: state.themeType == ThemeType.dark
                        ? ThemeType.dark
                        : ThemeType.light,
                    onValueChanged: (newValue) {
                      if (newValue != null) {
                        context.read<AppBloc>().changeTheme(newValue);
                        context.router.pop();
                      }
                    },
                  ),
                  const SizedBox(
                    height: AppDim.fourty,
                  ),
                  Text(
                    titleLocale,
                    style: const TextStyle(
                      fontSize: AppDim.twentyFour,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: AppDim.sixteen,
                  ),
                  CupertinoSlidingSegmentedControl<AppLocale>(
                    children: AppLocaleExt.toMap(context),
                    groupValue: state.appLocale == AppLocale.ru
                        ? AppLocale.ru
                        : AppLocale.en,
                    onValueChanged: (newValue) {
                      if (newValue != null) {
                        context.read<AppBloc>().changeLocale(newValue);
                        context.router.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

extension ThemeTypeExt on ThemeType {
  static Map<ThemeType, Widget> toMap(BuildContext context) {
    Map<ThemeType, Widget> map = {};
    for (var e in ThemeType.values) {
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
