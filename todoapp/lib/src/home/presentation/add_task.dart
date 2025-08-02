import 'package:flutter/material.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          TextFormField(),
          TextFormField(),
          const Spacer(),
          ElevatedButton(onPressed: () {}, child: const Text("Add"))
        ],
      ),
    );
  }
}
