import 'package:todoapp/src/home/data/model/task_model.dart';

abstract class TaskRepository {
  Future<void> addTask({required TaskModel taskModel});
  Future<TaskModel> editTask({required TaskModel taskModel});
  Future<void> deleteTask({required String id});
  Future<List<TaskModel>> fetchAllTask();
  Future<TaskModel> fetchTaskDetail({required String id});
  Future<void> deleteTaskInBulk({required List<String> ids});
  Future<void> deleteAllTask();
}
