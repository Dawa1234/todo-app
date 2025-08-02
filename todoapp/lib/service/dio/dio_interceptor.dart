import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/constants.dart';
import 'package:todoapp/data/flutter_secure_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio dioInstance;
  DioInterceptor({required this.dioInstance});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String accessToken = await SecureStorage.read(key: AppConstants.TOKEN);
    if (accessToken.isNotEmpty) {
      options.headers.putIfAbsent("Authorization", () => "Bearer $accessToken");
    }
    debugPrint("REQUEST[${options.method}] => PATH: ${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint(
    //     "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    super.onError(err, handler);
  }
}
