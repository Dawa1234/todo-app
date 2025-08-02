import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/helper/error_screen.dart';
import 'package:todoapp/main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: Home.routeName,
      routes: [Home.route(), Home2.route()],
      errorBuilder: (context, state) => const ErrorScreen());
}
