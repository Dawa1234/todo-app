import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:todoapp/core/service_locator.dart';
import 'package:todoapp/data/hive/hive_init.dart';
import 'package:todoapp/helper/enums.dart';
import 'package:todoapp/service/error_handler.dart';

class DioApiBase {
  /// Final execution of api with token
  static Future<dynamic> apiBase<T>(
      {required String path,
      required RequestMethod method,
      required Future<Response<dynamic>> apiCall}) async {
    // success status codes
    const List<int> validStatusCode = [200, 201];

    // Error messages
    const baseError = "Something went wrong, please try again.";
    const connectionTimeOut = "Connection Timeout, please try again.";
    const noInternetError = "No Internet Connection, please try again.";

    try {
      final connectivity = await getIt<Connectivity>().checkConnectivity();

      if (!connectivity.contains(ConnectivityResult.wifi) ||
          !connectivity.contains(ConnectivityResult.mobile)) {
        if (method == RequestMethod.GET) return await _fetchLocalData(path);
      } else {
        throw noInternetError;
      }

      // initiate request
      final Response response = await apiCall;

      /// success reponse
      if (validStatusCode.contains(response.statusCode)) {
        _cacheData(path, response.data);
        return response.data;
      }

      return baseError;

      // on Exception
    } on DioException catch (err) {
      String? errorMessage;
      final errorModel = ErrorModel(
          success: false,
          message: errorMessage ?? "Bad Certificate, please try again.",
          data: err.response?.data);

      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          errorModel.message = errorMessage ?? connectionTimeOut;
          return errorModel;

        case DioExceptionType.sendTimeout:
          errorModel.message = errorMessage ?? connectionTimeOut;
          return errorModel;

        case DioExceptionType.receiveTimeout:
          errorModel.message = errorMessage ?? connectionTimeOut;
          return errorModel;

        case DioExceptionType.badCertificate:
          errorModel.message =
              errorMessage ?? "Bad Certificate, please try again.";
          return errorModel;

        // bad response
        case DioExceptionType.badResponse:
          switch (err.response?.statusCode) {
            case 302:
              errorModel.message = errorMessage ?? "Not Found";
              return errorModel;

            case 400:
              errorModel.message = errorMessage ?? "Invalid Request";
              return errorModel;

            case 401:
              errorModel.message =
                  errorMessage ?? "Access Denied (Unauthorized)";
              return errorModel;

            case 403:
              errorModel.message = errorMessage ?? "Forbidden";
              return errorModel;

            case 404:
              errorModel.message = errorMessage ??
                  "The requested Information could not be found";
              return errorModel;

            case 409:
              errorModel.message = errorMessage ?? "Conflict Occurred";
              return errorModel;

            case 500:
              errorModel.message = errorMessage ??
                  "Internal Server Error Occurred, please try again later.";
              return errorModel;

            case 503:
              errorModel.message = errorMessage ?? "Service Unavailable";
              return errorModel;

            case 504:
              errorModel.message = errorMessage ?? "Gateway Timeout";
              return errorModel;

            case 505:
              errorModel.message = errorMessage ?? "HTTP Version Not Supported";
              return errorModel;

            default:
              errorModel.message = errorMessage ?? baseError;
              return errorModel;
          }
        case DioExceptionType.cancel:
          errorModel.message = errorMessage ?? baseError;
          return errorModel;

        case DioExceptionType.connectionError:
          errorModel.message = errorMessage ?? noInternetError;
          return errorModel;

        case DioExceptionType.unknown:
          errorModel.message = errorMessage ?? baseError;
          return errorModel;
      }
    } catch (e) {
      return ErrorModel(success: false, message: baseError, data: e);
    }
  }

  /// Only fetch response of [GET] method
  static Future<dynamic> _fetchLocalData(String path) async {
    final data = await HiveCache.get(path);
    // data.runtimeType;

    return data;
  }

  /// Only cache response of [GET] method
  static Future<void> _cacheData(String path, Object? response) async =>
      await HiveCache.save(path, response);
}
