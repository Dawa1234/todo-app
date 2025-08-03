import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:todoapp/service/dio/dio_manager.dart';

GetIt getIt = GetIt.I;

Future<void> setUpLocator() async {
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<DioManager>(() => DioManager());
}
