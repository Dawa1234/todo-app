import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/helper/empty_data.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/full_btn.dart';
import 'package:todoapp/helper/loading_indicator.dart';
import 'package:todoapp/helper/sized_box.dart';
import 'package:todoapp/helper/widget_helper.dart';
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

  int _selectedIndex = 0;

  final ScrollController scrollController = ScrollController();

  final String _isActive = "Active";
  final String _isCompleted = "Completed";
  final String _sortDate = "Date Ascending";
  final String fromDateTime = "";
  final String toDateTime = "";

  final _filterOptions = <String>[];

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context)..add(const FetchAllTask());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _handleFilterOptions, icon: const Icon(Icons.sort)),
        elevation: 0,
        centerTitle: true,
        title: const Text('Todos',
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: () async {
                // await HiveCache.clear();
                taskBloc.add(const FetchAllTask());

                // log(DateTime.now().toString());
              },
              icon: const Icon(Icons.date_range)),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskBlocState>(
          bloc: taskBloc,
          listener: (context, state) {
            // initial fetch
            if (state is TaskUpdating) LoadingIndicator.showProgress(context);

            if (state is TaskListFetched) {
              taskList
                ..clear()
                ..addAll(state.taskList);
            }

            if (state is TaskUpdated) {
              context.pop();
              _handleTaskList(state);
            }

            if (state is TaskListFiltered) {
              context.pop();
              taskList
                ..clear()
                ..addAll(state.taskList);
            }

            if (state is TaskUpdateError) {
              context.pop();
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red));
            }
          },

          // UI
          builder: (context, state) {
            if (state is TaskFetching) {
              return const Center(child: Text("Loading...."));
            }

            if (state is TaskFetchError) return Text(state.errorMessage);

            return Column(children: [
              /// Applied Filter UI
              Row(
                  children: _filterOptions
                      .map((title) => Chip(label: Text(title)))
                      .toList()),

              // Task List UI
              Expanded(
                  child: taskList.isEmpty
                      ? const EmptyData()
                      : ListView.separated(
                          separatorBuilder: (_, __) => sizedBoxhgth10,
                          controller: scrollController,
                          itemCount: taskList.length,
                          itemBuilder: (context, index) {
                            return TaskTile(
                                // key: ValueKey(index),
                                task: taskList[index],
                                onTap: () async {
                                  _selectedIndex = index;

                                  await context
                                      .push(TaskDetail.taskDetailRoute,
                                          extra: TaskDetailArgs(
                                              index: index,
                                              isNewTask: false,
                                              taskModel: taskList[index]))
                                      .whenComplete(() => _selectedIndex = 0);
                                  log(_selectedIndex.toString());
                                },
                                onDelete: (taskModel) {
                                  _selectedIndex = index;
                                  // log(taskModel.id.toString());
                                  taskBloc.add(DeleteTask(id: taskModel.id));
                                },
                                onEdit: (taskModel) {
                                  log(taskModel.id.toString());
                                },
                                onListReorder: (value) {
                                  setState(() {
                                    final updateItem = taskList[index]
                                        .copyWith(isCompleted: value ?? false);
                                    taskList.removeAt(index);
                                    taskList.insert(index, updateItem);
                                  });
                                });
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          // onReorder: (oldIndex, newIndex) {
                          //   setState(() {
                          //     if (newIndex > oldIndex) newIndex--;
                          //     final item = taskList.removeAt(oldIndex);
                          //     taskList.insert(newIndex, item);
                          //   });
                          // }
                        ))
            ]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await context.push(TaskDetail.taskDetailRoute);

          log(data.toString());

          // scrollController.animateTo(scrollController.position.maxScrollExtent,
          //     duration: const Duration(seconds: 3), curve: Curves.easeIn);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _filterByDate() {
    AppWidgetHelper.showBottomSheet(context,
        child: StatefulBuilder(builder: (context, myState) {
      final bool? isActive = _filterOptions.contains(_isActive) ? true : null;
      final bool? isCompleted =
          _filterOptions.contains(_isCompleted) ? true : null;
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(kPaddingRegular),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () {
                  myState(() {
                    _toggleFilterOptions(_isActive);
                  });
                },
                title: const Text("Active"),
                trailing: (isActive ?? false)
                    ? const Icon(CupertinoIcons.check_mark)
                    : null),
            FullButton(
                onPressed: () {
                  context.pop();

                  if (_filterOptions.isNotEmpty) {
                    taskBloc.add(FilterTask(
                        isActive: isActive, isCompleted: isCompleted));
                    return;
                  }

                  taskBloc.add(const FetchAllTask());
                },
                child: const Text("Apply"))
          ],
        ),
      );
    }));
  }

  /// Only for Active / Completed
  _handleFilterOptions() {
    AppWidgetHelper.showBottomSheet(context,
        child: StatefulBuilder(builder: (context, myState) {
      final bool? isActive = _filterOptions.contains(_isActive) ? true : null;
      final bool? isCompleted =
          _filterOptions.contains(_isCompleted) ? true : null;
      final bool? sortTime = _filterOptions.contains(_sortDate) ? true : null;
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(kPaddingRegular),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () {
                  myState(() {
                    _toggleFilterOptions(_isActive);
                  });
                },
                title: const Text("Active"),
                trailing: (isActive ?? false)
                    ? const Icon(CupertinoIcons.check_mark)
                    : null),
            ListTile(
                onTap: () {
                  myState(() {
                    _toggleFilterOptions(_isCompleted);
                  });
                },
                title: const Text("Completed"),
                trailing: (isCompleted ?? false)
                    ? const Icon(CupertinoIcons.check_mark)
                    : null),
            ListTile(
                onTap: () {
                  myState(() {
                    _toggleFilterOptions(_sortDate);
                  });
                },
                title: const Text("Sort by date in ascending"),
                trailing: (sortTime ?? false)
                    ? const Icon(CupertinoIcons.check_mark)
                    : null),
            FullButton(
                onPressed: () {
                  context.pop();

                  if (_filterOptions.isNotEmpty) {
                    taskBloc.add(FilterTask(
                        isActive: isActive,
                        isCompleted: isCompleted,
                        sortDate: sortTime));
                    return;
                  }

                  taskBloc.add(const FetchAllTask());
                },
                child: const Text("Apply"))
          ],
        ),
      );
    }));
  }

  /// Toggle option selection
  _toggleFilterOptions(String value) {
    if (_filterOptions.contains(value)) {
      _filterOptions.remove(value);
      return;
    }
    _filterOptions.add(value);
  }

  _handleTaskList(TaskUpdated state) {
    switch (state.taskUpdateStatus) {
      case TaskUpdateStatus.added:
        taskList.add(state.newTask);
        break;

      case TaskUpdateStatus.edited:
        taskList.removeAt(_selectedIndex);
        taskList.insert(_selectedIndex, state.newTask);
        break;

      case TaskUpdateStatus.deleted:
        taskList.removeAt(_selectedIndex);
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
