import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/config/routes/route_config.dart';
import 'package:todoapp/config/theme/dark_theme/dark_theme.dart';
import 'package:todoapp/config/theme/light_theme/light_theme.dart';
import 'package:todoapp/core/shared_preferences.dart';
import 'package:todoapp/data/hive/hive_init.dart';
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

void main({ServerConfig? defaulServerConfig}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPref.init();
    await FirebaseHandler.init();
    await HiveCache.init();

    runApp(const MyApp());
  }, (error, s) {
    log(error.toString());
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = "/home";

  static GoRoute route() {
    return GoRoute(
        path: Home.routeName, builder: (context, state) => const Home());
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InkWell(
            onTap: () async {
              context.push(Home2.routeName);
            },
            child: const Text("This is the home page")),
      ),
    );
  }
}

class Home2 extends StatefulWidget {
  const Home2({super.key});

  static const String routeName = "/home2";

  static GoRoute route() {
    return GoRoute(
        path: Home2.routeName,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: Home2());
        });
  }

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(),
      body: Center(
        child: InkWell(
            onTap: context.pop, child: const Text("This is the home page")),
      ),
    );
  }
}
