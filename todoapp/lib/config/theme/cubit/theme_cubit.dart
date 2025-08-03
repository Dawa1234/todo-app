import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/core/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  final SharedPref _sharedPref = SharedPref.instance;

  void init() {
    final theme = _sharedPref.getTheme;
    switch (theme) {
      case "light":
        lightTheme();
      case "dark":
        darkTheme();
      case "black":
        customTheme(themeMode: ThemeMode.black);
      default:
        emit(ThemeMode.system);
    }
  }

  void lightTheme() {
    _sharedPref.setTheme = ThemeMode.light.name;
    emit(ThemeMode.light);
  }

  void darkTheme() {
    _sharedPref.setTheme = ThemeMode.dark.name;
    emit(ThemeMode.dark);
  }

  void customTheme({required ThemeMode themeMode}) {
    _sharedPref.setTheme = themeMode.name;
    emit(themeMode);
  }

  void systemTheme() {
    _sharedPref.setTheme = "system";
    emit(ThemeMode.system);
  }
}
