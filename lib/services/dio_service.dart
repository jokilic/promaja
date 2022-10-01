// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, Response;

import 'alice_service.dart';
import 'logger_service.dart';

enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

///
/// Service which holds an instance of `Dio`
/// Used for networking
/// Contains methods that ease our networking logic
///

class DioService extends GetxService {
  ///
  /// DEPENDENCIES
  ///

  final logger = Get.find<LoggerService>();
  final alice = Get.find<AliceService>().alice;

  ///
  /// VARIABLES
  ///

  late final Dio dio;

  ///
  /// INIT
  ///

  @override
  Future<void> onInit() async {
    super.onInit();

    dio = Dio(
      BaseOptions(
        connectTimeout: kDebugMode ? 30000 : 5000,
      ),
    )..interceptors.add(alice.getDioInterceptor());
  }

  ///
  /// METHODS
  ///

  Future<void> request<T>({
    required String endpoint,
    required HttpMethod httpMethod,
    required T Function(dynamic responseData) onSuccess,
    Function(String error)? onError,
    Map<String, dynamic>? data,
  }) async {
    /// Encode passed data to `json`
    final jsonData = jsonEncode(data);

    try {
      /// Create `Options` with proper `headers` and other data
      final options = Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        method: httpMethod.name,
      );

      late Response response;

      /// Trigger [Dio] with the proper `HttpMethod` and pass all relevant data
      switch (httpMethod) {

        /// `GET request`
        case HttpMethod.get:
          response = await dio.get(
            endpoint,
            options: options,
            queryParameters: data,
          );
          break;

        /// `POST request`
        case HttpMethod.post:
          response = await dio.post(
            endpoint,
            data: jsonData,
            options: options,
          );
          break;

        /// `PUT request`
        case HttpMethod.put:
          response = await dio.put(
            endpoint,
            data: jsonData,
            options: options,
          );
          break;

        /// `PATCH request`
        case HttpMethod.patch:
          response = await dio.patch(
            endpoint,
            data: jsonData,
            options: options,
          );
          break;

        /// `DELETE request`
        case HttpMethod.delete:
          response = await dio.delete(
            endpoint,
            data: jsonData,
            options: options,
          );
          break;

        default:
          logger
            ..e('DIO SERVICE')
            ..e('--------------------')
            ..e('Error generating response')
            ..e('--------------------\n');
      }

      /// Response successfully fetched
      logger
        ..v('DIO SERVICE')
        ..v('--------------------')
        ..v('Response successfully fetched')
        ..v('Endpoint: $endpoint')
        ..e('HTTP Method: ${httpMethod.name}')
        ..v('Status code: ${response.statusCode}')
        ..v('Request:')
        ..logJson(jsonData)
        ..v('Response:')
        ..logJson(response.data)
        ..v('--------------------\n');

      /// Decode passed response to `json`
      final jsonResponse = jsonDecode(response.data);

      /// Return `onSuccess` and pass the response to it
      onSuccess(jsonResponse);
    } on DioError catch (e) {
      /// Error fetching response
      logger
        ..e('DIO SERVICE')
        ..e('--------------------')
        ..e('Error fetching response')
        ..e('Endpoint: $endpoint')
        ..e('HTTP Method: ${httpMethod.name}')
        ..e('Error: ${e.message}')
        ..e('ResponseError: ${e.response?.data}')
        ..e('Request:')
        ..logJson(jsonData, isError: true)
        ..e('--------------------\n');

      if (onError != null) {
        /// Return `onError` and pass error to it
        onError('$e');
      }
    } catch (e) {
      /// Generic error
      logger
        ..e('DIO SERVICE')
        ..e('--------------------')
        ..e('Generic error')
        ..e('Endpoint: $endpoint')
        ..e('HTTP Method: ${httpMethod.name}')
        ..e('Error: $e')
        ..e('Request:')
        ..logJson(jsonData, isError: true)
        ..e('--------------------\n');
    }
  }
}
