import 'dart:convert';

import 'package:dio/dio.dart';

import '../services/logger_service.dart';

class LoggerInterceptor implements Interceptor {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  LoggerInterceptor({
    required this.logger,
  });

  ///
  /// METHODS
  ///

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final endpoint = '${err.requestOptions.baseUrl}${err.requestOptions.path}';
    final httpMethod = err.requestOptions.method;
    final statusCode = '${err.response?.statusCode}';
    final error = err.message;
    final responseError = '${err.response?.data}';
    final jsonData = jsonEncode(err.requestOptions.queryParameters);

    logger
      ..e('❌ ERROR FETCHING RESPONSE ❌')
      ..e('--------------------')
      ..e('Endpoint: $endpoint')
      ..e('HTTP Method: $httpMethod')
      ..e('Status code: $statusCode')
      ..e('Error: $error')
      ..e('ResponseError: $responseError')
      ..e('Request:')
      ..logJson(jsonData, isError: true)
      ..e('--------------------\n');

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final endpoint = '${options.baseUrl}${options.path}';
    final httpMethod = options.method;
    final jsonData = jsonEncode(options.queryParameters);

    logger
      ..v('🌍 SENDING NETWORK REQUEST 🌍')
      ..v('--------------------')
      ..v('Endpoint: $endpoint')
      ..v('HTTP Method: $httpMethod')
      ..v('Request:')
      ..logJson(jsonData)
      ..v('--------------------\n');

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final endpoint = '${response.requestOptions.baseUrl}${response.requestOptions.path}';
    final httpMethod = response.requestOptions.method;
    final statusCode = '${response.statusCode}';
    final jsonData = jsonEncode(response.requestOptions.queryParameters);
    final jsonResponse = jsonEncode(response.data);

    logger
      ..v('✅ RESPONSE SUCCESSFULLY FETCHED ✅')
      ..v('--------------------')
      ..v('Endpoint: $endpoint')
      ..v('HTTP Method: $httpMethod')
      ..v('Status code: $statusCode')
      ..v('Request:')
      ..logJson(jsonData)
      ..v('Response:')
      ..logJson(jsonResponse)
      ..v('--------------------\n');

    return handler.next(response);
  }
}
