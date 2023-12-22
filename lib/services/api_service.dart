import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_weather/response_current_weather.dart';
import '../models/error/response_error.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/location/location.dart';
import '../util/env.dart';
import '../util/isolates.dart';
import 'dio_service.dart';
import 'logger_service.dart';

final apiProvider = Provider<APIService>(
  (ref) => APIService(
    logger: ref.watch(loggerProvider),
    dio: ref.watch(dioProvider).dio,
  ),
  name: 'APIService',
);

class APIService {
  final LoggerService logger;
  final Dio dio;

  APIService({
    required this.logger,
    required this.dio,
  });

  ///
  /// `current.json`
  ///
  Future<({ResponseCurrentWeather? response, ResponseError? error, String? genericError})> getCurrentWeather({required String query}) async {
    try {
      final response = await dio.get(
        '/current.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
        },
      );

      /// Status code is `200`, response is successful
      if (response.statusCode == 200) {
        final parsedResponse = await computeCurrentWeather(response.data);
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'getCurrentWeather -> StatusCode ${response.statusCode}';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'getCurrentWeather -> catch -> $e';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    }
  }

  ///
  /// `forecast.json`
  ///
  Future<({ResponseForecastWeather? response, ResponseError? error, String? genericError})> getForecastWeather({required String query, int? days = 1}) async {
    try {
      final response = await dio.get(
        '/forecast.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
          'days': days,
        },
      );

      /// Status code is `200`, response is successful
      if (response.statusCode == 200) {
        final parsedResponse = await computeForecastWeather(response.data);
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'getForecastWeather -> StatusCode ${response.statusCode}';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'getForecastWeather -> catch -> $e';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    }
  }

  ///
  /// `search.json`
  ///
  Future<({List<Location>? response, ResponseError? error, String? genericError})> getSearch({required String query}) async {
    try {
      final response = await dio.get(
        '/search.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
        },
      );

      /// Status code is `200`, response is successful
      if (response.statusCode == 200) {
        final parsedResponse = await computeSearch(
          jsonDecode(jsonEncode(response.data)),
        );
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'getSearch -> StatusCode ${response.statusCode}';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'getSearch -> catch -> $e';
      logger.e(error);
      return (response: null, error: null, genericError: error);
    }
  }

  /// Fetches current weather data
  Future<ResponseCurrentWeather?> fetchCurrentWeather({
    required Location location,
    required ProviderContainer container,
  }) async {
    try {
      final response = await getCurrentWeather(
        query: '${location.lat},${location.lon}',
      );

      /// Data fetch was successful
      if (response.response != null && response.error == null) {
        return response.response;
      }

      /// Data fetch wasn't successfull, throw error
      else {
        final error = "fetchCurrentWeather -> data fetch wasn't successful -> ${response.error?.error.message}";
        container.read(loggerProvider).e(error);
      }
    } catch (e) {
      final error = 'fetchCurrentWeather -> $e';
      logger.e(error);
    }

    return null;
  }

  /// Fetches forecast weather data
  Future<ResponseForecastWeather?> fetchForecastWeather({
    required Location location,
    required bool isTomorrow,
    required ProviderContainer container,
  }) async {
    try {
      final response = await getForecastWeather(
        query: '${location.lat},${location.lon}',
        days: isTomorrow ? 2 : 1,
      );

      /// Data fetch was successful
      if (response.response != null && response.error == null) {
        return response.response;
      }

      /// Data fetch wasn't successfull, throw error
      else {
        final error = "fetchForecastWeather -> data fetch wasn't successful -> ${response.error?.error.message}";
        container.read(loggerProvider).e(error);
      }
    } catch (e) {
      final error = 'fetchForecastWeather -> $e';
      logger.e(error);
    }

    return null;
  }
}
