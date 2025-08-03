import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/config/theme/cubit/theme_cubit.dart';
import 'package:todoapp/config/theme/get_theme.dart';
import 'package:todoapp/helper/empty_data.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/extensions.dart';
import 'package:todoapp/helper/full_btn.dart';
import 'package:todoapp/helper/loading_indicator.dart';
import 'package:todoapp/helper/widget_helper.dart';
import 'package:todoapp/src/components/appearance.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/components/date_picker.dart';
import 'package:todoapp/src/home/presentation/components/filtered_chip_ui.dart';
import 'package:todoapp/src/home/presentation/components/task_list.dart';
import 'package:todoapp/src/home/presentation/task_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = "/home";

  static GoRoute route() {
    return GoRoute(
        path: Home.routeName,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: Home());
        });
  }

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // bloc
  late final TaskBloc taskBloc;

  final List<TaskModel> taskList = [];

  // to update task
  int _selectedIndex = 0;

  final ScrollController scrollController = ScrollController();

  // lables for Filter UI
  final String _isActive = "Active";
  final String _isCompleted = "Completed";
  final String _sortDate = "Date Ascending";
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  // selected Filters
  final _filterOptions = <String>[];

  // to pass filterd argument
  final FilterTaskModel filterTaskModel = FilterTaskModel();

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
        title: const Text('Home'),
        actions: [
          // theme toggle
          IconButton(
              onPressed: () {
                AppWidgetHelper.showBottomSheet(context,
                    child: const Appearance());
              },
              icon: const Icon(Icons.sunny)),

          //  date filter
          IconButton(
              onPressed: _filterByDate, icon: const Icon(Icons.date_range)),
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
              AppWidgetHelper.showBottomToast(context, state.errorMessage,
                  isFailure: true);
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
              AppliedFilterChips(filterOptions: _filterOptions),

              // Task List UI
              Expanded(
                  child: taskList.isEmpty
                      ? const EmptyData()
                      : TaskListView(
                          taskList: taskList,
                          scrollController: scrollController,
                          onTap: (task, index) async {
                            _selectedIndex = index;
                            await context.push(TaskDetail.taskDetailRoute,
                                extra: TaskDetailArgs(
                                    index: index,
                                    isNewTask: false,
                                    isViewOnly: true,
                                    taskModel: task));
                          },
                          onEdit: (task, index) async {
                            _selectedIndex = index;
                            await context
                                .push(TaskDetail.taskDetailRoute,
                                    extra: TaskDetailArgs(
                                        index: index,
                                        isNewTask: false,
                                        taskModel: task))
                                .whenComplete(() => _selectedIndex = 0);
                          },
                          onDelete: (task, index) {
                            _selectedIndex = index;
                            taskBloc.add(DeleteTask(id: task.id));
                          }))
            ]);
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final data = await context.push(TaskDetail.taskDetailRoute);

            log(data.toString());

            // scrollController.animateTo(scrollController.position.maxScrollExtent,
            //     duration: const Duration(seconds: 3), curve: Curves.easeIn);
          },
          child: const Icon(Icons.add)),
    );
  }

  void _filterByDate() {
    AppWidgetHelper.showBottomSheet(context,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return StatefulBuilder(builder: (context, myState) {
          return Container(
              color: helperBoxColor(state),
              padding: const EdgeInsets.all(kPaddingRegular),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          _clearDateFilter();
                          filterTaskModel.fromDateTime = null;
                          filterTaskModel.toDateTime = null;

                          taskBloc.add(
                              FilterTask(filterTaskModel: filterTaskModel));
                        },
                        child: const Text("Clear"))
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: DatePickerField(
                          selectedDate: fromDateTime,
                          onDateSelected: (date) {
                            myState(() => fromDateTime = date!);
                          })),
                  Expanded(
                      child: DatePickerField(
                          selectedDate: toDateTime,
                          onDateSelected: (date) {
                            myState(() => toDateTime = date!);
                          }))
                ]),
                FullButton(
                    onPressed: () {
                      context.pop();

                      // validation
                      if (toDateTime.isBefore(fromDateTime)) {
                        fromDateTime = DateTime.now();
                        toDateTime = DateTime.now();

                        AppWidgetHelper.showBottomToast(
                            context, "Inavlid Date Selection",
                            isFailure: true);
                        return;
                      }

                      _clearDateFilter();

                      _addDateFilter();

                      if (_filterOptions.isNotEmpty) {
                        taskBloc
                            .add(FilterTask(filterTaskModel: filterTaskModel));
                        return;
                      }

                      taskBloc.add(const FetchAllTask());
                    },
                    child: const Text("Apply"))
              ]));
        });
      },
    ));
  }

  // add date Filter
  void _addDateFilter() {
    filterTaskModel.fromDateTime = fromDateTime;
    filterTaskModel.toDateTime = toDateTime;

    _filterOptions.addAll([
      fromDateTime.formateDate(prefix: "From:"),
      toDateTime.formateDate(prefix: "To:")
    ]);
  }

  /// Filter Option UI
  _handleFilterOptions() {
    AppWidgetHelper.showBottomSheet(context,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return StatefulBuilder(builder: (context, myState) {
          return Container(
              color: helperBoxColor(state),
              padding: const EdgeInsets.all(kPaddingRegular),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // active
                ListTile(
                    onTap: () {
                      myState(() {
                        filterTaskModel.isActive =
                            _toggleFilterOptions(_isActive);
                      });
                    },
                    title: const Text("Active"),
                    trailing: (filterTaskModel.isActive ?? false)
                        ? const Icon(CupertinoIcons.check_mark)
                        : null),

                // completed
                ListTile(
                    onTap: () {
                      myState(() {
                        filterTaskModel.isCompleted =
                            _toggleFilterOptions(_isCompleted);
                      });
                    },
                    title: const Text("Completed"),
                    trailing: (filterTaskModel.isCompleted ?? false)
                        ? const Icon(CupertinoIcons.check_mark)
                        : null),

                // sort date
                ListTile(
                    onTap: () {
                      myState(() {
                        filterTaskModel.sortDate =
                            _toggleFilterOptions(_sortDate);
                      });
                    },
                    title: const Text("Sort by date in ascending"),
                    trailing: (filterTaskModel.sortDate ?? false)
                        ? const Icon(CupertinoIcons.check_mark)
                        : null),
                FullButton(
                    onPressed: () {
                      context.pop();

                      // only filter if no any filter options
                      if (_filterOptions.isNotEmpty) {
                        taskBloc
                            .add(FilterTask(filterTaskModel: filterTaskModel));
                        return;
                      }

                      taskBloc.add(const FetchAllTask());
                    },
                    child: const Text("Apply"))
              ]));
        });
      },
    ));
  }

  /// Toggle option selection
  bool? _toggleFilterOptions(String value) {
    if (_filterOptions.contains(value)) {
      _filterOptions.remove(value);
      return null;
    }
    _filterOptions.add(value);
    return true;
  }

  /// Handle Task List UI
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

  /// Clear date filter
  void _clearDateFilter() {
    _filterOptions.removeWhere((option) {
      return option ==
              filterTaskModel.fromDateTime!.formateDate(prefix: "From:") ||
          option == filterTaskModel.toDateTime!.formateDate(prefix: "To:");
    });
  }
}
