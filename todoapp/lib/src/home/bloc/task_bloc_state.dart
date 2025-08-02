part of 'task_bloc.dart';

@immutable
sealed class TaskBlocState {
  const TaskBlocState();
}

// initial
final class TaskBlocInitial extends TaskBlocState {}

// loading
final class TaskLoading extends TaskBlocState {}

// fetch detail
final class TaskDetailFetched extends TaskBlocState {
  final TaskModel task;

  const TaskDetailFetched({required this.task});
}

// fetch list
final class TaskListFetched extends TaskBlocState {
  final List<TaskModel> taskList;

  const TaskListFetched({required this.taskList});
}

// update a task
final class TaskUpdated extends TaskBlocState {
  final TaskUpdated task;

  const TaskUpdated({required this.task});
}

// error/failure
final class TaskUpdateFailed extends TaskBlocState {
  final String errorMessage;

  const TaskUpdateFailed(this.errorMessage);
}
