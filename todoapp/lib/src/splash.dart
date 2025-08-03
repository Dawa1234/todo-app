import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/src/home/presentation/home.dart'; // or use Navigator

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "/splash";

  static GoRoute route() {
    return GoRoute(
        path: routeName,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SplashScreen());
        });
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    // Delay 2 seconds and navigate to home
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement(Home.routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RotationTransition(
                turns: _controller, child: const FlutterLogo(size: 80))));
  }
}
