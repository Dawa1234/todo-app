import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todoapp/data/flutter_secure_storage.dart';

class HiveCache {
  static const String _boxName = 'todo_app_cache';

  static Future<void> _initEncryptedHiveBox() async {
    // Get or generate encryption key
    String? existingKey = await SecureStorage.read(key: 'hive_key');
    final List<int> encryptionKey = [];

    if (existingKey.isEmpty) {
      final key = Hive.generateSecureKey(); // 256-bit key
      await SecureStorage.write(key: 'hive_key', value: key.join(','));
      encryptionKey.addAll(key);
    } else {
      final key = existingKey.split(',').map(int.parse).toList();
      encryptionKey.addAll(key);
    }

    // Open encrypted box
    await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  static Future<void> init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await _initEncryptedHiveBox();
  }

  /// cache response in Map<String,dynamic>
  static Future<void> save(String key, dynamic value) async {
    final box = Hive.box(_boxName);
    final cacheData = jsonEncode({"data": value});
    await box.put(key, cacheData);
  }

  /// get response in Map<String,dynamic>
  static Future<Map<String, dynamic>?> get(String key) async {
    final box = Hive.box(_boxName);
    final data = await box.get(key);

    if (data != null) {
      final cachedData = jsonDecode(data)['data'];
      return cachedData;
    }

    return data;
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
