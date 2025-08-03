import 'package:flutter/material.dart';
import 'package:todoapp/config/theme/black_theme/black_theme.dart';
import 'package:todoapp/config/theme/dark_theme/dark_theme.dart';
import 'package:todoapp/config/theme/light_theme/light_theme.dart';

ThemeMode getTheme(ThemeMode theme, BuildContext context) {
  final systemThemeMode = MediaQuery.platformBrightnessOf(context);

  if (theme == ThemeMode.system) {
    if (systemThemeMode == Brightness.light) return ThemeMode.light;
    return ThemeMode.dark;
  } else if (theme == ThemeMode.light) {
    return ThemeMode.light;
  } else if (theme == ThemeMode.dark) {
    return ThemeMode.dark;
  } else if (theme == ThemeMode.black) {
    return ThemeMode.black;
  } else {
    return ThemeMode.light;
  }
}

ThemeData getCustomThemeData({required ThemeMode themeMode}) {
  switch (themeMode) {
    case ThemeMode.black:
      return BlackTheme.themeData();
    default:
      return LightTheme.themeData();
  }
}

Color helperBoxColor(ThemeMode theme) {
  switch (theme) {
    case ThemeMode.dark:
      return boxColorDark;
    case ThemeMode.light:
      return Colors.white;
    case ThemeMode.black:
      return boxColorBlack;
    default:
      return Colors.white;
  }
}

Color helperPrimaryColor(ThemeMode theme) {
  switch (theme) {
    case ThemeMode.dark:
      return kPrimaryColorDark;
    case ThemeMode.light:
      return kPrimaryColorLight;
    case ThemeMode.black:
      return kPrimaryColorBlack;
    default:
      return Colors.grey;
  }
}
