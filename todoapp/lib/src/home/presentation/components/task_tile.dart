import 'package:flutter/material.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final void Function(bool?)? onListReorder;
  final VoidCallback onDelete;
  const TaskTile({
    super.key,
    required this.task,
    required this.onListReorder,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: InkWell(
                onTap: onDelete,
                child: const Icon(Icons.cancel, color: Colors.grey)),
            title: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(task.description),
              Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority.toString()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(task.priority.toString(),
                      style: TextStyle(
                          color:
                              _getPriorityTextColor(task.priority.toString()),
                          fontSize: 12)))
            ]),
            trailing:
                Checkbox(value: task.isCompleted, onChanged: onListReorder)));
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.purple.shade100;
      case 'low':
        return Colors.blue.shade100;
      default:
        return Colors.transparent;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.purple;
      case 'low':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
