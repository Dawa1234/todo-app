import 'package:todoapp/src/home/data/model/task_model.dart';

abstract class TaskRepository {
  Future<TaskModel> addTask({required TaskModel taskModel});
  Future<TaskModel> editTask(
      {required int index, required TaskModel taskModel});
  Future<void> deleteTask({required String id});
  Future<List<TaskModel>> fetchAllTask();
  Future<TaskModel> fetchTaskDetail({required String id});
  Future<List<TaskModel>> filterTask({
    bool? sortTime,
    String? fromDate,
    String? toDate,
    bool? isCompleted,
    bool? isActive,
  });
  Future<void> deleteTaskInBulk({required List<String> ids});
  Future<void> deleteAllTask();
}
