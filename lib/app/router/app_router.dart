import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:psws_storage/editor/presenter/main/main_page.dart';
import 'package:psws_storage/editor/presenter/main/pages/search_directory_page.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_page.dart';
import 'package:psws_storage/pin/presentation/pin_page.dart';
import 'package:psws_storage/settings/presentation/change_psw/change_psw_page.dart';
import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';
import 'package:psws_storage/settings/presentation/import_mtn/import_mtn_page.dart';
import 'package:psws_storage/settings/presentation/import_mtn/info/import_mtn_info_page.dart';
import 'package:psws_storage/settings/settings_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[pages],
)
// extend the generated private router
class $AppRouter {}

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
    path: 'search',
    page: SearchDirectoryPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
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
  CustomRoute(
    path: 'mtn_import',
    page: ImportMtnPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: 'mtn_import_info',
    page: ImportMtnInfoPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
  CustomRoute(
    path: 'change_password',
    page: ChangePswPage,
    transitionsBuilder: TransitionsBuilders.slideLeft,
  ),
]);
