import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/helper/error_screen.dart';
import 'package:todoapp/src/home/presentation/view_task_list.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: ViewTaskList.routeName,
      routes: [ViewTaskList.route()],
      errorBuilder: (context, state) => const ErrorScreen());
}
