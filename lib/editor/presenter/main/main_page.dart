import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/editor/presenter/main/main_form.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LifeCycleWidget(
      router: context.router,
      currentRouteName: MainRoute.name,
      child: const MainForm(),
    );
  }
}
