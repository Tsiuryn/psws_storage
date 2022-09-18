import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psws_storage/app/app.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';

import 'app/router/app_router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init GetIt
  await _initHive();
  await initDi();
  _initializedGetIt();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DirectoryBeanAdapter());
  }
}

void _initializedGetIt() {
  getIt.allReady().whenComplete(() {
    final appRouter = AppRouter();
    runApp(MyApp(
      appRouter: appRouter,
    ));
  });
}
