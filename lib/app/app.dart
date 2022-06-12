import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/app_bloc/environment.dart';

import 'router/app_router.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppBloc(),
        child: BlocBuilder<AppBloc, Environment>(
          builder: (context, settings) {
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
              themeMode: ThemeMode.values
                  .firstWhere((element) => element == settings.themeType),
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              supportedLocales: const [
                Locale('en', ''), // English, no country code
                Locale('ru', ''), // Spanish, no country code
              ],
            );
          },
        ));
  }
}
