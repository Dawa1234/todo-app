import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/helper/empty_data.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/loading_indicator.dart';
import 'package:todoapp/service/endpoints.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/components/task_tile.dart';
import 'package:todoapp/src/home/presentation/task_detail.dart';

class ViewTaskList extends StatefulWidget {
  const ViewTaskList({super.key});

  static const String routeName = "/home2";

  static GoRoute route() {
    return GoRoute(
        path: ViewTaskList.routeName,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ViewTaskList());
        });
  }

  @override
  State<ViewTaskList> createState() => _HomePageState();
}

class _HomePageState extends State<ViewTaskList> {
  late final TaskBloc taskBloc;

  final List<TaskModel> taskList = [];
  int _editedIndex = 0;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context)..add(const FetchAllTask());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Todos',
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold)),

        actions: [
          TextButton(
              onPressed: () async {
                final data = await HiveCache.get(EndPoints.fetchAllTask);
                log(data.toString());
              },
              child: const Text("Retry"))
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskBlocState>(
          listener: (context, state) {
            // initial fetch
            if (state is TaskUpdating) LoadingIndicator.showProgress(context);

            if (state is TaskListFetched) taskList.addAll(state.taskList);

            if (state is TaskUpdated) {
              context.pop();
              _handleTaskList(state);
            }

            if (state is TaskUpdateError) {
              context.pop();
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red));
            }
          },
          bloc: taskBloc,
          builder: (context, state) {
            if (state is TaskFetching) const Text("Loading....");

            if (state is TaskFetchError) return Text(state.errorMessage);

            if (taskList.isEmpty) return const EmptyData();

            return ReorderableListView.builder(
                scrollController: scrollController,
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                      key: ValueKey(index),
                      task: taskList[index],
                      onTap: () async {
                        _editedIndex = index;
                        await context
                            .push(TaskDetail.taskDetailRoute,
                                extra: TaskDetailArgs(
                                    isNewTask: false,
                                    taskModel: taskList[index]))
                            .whenComplete(() => _editedIndex = 0);
                        log(_editedIndex.toString());
                      },
                      onDelete: (taskModel) {},
                      onEdit: (taskModel) {},
                      onListReorder: (value) {
                        setState(() {
                          final updateItem = taskList[index]
                              .copyWith(isCompleted: value ?? false);
                          taskList.removeAt(index);
                          taskList.insert(index, updateItem);
                        });
                      });
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = taskList.removeAt(oldIndex);
                    taskList.insert(newIndex, item);
                  });
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          taskBloc.add(
              const AddTask(taskModel: TaskModel(priority: TaskPriority.high)));
          // final data = await context.push(TaskDetail.taskDetailRoute);

          // log(data.toString());

          // scrollController.animateTo(scrollController.position.maxScrollExtent,
          //     duration: const Duration(seconds: 3), curve: Curves.easeIn);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _handleTaskList(TaskUpdated state) {
    switch (state.taskUpdateStatus) {
      case TaskUpdateStatus.added:
        taskList.add(state.newTask);
        break;

      case TaskUpdateStatus.edited:
        taskList.removeAt(_editedIndex);
        taskList.insert(_editedIndex, state.newTask);
        break;

      case TaskUpdateStatus.deleted:
        taskList.removeAt(_editedIndex);
        break;

      case TaskUpdateStatus.deletedAll:
        taskList.clear();
        break;

      case TaskUpdateStatus.deletedInBulk:
        // taskList.removeRange();
        break;

      default:
        break;
    }
  }
}
