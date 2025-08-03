import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/config/default_size.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/helper/loading_indicator.dart';
import 'package:todoapp/helper/sized_box.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';
import 'package:todoapp/src/home/presentation/components/date_picker.dart';
import 'package:uuid/uuid.dart';

// Object as an argument
class TaskDetailArgs {
  final bool isNewTask;
  final TaskModel? taskModel;

  const TaskDetailArgs({this.isNewTask = true, this.taskModel});
}

class TaskDetail extends StatefulWidget {
  final bool isNewTask;
  final TaskModel? taskModel;
  const TaskDetail({
    super.key,
    this.isNewTask = true,
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
                  isNewTask: args.isNewTask, taskModel: args.taskModel));
        });
  }

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late final TaskModel? taskModel;

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

    _titleController = TextEditingController(text: taskModel?.title);
    _descriptionController =
        TextEditingController(text: taskModel?.description);
    _selectedPriority = taskModel?.priority ?? TaskPriority.low;
    _isActive = taskModel?.isActive ?? false;
    _isCompleted = taskModel?.isCompleted ?? false;
    _dateTime = taskModel?.createdAt ?? DateTime.now();

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
            title: widget.isNewTask
                ? const Text("Add New Task")
                : const Text("Edit Task")),
        body: BlocListener<TaskBloc, TaskBlocState>(
            bloc: taskBloc,
            listener: (context, state) {
              if (state is TaskUpdating) LoadingIndicator.showProgress(context);
              if (state is TaskUpdated) {
                context.pop();
                context.pop("123");
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(kPaddingRegular),
                child: Column(children: [
                  // title
                  TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          suffixIcon: IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: const Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  size: 20)),
                          contentPadding: const EdgeInsets.all(kPaddingSmall),
                          hintText: "Enter Title")),
                  sizedBoxhgth10,

                  // description
                  TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          contentPadding: const EdgeInsets.all(kPaddingSmall),
                          hintText: "Enter Title")),
                  sizedBoxhgth10,

                  // priority
                  DropdownButtonFormField<TaskPriority>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Priority',
                        border: const OutlineInputBorder(),
                      ),
                      items: priorities.map((priority) {
                        final label = (priority['value'] as TaskPriority).name;
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
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value ?? TaskPriority.low;
                        });
                      }),

                  sizedBoxhgth10,

                  CheckboxListTile(
                      tileColor: Colors.grey.shade200,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("Active"),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() => _isActive = value!);
                      }),

                  sizedBoxhgth10,

                  CheckboxListTile(
                      tileColor: Colors.grey.shade200,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("Completed"),
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() => _isCompleted = value!);
                      }),

                  sizedBoxhgth30,

                  DatePickerField(
                      selectedDate: _dateTime,
                      onDateSelected: (date) {
                        setState(() {
                          _dateTime = date ?? DateTime.now();
                        });
                      }),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: _handleForm,
                        child: widget.isNewTask
                            ? const Text("Add Task")
                            : const Text("Edit Task")),
                  )
                ]))));
  }

  void _handleForm() {
    final TaskModel newTask;
    if (widget.isNewTask) {
      newTask = TaskModel(
          id: const Uuid().v4(),
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
    taskBloc.add(EditTask(taskModel: newTask));
  }
}

final List<TaskModel> taskList = [
  const TaskModel(
    title: 'Pay for utility services',
    description: 'Home',
    priority: TaskPriority.medium,
  ),
  const TaskModel(
    title: 'Buy groceries for mac & cheese',
    description: 'Food',
    priority: TaskPriority.low,
  ),
  const TaskModel(
    title: 'Practice Piano',
    description: 'Music',
    priority: TaskPriority.high,
  ),
  const TaskModel(
    title: 'Call Jonathan',
    description: 'Home',
    priority: TaskPriority.high,
    isCompleted: true,
  ),
];
