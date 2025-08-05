import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/config/routes/route_config.dart';
import 'package:todoapp/config/theme/cubit/theme_cubit.dart';
import 'package:todoapp/config/theme/dark_theme/dark_theme.dart';
import 'package:todoapp/config/theme/get_theme.dart';
import 'package:todoapp/core/service_locator.dart';
import 'package:todoapp/core/shared_preferences.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/service/dio/dio_manager.dart';
import 'package:todoapp/service/firebase/firebase_handler.dart';
import 'package:todoapp/service/server_config.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc()),
          BlocProvider(create: (context) => ThemeCubit()..init()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
          final themeMode = getTheme(state, context);
          return MaterialApp.router(
            title: 'Todo App',
            theme: getCustomThemeData(themeMode: themeMode),
            debugShowCheckedModeBanner: false,
            darkTheme: DarkTheme.themeData(),
            themeMode: state,
            routerConfig: router,
          );
        }));
  }
}

void main({ServerConfig? defaultServerConfig}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPref.init();
    await FirebaseHandler.init();
    await HiveCache.init();
    await setUpLocator();

    // initialize live/test/prepod server
    DioManager.init(defaultServerConfig ?? TestServerConfig());
    runApp(const MyApp());
  }, (error, s) {
    log(error.toString());
  });
}
