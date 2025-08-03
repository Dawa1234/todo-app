import 'package:flutter/cupertino.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/helper/sized_box.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/components/task_tile.dart';

class TaskListView extends StatelessWidget {
  final List<TaskModel> taskList;
  final ScrollController scrollController;
  final void Function(TaskModel task, int index) onTap;
  final void Function(TaskModel task, int index) onEdit;
  final void Function(TaskModel task, int index) onDelete;

  const TaskListView(
      {super.key,
      required this.taskList,
      required this.scrollController,
      required this.onTap,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        controller: scrollController,
        itemCount: taskList.length,
        padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge, vertical: kPaddingSmall),
        separatorBuilder: (_, __) => sizedBoxhgth10,
        itemBuilder: (context, index) {
          final task = taskList[index];
          return TaskTile(
              task: task,
              onTap: () => onTap(task, index),
              onDelete: () => onDelete(task, index),
              onEdit: () => onEdit(task, index));
        });
  }
}
