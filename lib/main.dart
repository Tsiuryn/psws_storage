import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psws_storage/app/app.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';
import 'package:psws_storage/editor/data/source/local/db/goals_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final db = GoalsDatabase();

  // init GetIt
  await _initHive();
  await initDi(db);
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
