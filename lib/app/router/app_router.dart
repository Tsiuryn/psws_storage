import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/main_page.dart';
import 'package:psws_storage/editor/presenter/main/pages/search_directory_page.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_page.dart';
import 'package:psws_storage/pin/presentation/pin_page.dart';
import 'package:psws_storage/settings/presentation/change_psw/change_psw_page.dart';
import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';
import 'package:psws_storage/settings/presentation/import_mtn/import_mtn_page.dart';
import 'package:psws_storage/settings/presentation/import_mtn/info/import_mtn_info_page.dart';
import 'package:psws_storage/settings/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => pages;
}

final pages = [
  AutoRoute(
    path: '/credential',
    page: PinRoute.page,
    initial: true,
  ),
  AutoRoute(
    path: '/home',
    page: MainRoute.page,
  ),
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
    path: '/settings',
    page: SettingsRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/import_export',
    page: ImportExportRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/mtn_import',
    page: ImportMtnRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/mtn_import_info',
    page: ImportMtnInfoRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: '/change_password',
    page: ChangePswRoute.page,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
];
