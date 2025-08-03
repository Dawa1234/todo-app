// import 'dart:convert';

// import 'hive_init.dart';

// abstract class LocalDataSource {
//   /// Endpoint as a key, Payload as a value
//   Future<void> cacheResponse(String endpoint, Map<String, dynamic> payload);

//   /// Fetch cached data
//   Map<String, dynamic>? getCachedResponse(String endpoint);
// }

// class ApiCacheLocalDataSourceImpl implements LocalDataSource {
//   @override
//   Future<void> cacheResponse(
//       String endpoint, Map<String, dynamic> payload) async {
//     final jsonStr = jsonEncode(payload);
//     await HiveCache.save(endpoint, jsonStr);
//   }

//   @override
//   Map<String, dynamic>? getCachedResponse(String endpoint) {
//     final jsonStr = HiveCache.get(endpoint);
//     if (jsonStr == null) return null;

//     return jsonDecode(jsonStr);
//   }
// }
