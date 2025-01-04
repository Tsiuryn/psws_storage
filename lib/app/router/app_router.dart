import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/home_page.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/main_page.dart';
import 'package:psws_storage/editor/presenter/main/pages/search_directory_page.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_page.dart';
import 'package:psws_storage/habit/habit_tracker_page.dart';
import 'package:psws_storage/pin/presentation/pin_page.dart';
import 'package:psws_storage/settings/presentation/change_psw/change_psw_page.dart';
import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';
import 'package:psws_storage/settings/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => pages;

  @override
  RouteType get defaultRouteType => const RouteType.custom(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
      );
}

final pages = [
  AutoRoute(
    path: '/credential',
    page: PinRoute.page,
    initial: true,
  ),
  AutoRoute(path: '/home_page', page: HomeRoute.page, children: [
    AutoRoute(
      path: 'main',
      page: MainRoute.page,
    ),
    AutoRoute(
      path: 'home_tracker',
      page: HabitTrackerRoute.page,
    ),
    CustomRoute(
      path: 'settings',
      page: SettingsRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
  ]),
  CustomRoute(
    path: '/search',
    page: SearchDirectoryRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/edit_note',
    page: EditNotesRoute.page,
    transitionsBuilder: TransitionsBuilders.slideRight,
  ),
  CustomRoute(
    path: '/import_export',
    page: ImportExportRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/change_password',
    page: ChangePswRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
];
