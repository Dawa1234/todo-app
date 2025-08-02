import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/config/default_size.dart';

const kPrimaryColorLight = Color.fromRGBO(241, 242, 244, 1);
const labelColorLight = Color.fromRGBO(0, 35, 53, 1);
const successColorLight = Color.fromRGBO(76, 175, 80, 1);

class LightTheme {
  static final inputDecoration = InputDecorationTheme(
      hintStyle: const TextStyle(fontSize: kfontSizeRegular),
      disabledBorder: border,
      contentPadding: EdgeInsets.zero,
      filled: false,
      errorBorder: border,
      border: border,
      focusedBorder: border,
      focusedErrorBorder: border,
      enabledBorder: border);
  static ThemeData themeData() {
    return ThemeData.light().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                elevation: 1,
                shadowColor: Colors.grey.shade50,
                splashFactory: NoSplash.splashFactory,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: kfullButtonTextColor)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: labelColorLight,
                textStyle: const TextStyle(
                    color: labelColorLight, fontWeight: FontWeight.bold))),
        textSelectionTheme: const TextSelectionThemeData(
            selectionColor: kPrimaryColor, selectionHandleColor: kPrimaryColor),
        colorScheme: const ColorScheme.light(
            secondary: successColorLight,
            onPrimary: labelColorLight,
            primary: kPrimaryColor),
        tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            indicatorColor: successColorLight),
        radioTheme: const RadioThemeData(
            visualDensity: VisualDensity.compact,
            splashRadius: 5,
            fillColor: WidgetStatePropertyAll(Colors.blueGrey)),
        scaffoldBackgroundColor: kPrimaryColorLight,
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            toolbarHeight: 40,
            centerTitle: false,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            titleTextStyle: TextStyle(
                color: labelColorLight,
                fontSize: kfontSizeLarge,
                fontWeight: FontWeight.w600),
            color: Colors.transparent),
        dividerTheme: const DividerThemeData(color: kPrimaryColorLight),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: kPrimaryColorLight),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        inputDecorationTheme: inputDecoration,
        dropdownMenuTheme:
            const DropdownMenuThemeData(textStyle: TextStyle(fontSize: 14)),
        listTileTheme: const ListTileThemeData(
            titleTextStyle: TextStyle(
                color: labelColorLight,
                fontSize: kfontSizeRegular,
                fontWeight: FontWeight.w600),
            subtitleTextStyle: TextStyle(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
        expansionTileTheme: ExpansionTileThemeData(
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.transparent, width: 0))),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 10,
            selectedItemColor: labelColorLight,
            selectedLabelStyle: TextStyle(fontSize: kfontSizeRegular),
            backgroundColor: Colors.white),
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black, fontSize: kfontSizeLarge), bodyMedium: TextStyle(color: labelColorLight, fontSize: kfontSizeRegular), bodySmall: TextStyle(color: labelColorLight, fontSize: kfontSizeSmall, fontWeight: FontWeight.w500), titleLarge: TextStyle(color: labelColorLight, fontSize: kfontSizeLarge, fontWeight: FontWeight.w600), titleMedium: TextStyle(color: labelColorLight, fontSize: kfontSizeRegular)));
  }

  static get border => const OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent));
}
