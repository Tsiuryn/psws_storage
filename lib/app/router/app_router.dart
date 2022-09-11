import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:psws_storage/editor/presenter/main/main_page.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_page.dart';
import 'package:psws_storage/pin/presentation/pin_page.dart';
import 'package:psws_storage/settings/import_export/import_export_page.dart';
import 'package:psws_storage/settings/settings_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[pages],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}

const pages = AutoRoute(path: '/', page: EmptyRouterPage, children: [
  AutoRoute(
    path: 'credential',
    page: PinPage,
    initial: true,
  ),
  AutoRoute(
    path: 'home',
    page: MainPage,
  ),
  CustomRoute(
    path: 'edit_note',
    page: EditNotesPage,
    transitionsBuilder: TransitionsBuilders.slideRight,
  ),
  CustomRoute(
    path: 'settings',
    page: SettingsPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: 'import_export',
    page: ImportExportPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
]);
