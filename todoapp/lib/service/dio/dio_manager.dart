import 'package:dio/dio.dart';
import 'package:todoapp/service/dio/dio_interceptor.dart';
import 'package:todoapp/service/server_config.dart';

class DioManager {
  static late final ServerConfig _serverConfig;
  Dio? dio;

  /// To initialize server config
  ///
  /// [LiveServerConfig] , [TestServerConfig] or [PrePodServerConfig]
  static void init(ServerConfig serverConfig) {
    _serverConfig = serverConfig;
  }

  DioManager() {
    BaseOptions options = BaseOptions(
        baseUrl: _serverConfig.url,
        connectTimeout: Duration(milliseconds: _serverConfig.connectionTimeOut),
        receiveTimeout: Duration(milliseconds: _serverConfig.receivedTimeout),
        headers: <String, dynamic>{
          'Accept': Headers.jsonContentType,
          'Content-Type': Headers.jsonContentType
        },
        contentType: Headers.jsonContentType);

    dio = Dio(options);

    dio!.interceptors.addAll({DioInterceptor(dioInstance: dio!)});
  }
}
