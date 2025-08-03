import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final void Function(bool?)? onListReorder;
  final void Function()? onTap;
  final void Function(TaskModel taskModel)? onDelete;
  final void Function(TaskModel taskModel)? onEdit;
  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    required this.onListReorder,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: kPaddingSmall),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          // await showMenu(
          //     context: context,
          //     position: RelativeRect.fromLTRB(
          //         details.globalPosition.dx,
          //         details.globalPosition.dy,
          //         details.globalPosition.dx,
          //         details.globalPosition.dy),
          //     items: [
          //       PopupMenuItem(
          //         child: const Text("Edit"),
          //         onTap: () {
          //           onEdit?.call(task);
          //         },
          //       ),
          //       PopupMenuItem(
          //         onTap: () {
          //           onDelete?.call(task);
          //         },
          //         child: const Text("Delete"),
          //       ),
          //     ]);
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
                  children: [Text(task.description)]),
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
