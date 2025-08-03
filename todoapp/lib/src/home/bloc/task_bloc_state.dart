part of 'task_bloc.dart';

@immutable
sealed class TaskBlocState {
  const TaskBlocState();
}

// initial fetch
final class TaskFetching extends TaskBlocState {}

// when changes made in task
final class TaskUpdating extends TaskBlocState {}

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
  final TaskUpdateStatus taskUpdateStatus;
  final TaskModel newTask;

  const TaskUpdated({required this.taskUpdateStatus, required this.newTask});
}

// error/failure
final class TaskFetchError extends TaskBlocState {
  final String errorMessage;

  const TaskFetchError(this.errorMessage);
}

// error/failure
final class TaskUpdateError extends TaskBlocState {
  final String errorMessage;

  const TaskUpdateError(this.errorMessage);
}
