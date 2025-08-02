import 'package:flutter/material.dart';

class AppWidgetHelper {
  static Future<void> showBottomSheet(BuildContext context,
      {required Widget child}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              margin: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  // color: helperBoxColor(theme),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: child);
        });
  }
}
