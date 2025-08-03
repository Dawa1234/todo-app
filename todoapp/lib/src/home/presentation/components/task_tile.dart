import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/extensions.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final void Function()? onTap;
  final void Function()? onDelete;
  final void Function()? onEdit;
  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          onLongPressStart: (details) async => menu(context, details),
          child: ListTile(
              onTap: onTap,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: (kPaddingSmall + 2)),
              leading: Container(
                width: 20,
                decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority),
                    borderRadius: BorderRadius.circular(4)),
              ),
              title: Text(task.title),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${task.createdAt?.formateDate()}"),
                    Text(task.description)
                  ]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (task.isCompleted)
                    const Icon(CupertinoIcons.check_mark_circled_solid,
                        color: Colors.green),
                  if (task.isActive)
                    const Icon(CupertinoIcons.check_mark_circled_solid,
                        color: Colors.blue)
                ],
              )),
        ));
  }

  Future menu(BuildContext context, LongPressStartDetails details) async {
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy),
        items: [
          PopupMenuItem(onTap: onEdit, child: const Text("Edit")),
          PopupMenuItem(onTap: onDelete, child: const Text("Delete"))
        ]);
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;

      case TaskPriority.medium:
        return Colors.orange;

      case TaskPriority.low:
        return Colors.blue;

      default:
        return Colors.black;
    }
  }
}
