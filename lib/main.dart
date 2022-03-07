import 'package:flutter/material.dart';
import 'package:psws_storage/app/app.dart';
import 'package:psws_storage/app/di/di.dart';
import 'app/router/app_router.dart';


void main() {
  // init GetIt
  initDi();
  _initializedGetIt();
}

void _initializedGetIt(){
  getIt
      .allReady()
      .whenComplete(() {
    final appRouter = AppRouter();
        runApp(MyApp(appRouter: appRouter,));
  });
}



