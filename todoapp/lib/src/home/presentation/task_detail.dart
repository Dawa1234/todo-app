import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/config/theme/cubit/theme_cubit.dart';
import 'package:todoapp/config/theme/get_theme.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/sized_box.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/components/date_picker.dart';

// Object as an argument
class TaskDetailArgs {
  final int index;
  final bool isNewTask;
  final bool isViewOnly;
  final TaskModel? taskModel;

  const TaskDetailArgs(
      {this.index = 0,
      this.isNewTask = true,
      this.isViewOnly = false,
      this.taskModel});
}

class TaskDetail extends StatefulWidget {
  final int index;
  final bool isNewTask;
  final bool isViewOnly;
  final TaskModel? taskModel;
  const TaskDetail({
    super.key,
    this.index = 0,
    this.isNewTask = true,
    this.isViewOnly = false,
    this.taskModel,
  });

  static const String taskDetailRoute = "/taskDetailRoute";

  static GoRoute route() {
    return GoRoute(
        path: taskDetailRoute,
        pageBuilder: (context, state) {
          final args = state.extra != null
              ? (state.extra as TaskDetailArgs)
              : const TaskDetailArgs();

          return CupertinoPage(
              child: TaskDetail(
                  index: args.index,
                  isNewTask: args.isNewTask,
                  isViewOnly: args.isViewOnly,
                  taskModel: args.taskModel));
        });
  }

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late final TaskModel? taskModel;

  final _formKey = GlobalKey<FormState>();

  // formData
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  late bool _isActive;
  late bool _isCompleted;
  late DateTime _dateTime;

  // bloc
  late final TaskBloc taskBloc;

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context);

    taskModel = widget.taskModel;

    _initData();

    super.initState();
  }

  final List<Map<String, dynamic>> priorities = [
    {'value': TaskPriority.low, 'color': Colors.blue},
    {'value': TaskPriority.medium, 'color': Colors.orange},
    {'value': TaskPriority.high, 'color': Colors.red}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: widget.isViewOnly
                ? const Text("Task Detail")
                : widget.isNewTask
                    ? const Text("Add New Task")
                    : const Text("Edit Task")),
        body: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final theme = getTheme(themeMode, context);
            return BlocListener<TaskBloc, TaskBlocState>(
                bloc: taskBloc,
                listener: (context, state) {
                  if (state is TaskUpdated) {
                    context.pop("123");
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.all(kPaddingRegular),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        // title
                        TextFormField(
                            readOnly: widget.isViewOnly,
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*Required*";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                fillColor: helperBoxColor(theme),
                                filled: true,
                                suffixIcon: widget.isViewOnly
                                    ? null
                                    : IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: _titleController.clear,
                                        icon: const Icon(
                                            CupertinoIcons.clear_circled_solid,
                                            size: 20)),
                                contentPadding:
                                    const EdgeInsets.all(kPaddingSmall),
                                hintText: "Enter Title")),
                        sizedBoxhgth10,

                        // description
                        TextFormField(
                            readOnly: widget.isViewOnly,
                            controller: _descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*Required*";
                              }
                              return null;
                            },
                            maxLines: 4,
                            maxLength: 100,
                            decoration: InputDecoration(
                                fillColor: helperBoxColor(theme),
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.all(kPaddingSmall),
                                hintText: "Enter Title")),
                        sizedBoxhgth10,

                        // priority
                        DropdownButtonFormField<TaskPriority>(
                            value: _selectedPriority,
                            decoration: InputDecoration(
                                enabled: !widget.isViewOnly,
                                filled: true,
                                fillColor: helperBoxColor(theme),
                                labelText: 'Priority',
                                border: const OutlineInputBorder()),
                            items: priorities.map((priority) {
                              final label =
                                  (priority['value'] as TaskPriority).name;
                              return DropdownMenuItem<TaskPriority>(
                                  value: priority['value'],
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(label.toUpperCase()),
                                        sizedBoxWdth5,
                                        Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                                color: priority['color'],
                                                borderRadius:
                                                    BorderRadius.circular(5)))
                                      ]));
                            }).toList(),
                            onChanged: widget.isViewOnly
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedPriority =
                                          value ?? TaskPriority.low;
                                    });
                                  }),

                        sizedBoxhgth10,

                        // option
                        _checkBoxTile(
                            themeMode: theme,
                            title: "Active",
                            value: _isActive,
                            onChanged: (value) {
                              setState(() => _isActive = value!);
                            }),

                        sizedBoxhgth10,

                        // option
                        _checkBoxTile(
                            themeMode: theme,
                            value: _isCompleted,
                            title: "Completed",
                            onChanged: (value) {
                              setState(() => _isCompleted = value!);
                            }),

                        sizedBoxhgth30,

                        // date picker
                        DatePickerField(
                            selectedDate: _dateTime,
                            isViewOnly: widget.isViewOnly,
                            onDateSelected: (date) {
                              setState(() {
                                _dateTime = date ?? DateTime.now();
                              });
                            }),

                        const Spacer(),

                        if (!widget.isViewOnly)
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: _handleForm,
                                  child: widget.isNewTask
                                      ? const Text("Add Task")
                                      : const Text("Edit Task")))
                      ]),
                    )));
          },
        ));
  }

  CheckboxListTile _checkBoxTile(
      {required ThemeMode themeMode,
      bool? value,
      required String title,
      void Function(bool?)? onChanged}) {
    return CheckboxListTile(
        enabled: !widget.isViewOnly,
        tileColor: helperBoxColor(themeMode),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(title),
        value: value,
        onChanged: onChanged);
  }

  /// initialize data
  _initData() {
    _titleController = TextEditingController(text: taskModel?.title);
    _descriptionController =
        TextEditingController(text: taskModel?.description);
    _selectedPriority = taskModel?.priority ?? TaskPriority.low;
    _isActive = taskModel?.isActive ?? false;
    _isCompleted = taskModel?.isCompleted ?? false;
    _dateTime = taskModel?.createdAt ?? DateTime.now();
  }

  // submit form
  void _handleForm() {
    final TaskModel newTask;
    if (_formKey.currentState!.validate()) {
      if (widget.isNewTask) {
        newTask = TaskModel(
            title: _titleController.text,
            description: _descriptionController.text,
            createdAt: _dateTime,
            isActive: _isActive,
            isCompleted: _isCompleted,
            priority: _selectedPriority);

        taskBloc.add(AddTask(taskModel: newTask));
        return;
      }

      newTask = taskModel!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: _dateTime,
          isActive: _isActive,
          isCompleted: _isCompleted,
          priority: _selectedPriority);

      taskBloc.add(EditTask(index: widget.index, taskModel: newTask));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
