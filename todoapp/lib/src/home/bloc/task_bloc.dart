// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/data/repository/task_repo_impl.dart';

part 'task_bloc_event.dart';
part 'task_bloc_state.dart';

class TaskBloc extends Bloc<TaskBlocEvent, TaskBlocState> {
  final _taskRepositoryImpl = TaskRepositoryImpl();
  TaskBloc() : super(TaskFetching()) {
    on<AddTask>(_addTask);
    on<EditTask>(_editTask);
    on<DeleteTask>(_deleteTask);
    on<FetchAllTask>(_fetchAllTask);
    on<FetchTaskDetail>(_fetchTaskDetail);
    on<DeleteTaskInBulk>(_deleteTaskInBulk);
    on<DeleteAllTask>(_deleteAllTask);
  }

  Future<void> _addTask(AddTask event, Emitter emit) async {
    emit(TaskUpdating());
    try {
      final newTask =
          await _taskRepositoryImpl.addTask(taskModel: event.taskModel);

      await Future.delayed(const Duration(seconds: 2));
      emit(TaskUpdated(
          taskUpdateStatus: TaskUpdateStatus.added, newTask: newTask));
    } catch (e) {
      emit(TaskUpdateError(e.toString()));
    }
  }

  Future<void> _editTask(EditTask event, Emitter emit) async {
    emit(TaskUpdating());
    try {
      final newTask =
          await _taskRepositoryImpl.editTask(taskModel: event.taskModel);

      await Future.delayed(const Duration(seconds: 2));
      emit(TaskUpdated(
          taskUpdateStatus: TaskUpdateStatus.edited, newTask: newTask));
    } catch (e) {
      emit(TaskUpdateError(e.toString()));
    }
  }

  Future<void> _deleteTask(DeleteTask event, Emitter emit) async {
    emit(TaskUpdating());
    try {
      final taskList = await _taskRepositoryImpl.fetchAllTask();

      emit(TaskListFetched(taskList: taskList));
    } catch (e) {
      emit(TaskUpdateError(e.toString()));
    }
  }

  // Fetch All Task
  Future<void> _fetchAllTask(FetchAllTask event, Emitter emit) async {
    emit(TaskFetching());
    try {
      final taskList = await _taskRepositoryImpl.fetchAllTask();

      emit(TaskListFetched(taskList: taskList));
    } catch (e) {
      emit(TaskFetchError(e.toString()));
    }
  }

  Future<void> _fetchTaskDetail(FetchTaskDetail event, Emitter emit) async {
    emit(TaskFetching());
    try {
      final taskList = await _taskRepositoryImpl.fetchAllTask();

      emit(TaskListFetched(taskList: taskList));
    } catch (e) {
      emit(TaskFetchError(e.toString()));
    }
  }

  Future<void> _deleteTaskInBulk(DeleteTaskInBulk event, Emitter emit) async {
    emit(TaskUpdating());
    try {
      final taskList = await _taskRepositoryImpl.fetchAllTask();

      emit(TaskListFetched(taskList: taskList));
    } catch (e) {
      emit(TaskUpdateError(e.toString()));
    }
  }

  Future<void> _deleteAllTask(DeleteAllTask event, Emitter emit) async {
    emit(TaskUpdating());
    try {
      final taskList = await _taskRepositoryImpl.fetchAllTask();

      emit(TaskListFetched(taskList: taskList));
    } catch (e) {
      emit(TaskUpdateError(e.toString()));
    }
  }
}
