import 'package:todoapp/service/dio/dio_manager.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/data/repository/task_repo.dart';

//
class TaskRepositoryImpl implements TaskRepository {
  final DioManager dioManager = DioManager();

  @override
  Future<void> addTask({required TaskModel taskModel}) {
    // dioManager.dio.get(path);
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> editTask({required TaskModel taskModel}) {
    // TODO: implement editTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask({required String id}) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> fetchAllTask() async {
    return <TaskModel>[];
  }

  @override
  Future<TaskModel> fetchTaskDetail({required String id}) {
    // TODO: implement fetchTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTaskInBulk({required List<String> ids}) {
    // TODO: implement deleteTaskInBulk
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllTask() {
    // TODO: implement deleteAllTask
    throw UnimplementedError();
  }
}
