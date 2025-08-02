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
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: child);
        });
  }
}
