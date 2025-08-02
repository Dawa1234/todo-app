part of 'task_bloc.dart';

@immutable
sealed class TaskBlocEvent {
  const TaskBlocEvent();
}

// add task
class AddTask extends TaskBlocEvent {
  final TaskModel taskModel;

  const AddTask({required this.taskModel});
}

// edit task
class EditTask extends TaskBlocEvent {
  final TaskModel taskModel;

  const EditTask({required this.taskModel});
}

// delete task
class DeleteTask extends TaskBlocEvent {
  final String id;

  const DeleteTask({required this.id});
}

// fetch all task
class FetchAllTask extends TaskBlocEvent {
  const FetchAllTask();
}

// fetch task detail
class FetchTaskDetail extends TaskBlocEvent {
  final String id;
  const FetchTaskDetail({required this.id});
}

// delete task in bulk
class DeleteTaskInBulk extends TaskBlocEvent {
  final List<String> ids;

  const DeleteTaskInBulk({required this.ids});
}

// delete all tasks
class DeleteAllTask extends TaskBlocEvent {
  const DeleteAllTask();
}
