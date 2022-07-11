import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/presenter/main/main_form.dart';
import 'package:psws_storage/presenter/main/widgets/life_cycle_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LifeCycleWidget(
      router: context.router,
      child: const MainForm(),
    );
  }
}
