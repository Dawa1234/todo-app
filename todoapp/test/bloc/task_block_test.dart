import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoapp/core/service_locator.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/service/dio/dio_manager.dart';
import 'package:todoapp/service/server_config.dart';
import 'package:todoapp/src/home/bloc/task_bloc.dart';
import 'package:todoapp/src/home/data/model/task_model.dart';

import '../mock/mock_task_repo.dart';

Future<void> setUpTestEnvironment(ServerConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveCache.init(); // Optional
  await setUpLocator(); // Your get_it setup

  DioManager.init(config); // Use FakeTestConfig here
}

void main() {
  late TaskBloc taskBloc;
  late MockTaskRepository mockRepo;

  final mockTasks = [
    const TaskModel(id: "1", title: 'Task 1'),
    const TaskModel(id: "2", title: 'Task 2')
  ];

  setUpAll(() async {
    registerFallbackValue(FilterTaskModel());
    await setUpTestEnvironment(TestServerConfig()); // custom test config
  });

  setUp(() {
    mockRepo = MockTaskRepository();
    taskBloc = TaskBloc();
  });

  tearDown(() => taskBloc.close());

  group('TaskBloc bloc_test', () {
    // 1️⃣ Fetch All Tasks
    blocTest<TaskBloc, TaskBlocState>(
      'emits [TaskFetching, TaskListFetched] when FetchAllTask is added',
      build: () {
        when(() => mockRepo.fetchAllTask()).thenAnswer((_) async => mockTasks);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const FetchAllTask()),
      expect: () => [
        isA<TaskFetching>(),
        isA<TaskListFetched>().having((e) => e.taskList.length, 'task count', 2)
      ],
    );

    // 2️⃣ Filter Tasks
    blocTest<TaskBloc, TaskBlocState>(
      'emits [TaskUpdating, TaskListFiltered] when FilterTask is added',
      build: () {
        when(() => mockRepo.filterTask(filterTaskModel: FilterTaskModel()))
            .thenAnswer((_) async => [mockTasks.first]);
        return taskBloc;
      },
      act: (bloc) => bloc.add(FilterTask(filterTaskModel: FilterTaskModel())),
      expect: () => [
        isA<TaskUpdating>(),
        isA<TaskListFiltered>()
            .having((e) => e.taskList.length, 'filtered count', 0)
      ],
    );

    // 3️⃣ Handle fetch error
    blocTest<TaskBloc, TaskBlocState>(
        'emits [TaskFetching, TaskFetchError] when repository throws error',
        build: () {
          when(() => mockRepo.fetchAllTask())
              .thenThrow(Exception('Fetch failed'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const FetchAllTask()),
        expect: () => [
              isA<TaskFetching>(),
              isA<TaskFetchError>().having(
                  (e) => e.errorMessage, 'message', contains('Fetch failed')),
            ]);
  });
}
