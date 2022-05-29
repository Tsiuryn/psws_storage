import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:psws_storage/presenter/main/main_page.dart';
import 'package:psws_storage/presenter/pin/presentation/pin_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    pages
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter{}


const pages = AutoRoute(
  path: '/',
  page: EmptyRouterPage,
  children: [
    AutoRoute(
      path: 'credential',
    page: PinPage,
    initial: true,
  ),
    AutoRoute(
        path: 'home',
        page: MainPage,
    ),
  ]
);