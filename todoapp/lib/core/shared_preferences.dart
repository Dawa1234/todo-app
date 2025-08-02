import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/constants.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;

  const SharedPref._internal();
  factory SharedPref() => const SharedPref._internal();
  static SharedPref get instance => const SharedPref._internal();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  set setTheme(String theme) =>
      _sharedPreferences?.setString(AppConstants.THEME_KEY, theme);

  String get getTheme =>
      _sharedPreferences?.getString(AppConstants.THEME_KEY) ?? "";

  Future<bool> clearData(String key) async =>
      await _sharedPreferences?.remove(key) ?? false;
}
