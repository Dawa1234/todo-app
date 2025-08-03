import 'dart:developer';

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
      final id = const Uuid().v4();
      final responseData = taskModel.copyWith(id: id, title: id);
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
  Future<TaskModel> editTask(
      {required int index, required TaskModel taskModel}) async {
    try {
      final responseData = <Map<String, dynamic>>[];
      // act as a post api for now
      final cacheData = await HiveCache.get(EndPoints.fetchAllTask);

      // update cache
      final taskListModel = TaskListModel.fromJson(cacheData ?? {'data': []});
      taskListModel.taskList.removeAt(index);
      taskListModel.taskList.insert(index, taskModel);
      responseData.addAll(taskListModel.toJsonList());

      // object to cache
      final Map<String, dynamic> data = {"data": responseData};

      await HiveCache.save(EndPoints.fetchAllTask, data);

      // API CALL
      // final response = await DioApiBase.apiBase(
      //     path: EndPoints.addTask,
      //     method: RequestMethod.PUT,
      //     apiCall:
      //         _dio.put(EndPoints.addTask, data: {"data": taskModel.toJson()}));

      final response = taskModel;

      if (response is ErrorModel) throw (response as ErrorModel).message;

      return response;
    } catch (_) {
      throw _.toString();
    }
  }

  @override
  Future<void> deleteTask({required String id}) async {
    try {
      final responseData = <Map<String, dynamic>>[];
      // act as a post api for now
      final cacheData = await HiveCache.get(EndPoints.fetchAllTask);
      final taskListModel = TaskListModel.fromJson(cacheData ?? {'data': []});

      // logic
      log("Received $id");
      final index = taskListModel.taskList.indexWhere((task) => task.id == id);
      taskListModel.taskList.removeAt(index);

      responseData.addAll(taskListModel.toJsonList());

      // object to cache
      final Map<String, dynamic> data = {"data": responseData};

      await HiveCache.save(EndPoints.fetchAllTask, data);

      // API CALL
      // final response = await DioApiBase.apiBase(
      //     path: EndPoints.addTask,
      //     method: RequestMethod.PUT,
      //     apiCall:
      //         _dio.put(EndPoints.addTask, data: {"data": taskModel.toJson()}));
    } catch (_) {
      throw _.toString();
    }
  }

  @override
  Future<List<TaskModel>> fetchAllTask() async {
    try {
      /// act as a post api for now
      // await HiveCache.save(EndPoints.addTask, jsonEncode(taskModel.toJson()));
      // final response = await HiveCache.get(EndPoints.addTask);
      final response = await DioApiBase.apiBase(
          path: EndPoints.fetchAllTask,
          method: RequestMethod.GET,
          apiCall: _dio.get(EndPoints.fetchAllTask));

      if (response is ErrorModel) throw response.message;

      final responseData = TaskListModel.fromJson(response ?? {"data": []});
      return responseData.taskList;
    } catch (_) {
      throw _.toString();
    }
  }

  @override
  Future<TaskModel> fetchTaskDetail({required String id}) async {
    try {
      /// act as a post api for now
      final response = await DioApiBase.apiBase(
          path: EndPoints.fetchTaskDetail,
          method: RequestMethod.GET,
          apiCall: _dio.get(EndPoints.fetchTaskDetail));

      if (response is ErrorModel) throw response.message;

      final responseData = TaskListModel.fromJson(response);

      final taskModel =
          responseData.taskList.firstWhere((task) => task.id == id);

      return taskModel;
    } catch (_) {
      throw _.toString();
    }
  }

  // filter/sort task
  @override
  Future<List<TaskModel>> filterTask(
      {required FilterTaskModel filterTaskModel}) async {
    try {
      // act as a post api for now
      final cacheData = await HiveCache.get(EndPoints.fetchAllTask);
      final taskListModel = TaskListModel.fromJson(cacheData ?? {'data': []});

      // Filter logic
      final filteredTask = taskListModel.taskList.where((task) {
        // filter completed
        final completed = filterTaskModel.isCompleted == null
            ? true
            : task.isCompleted == filterTaskModel.isCompleted;

        // filter active
        final active = filterTaskModel.isActive == null
            ? true
            : task.isActive == filterTaskModel.isActive;

        // filter date range
        final date = (filterTaskModel.fromDateTime == null ||
                filterTaskModel.toDateTime == null)
            ? true
            : !task.createdAt!.isBefore(filterTaskModel.fromDateTime!) &&
                !task.createdAt!.isAfter(filterTaskModel.toDateTime!);

        return completed && active && date;
      }).toList();

      // sort by date (ascending)
      if (filterTaskModel.sortDate ?? false) {
        filteredTask.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      }

      return filteredTask;
    } catch (_) {
      throw _.toString();
    }
  }

  @override
  Future<void> deleteTaskInBulk({required List<String> ids}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllTask() async {
    try {
      // API CALL
      // final response = await DioApiBase.apiBase(
      //     path: EndPoints.deleteAllTask,
      //     method: RequestMethod.POST,
      //     apiCall: _dio.post(EndPoints.fetchTaskDetail));

      final response = <String, dynamic>{};

      // act as a post api for now
      await HiveCache.delete(EndPoints.fetchAllTask);

      if (response is ErrorModel) throw (response as ErrorModel).message;
    } catch (_) {
      throw _.toString();
    }
  }
}
