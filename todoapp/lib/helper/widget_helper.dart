import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';

class AppWidgetHelper {
  static void showBottomToast(
    BuildContext context,
    String message, {
    bool? isFailure = false,
    bool? isWarning = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 5),
        backgroundColor: isFailure!
            ? Colors.red
            : isWarning!
                ? kPrimaryColor
                : Colors.green));
  }

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
