import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator {
  static Future<void> showProgress(BuildContext context,
      {bool? canPop = true}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PopScope(
              canPop: canPop!,
              child: const Dialog(
                  backgroundColor: Colors.transparent,
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CupertinoActivityIndicator(
                          color: Colors.white, radius: 7.5))));
        });
  }

  static Widget cupertinoLoadingIndicator({Color? color, double? radius}) {
    return Center(
        child: CupertinoActivityIndicator(color: color, radius: radius ?? 10));
  }
}
