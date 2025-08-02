import 'package:todoapp/helper/enums.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final bool isCompleted;
  final bool isActive;
  final TaskPriority priority;

  const TaskModel(
      {this.id = "",
      this.title = "",
      this.description = "",
      this.createdAt,
      this.isCompleted = false,
      this.isActive = false,
      this.priority = TaskPriority.low});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"] ?? DateTime.now(),
        isCompleted: json["isCompleted"],
        isActive: json["isActive"],
        priority: json["priority"]);
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
    bool? isActive,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
    );
  }
}
