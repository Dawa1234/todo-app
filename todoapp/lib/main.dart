import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/config/routes/route_config.dart';
import 'package:todoapp/config/theme/dark_theme/dark_theme.dart';
import 'package:todoapp/config/theme/light_theme/light_theme.dart';
import 'package:todoapp/core/shared_preferences.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/service/dio/dio_manager.dart';
import 'package:todoapp/service/firebase/firebase_handler.dart';
import 'package:todoapp/service/server_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return MaterialApp.router(
        title: 'Todo App',
        theme: LightTheme.themeData(),
        // theme: getCustomThemeData(themeMode: themeMode),
        darkTheme: DarkTheme.themeData(),
        themeMode: ThemeMode.system,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate);
  }
}

void main({ServerConfig? defaultServerConfig}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPref.init();
    await FirebaseHandler.init();
    await HiveCache.init();

    // initialize live/test/prepod server
    DioManager.init(defaultServerConfig ?? TestServerConfig());

    runApp(const MyApp());
  }, (error, s) {
    log(error.toString());
  });
}
