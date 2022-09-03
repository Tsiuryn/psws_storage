import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';

import 'router/app_router.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt.get<AppBloc>()..init(),
        child: BlocBuilder<AppBloc, Environment>(
          builder: (context, settings) {
            final Locale locale = settings.appLocale == AppLocale.rus
                ? const Locale('ru')
                : const Locale('en');
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerDelegate: appRouter.delegate(),
              routeInformationParser: appRouter.defaultRouteParser(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: settings.themeType == ThemeType.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              theme: lightTheme(context),
              locale: locale,
              darkTheme: darkTheme(context),
              supportedLocales: const [
                Locale('en', ''), // English, no country code
                Locale('ru', ''),
              ],
            );
          },
        ));
  }
}
