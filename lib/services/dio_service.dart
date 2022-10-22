// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../util/logger_interceptor.dart';
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

class DioService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final AliceService alice;

  DioService({
    required this.logger,
    required this.alice,
  }) {
    dio = Dio(
      BaseOptions(
        connectTimeout: kDebugMode ? 30000 : 5000,
      ),
    );

    dio.interceptors.add(LoggerInterceptor(logger: logger));

    if (!Platform.isMacOS) {
      dio.interceptors.add(alice.alice.getDioInterceptor());
    }
  }

  ///
  /// VARIABLES
  ///

  late final Dio dio;

  ///
  /// METHODS
  ///

  Future<T?> request<T>({
    required String endpoint,
    required HttpMethod httpMethod,
    required Future<T> Function(dynamic responseData) onSuccess,
    Function(String error)? onError,
    Map<String, dynamic>? parameters,
  }) async {
    /// Encode passed parameters to `json`
    final jsonData = jsonEncode(parameters);

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
            queryParameters: parameters,
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

      ///
      /// Response successfully fetched
      ///

      /// Return `onSuccess` and pass the response to it
      return onSuccess(response.data);
    }

    ///
    /// Error fetching response
    ///

    on DioError catch (e) {
      if (onError != null) {
        /// Return `onError` and pass error to it
        onError('$e');
      }
    } catch (e) {
      if (onError != null) {
        /// Return `onError` and pass error to it
        onError('$e');
      }
    }

    return null;
  }
}
