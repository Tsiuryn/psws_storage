import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/app_bloc/environment.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';

class SettingsBottomSheet extends StatefulWidget {
  final Environment state;

  const SettingsBottomSheet({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late ThemeType currentTheme;
  late AppLocale currentLocale;

  @override
  void initState() {
    super.initState();
    currentLocale = widget.state.appLocale;
    currentTheme = widget.state.themeType;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';

    return Container(
      height: 300,
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
              groupValue: currentTheme == ThemeType.dark
                  ? ThemeType.dark
                  : ThemeType.light,
              onValueChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    currentTheme = newValue;
                  });
                  context.read<AppBloc>().changeTheme(newValue);
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
              groupValue:
                  currentLocale == AppLocale.ru ? AppLocale.ru : AppLocale.en,
              onValueChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    currentLocale = newValue;
                  });
                  context.read<AppBloc>().changeLocale(newValue);
                }
              },
            ),
          ],
        ),
      ),
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
