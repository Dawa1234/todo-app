import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';

class FullButton extends StatelessWidget {
  final void Function()? onPressed;
  final double? btnHeight;
  final double? btnWidth;
  final Widget? child;
  final Color? btnColor;
  final Color? labelColor;
  final VisualDensity? visualDensity;
  const FullButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.btnHeight,
      this.btnWidth,
      this.btnColor,
      this.visualDensity,
      this.labelColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: visualDensity,
          foregroundColor:
              labelColor ?? (btnColor == null ? kfullButtonTextColor : null),
          backgroundColor: btnColor ?? kPrimaryColor,
          minimumSize: Size(btnWidth ?? double.infinity, btnHeight ?? 50),
          disabledBackgroundColor:
              btnColor?.withOpacity(.3) ?? kPrimaryColor.withOpacity(.3),
        ),
        onPressed: onPressed,
        child: child);
  }
}
