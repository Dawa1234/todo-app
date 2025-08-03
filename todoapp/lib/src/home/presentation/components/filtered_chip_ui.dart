import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';

class AppliedFilterChips extends StatelessWidget {
  final List<String> filterOptions;

  const AppliedFilterChips({super.key, required this.filterOptions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterOptions
              .map((title) => Card(
                  margin: const EdgeInsets.all(kPaddingSmall),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kPaddingSmall, horizontal: kPaddingRegular),
                      child: Text(title))))
              .toList(),
        ));
  }
}
