import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/widget_helper.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/add_task.dart';
import 'package:todoapp/src/home/presentation/components/task_tile.dart';

class ViewTaskList extends StatefulWidget {
  const ViewTaskList({super.key});

  static const String routeName = "/home2";

  static GoRoute route() {
    return GoRoute(
        path: ViewTaskList.routeName,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ViewTaskList());
        });
  }

  @override
  State<ViewTaskList> createState() => _HomePageState();
}

class _HomePageState extends State<ViewTaskList> {
  List<TaskModel> taskList = [
    const TaskModel(
      title: 'Pay for utility services',
      description: 'Home',
      priority: TaskPriority.medium,
    ),
    const TaskModel(
      title: 'Buy groceries for mac & cheese',
      description: 'Food',
      priority: TaskPriority.low,
    ),
    const TaskModel(
      title: 'Practice Piano',
      description: 'Music',
      priority: TaskPriority.high,
    ),
    const TaskModel(
      title: 'Call Jonathan',
      description: 'Home',
      priority: TaskPriority.high,
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    log("rebuild");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Todos',
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ),
      body: ReorderableListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return TaskTile(
              key: ValueKey(index),
              task: taskList[index],
              onDelete: () {
                setState(() {
                  taskList.removeAt(index);
                });
              },
              onListReorder: (value) {
                setState(() {
                  final updateItem =
                      taskList[index].copyWith(isCompleted: value ?? false);
                  taskList.removeAt(index);
                  taskList.insert(index, updateItem);
                });
              });
        },
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = taskList.removeAt(oldIndex);
            taskList.insert(newIndex, item);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        onPressed: () async {
          AppWidgetHelper.showBottomSheet(context, child: const AddNewTask());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
