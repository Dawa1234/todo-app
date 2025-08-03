import 'dart:convert';

import 'package:todoapp/core/service_locator.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/service/dio/dio_api_base.dart';
import 'package:todoapp/service/dio/dio_manager.dart';
import 'package:todoapp/service/endpoints.dart';
import 'package:todoapp/service/error_handler.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/data/repository/task_repo.dart';
import 'package:uuid/uuid.dart';

//
class TaskRepositoryImpl implements TaskRepository {
  final _dio = getIt<DioManager>().dio;

  @override
  Future<TaskModel> addTask({required TaskModel taskModel}) async {
    try {
      final responseData =
          taskModel.copyWith(id: const Uuid().v4(), createdAt: DateTime.now());
      final taskList = <Map<String, dynamic>>[];

      // act as a post api for now
      final cacheData = await HiveCache.get(EndPoints.fetchAllTask);

      // if no cached Data
      if (cacheData == null) {
        // create new
        taskList.add(responseData.toJson());
      } else {
        // update cache
        final taskListModel = TaskListModel.fromJson(cacheData);
        taskListModel.taskList.add(responseData);
        taskList.addAll(taskListModel.toJsonList());
      }

      // dummy response
      final Map<String, dynamic> data = {"data": taskList};

      await HiveCache.save(EndPoints.fetchAllTask, data);

      // API CALL
      // final response = await DioApiBase.apiBase(
      //     path: EndPoints.addTask,
      //     method: RequestMethod.POST,
      //     apiCall:
      //         _dio.post(EndPoints.addTask, data: {"data": taskModel.toJson()}));

      if (responseData is ErrorModel) {
        throw (responseData as ErrorModel).message;
      }

      return responseData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<TaskModel> editTask({required TaskModel taskModel}) async {
    /// act as a post api for now
    await HiveCache.save(EndPoints.addTask, jsonEncode(taskModel.toJson()));
    final response = await HiveCache.get(EndPoints.addTask);
    // final response = await DioApiBase.apiBase(
    //     path: EndPoints.addTask,
    //     method: _dio.options.method,
    //     apiCall:
    //         _dio.post(EndPoints.addTask, data: {"data": taskModel.toJson()}));

    if (response is ErrorModel) throw (response as ErrorModel).message;

    return taskModel;
  }

  @override
  Future<void> deleteTask({required String id}) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> fetchAllTask() async {
    /// act as a post api for now
    // await HiveCache.save(EndPoints.addTask, jsonEncode(taskModel.toJson()));
    // final response = await HiveCache.get(EndPoints.addTask);
    final response = await DioApiBase.apiBase(
        path: EndPoints.fetchAllTask,
        method: RequestMethod.GET,
        apiCall: _dio.get(EndPoints.fetchAllTask));

    response.runtimeType;

    if (response is ErrorModel) throw response.message;

    final responseData = TaskListModel.fromJson(response);

    return responseData.taskList;
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
