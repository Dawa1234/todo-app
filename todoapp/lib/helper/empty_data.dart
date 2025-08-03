import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String? message;
  final String? subMessage;

  const EmptyData({super.key, this.message, this.subMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Text(message ?? "No data to show",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      if (subMessage != null) Text(subMessage!)
    ]));
  }
}
