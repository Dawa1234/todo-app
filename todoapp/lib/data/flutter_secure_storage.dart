import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Write data
  static Future<void> write(
      {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  // Read data
  static Future<String> read({required String key}) async {
    return await _storage.read(key: key) ?? "";
  }

  // Delete data
  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  // Delete all
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
