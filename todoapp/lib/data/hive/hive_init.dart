import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveCache {
  static const String _boxName = 'todo_app_cache';

  static Future<void> init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox(_boxName);
  }

  static Future<void> save(String key, dynamic value) async {
    final box = Hive.box(_boxName);
    await box.put(key, value);
  }

  static dynamic get(String key) {
    final box = Hive.box(_boxName);
    return box.get(key);
  }

  static Future<void> delete(String key) async {
    final box = Hive.box(_boxName);
    await box.delete(key);
  }

  static Future<void> clear() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
