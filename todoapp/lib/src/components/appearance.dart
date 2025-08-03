import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/config/theme/cubit/theme_cubit.dart';
import 'package:todoapp/config/theme/get_theme.dart';
import 'package:todoapp/helper/sized_box.dart';

class Appearance extends StatelessWidget {
  const Appearance({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    return BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: themeCubit,
        builder: (context, state) {
          return Container(
              color: helperBoxColor(state),
              padding: const EdgeInsets.all(kPaddingRegular),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Select Theme"),
                sizedBoxhgth20,
                InkWell(
                    onTap: themeCubit.systemTheme,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("System"),
                          if (state == ThemeMode.system)
                            const Icon(CupertinoIcons.check_mark)
                        ])),
                sizedBoxhgth20,
                InkWell(
                    onTap: themeCubit.lightTheme,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Light"),
                          if (state == ThemeMode.light)
                            const Icon(CupertinoIcons.check_mark)
                        ])),
                sizedBoxhgth20,
                InkWell(
                    onTap: themeCubit.darkTheme,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Dark"),
                          if (state == ThemeMode.dark)
                            const Icon(CupertinoIcons.check_mark)
                        ])),
                sizedBoxhgth20,
                InkWell(
                    onTap: () =>
                        themeCubit.customTheme(themeMode: ThemeMode.black),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Black"),
                          if (state == ThemeMode.black)
                            const Icon(CupertinoIcons.check_mark)
                        ])),
              ]));
        });
  }
}
