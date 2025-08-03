import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/helper/enums.dart';

class TaskModel extends Equatable {
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
    late final TaskPriority priority;
    switch (json["priority"]) {
      case "low":
        priority = TaskPriority.low;
        break;
      case "medium":
        priority = TaskPriority.medium;
        break;
      case "high":
        priority = TaskPriority.high;
        break;
      default:
        priority = TaskPriority.low;
    }

    return TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"] != null
            ? DateFormat("dd-MM-yyyy HH:mm").parse(json["createdAt"])
            : DateTime.now(),
        isCompleted: json["isCompleted"],
        isActive: json["isActive"],
        priority: priority);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toString(),
      'isCompleted': isCompleted,
      'isActive': isActive,
      'priority': priority.name
    };
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

  @override
  List<Object?> get props =>
      [title, description, createdAt, isCompleted, isActive, priority];
}

class TaskListModel {
  final List<TaskModel> taskList;

  const TaskListModel({required this.taskList});

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
        taskList: json['data'] != null
            ? List.from(json['data'].map((task) => TaskModel.fromJson(task)))
            : []);
  }

  List<Map<String, dynamic>> toJsonList() {
    return taskList.map((task) => task.toJson()).toList();
  }

  TaskListModel copyWith({List<TaskModel>? taskList}) {
    return TaskListModel(
      taskList: taskList ?? this.taskList,
    );
  }
}
