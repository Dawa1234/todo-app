import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';

const Color kPrimaryColorBlack = Color.fromRGBO(19, 20, 20, 1);
const Color successColorBlack = Color.fromRGBO(165, 213, 160, 1);
// Container Color
const boxColorBlack = Color.fromRGBO(29, 30, 30, 1);

class BlackTheme {
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
    return ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.white)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        colorScheme: const ColorScheme.dark(
            secondary: Colors.white,
            onPrimary: Colors.white,
            primary: kPrimaryColor),
        checkboxTheme: const CheckboxThemeData(
            checkColor: WidgetStatePropertyAll(Colors.black)),
        tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            indicatorColor: successColorBlack),
        radioTheme: const RadioThemeData(
            visualDensity: VisualDensity.compact, splashRadius: 5),
        appBarTheme: const AppBarTheme(
            toolbarHeight: 40,
            centerTitle: true,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            titleTextStyle: TextStyle(
                fontSize: kfontSizeLarge, fontWeight: FontWeight.w600),
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white)),
        dividerTheme: const DividerThemeData(color: kPrimaryColorBlack),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: kPrimaryColorBlack),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        inputDecorationTheme: inputDecoration,
        scaffoldBackgroundColor: kPrimaryColorBlack,
        dropdownMenuTheme: const DropdownMenuThemeData(
            textStyle: TextStyle(fontSize: kfontSizeRegular)),
        listTileTheme: const ListTileThemeData(
            titleTextStyle: TextStyle(
                fontSize: kfontSizeRegular, fontWeight: FontWeight.w600),
            subtitleTextStyle: TextStyle(
                fontSize: kfontSizeSmall, fontWeight: FontWeight.w500)),
        expansionTileTheme: ExpansionTileThemeData(
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.transparent, width: 0))),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 10,
            selectedLabelStyle: TextStyle(fontSize: kfontSizeRegular)),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: kfontSizeLarge),
            bodyMedium: TextStyle(fontSize: kfontSizeRegular),
            bodySmall: TextStyle(
                fontSize: kfontSizeSmall, fontWeight: FontWeight.w500),
            titleLarge: TextStyle(
                fontSize: kfontSizeLarge, fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontSize: kfontSizeRegular)));
  }

  static get border => const OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent));
}
