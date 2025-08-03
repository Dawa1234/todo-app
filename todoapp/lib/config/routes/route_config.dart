import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/helper/error_screen.dart';
import 'package:todoapp/src/home/presentation/home.dart';
import 'package:todoapp/src/home/presentation/task_detail.dart';
import 'package:todoapp/src/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: SplashScreen.routeName,
      routes: [
        SplashScreen.route(),
        Home.route(),
        TaskDetail.route(),
      ],
      errorBuilder: (context, state) => const ErrorScreen());
}
