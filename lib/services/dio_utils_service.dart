import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mafatlal_ecommerce/helper/shared_preference_helper.dart';
import 'package:mafatlal_ecommerce/services/navigation_service.dart';

export 'package:dio/src/dio_exception.dart';

class DioUtil {
  Dio? _instance;
  Dio? getInstance() {
    _instance ??= createDioInstance();
    return _instance;
  }

  Dio createDioInstance() {
    var dio = Dio();
    dio.interceptors.clear();

    int retryCount = 0;
    return dio
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        final token = SharedPreferencesHelper.instance.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        log(options.queryParameters.toString());
        options.headers["Access-Control-Allow-Origin"] = "*";
        options.headers['ngrok-skip-browser-warning'] = 'true';

        return handler.next(options); //modify your request
      }, onResponse: (response, handler) {
        return handler.next(response);
      }, onError: (DioException e, handler) async {
        _handleError(e.response?.statusCode ?? 0);
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode != 401 &&
              statusCode != 500 &&
              statusCode != 404 &&
              statusCode != 405 &&
              statusCode != 400) {
            if (retryCount < 3) {
              // Retry only up to 3 times
              retryCount++;
              try {
                log("retrying api $retryCount time:- ${e.requestOptions.path}");
                final response = await dio.request(e.requestOptions.path,
                    options: e.requestOptions as Options);
                return handler.resolve(response);
              } on DioException catch (error) {
                return handler.reject(error);
              }
            }
          }
        }

        log(e.toString());
        log(e.requestOptions.uri.toString());
        log(e.stackTrace.toString());
        log(e.requestOptions.toString());

        return handler.next(e);
      }));
  }

  void _handleError(int statusCode) {
    if (NavigationService.getCurrentRouteName() == null) {
      return;
    }
    switch (statusCode) {
      case 401:
        break;
      default:
    }
  }
}

class ApiResponse<T> {
  final bool status;
  final T? data;
  final String message;

  ApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) create) {
    return ApiResponse(
      status: json['status'] is String
          ? json['status'] == 'Success'
          : json['status'] == true,
      data: json['data'] != null ? create(json['data']) : null,
      message: json['message'],
    );
  }
}
