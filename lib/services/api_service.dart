import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_weather/response_current_weather.dart';
import '../models/error/response_error.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/location/location.dart';
import '../models/promaja_log/promaja_log_level.dart';
import '../util/env.dart';
import '../util/isolates.dart';
import 'dio_service.dart';
import 'hive_service.dart';
import 'logger_service.dart';

final apiProvider = Provider<APIService>(
  (ref) => APIService(
    logger: ref.watch(loggerProvider),
    dio: ref.watch(dioProvider).dio,
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'APIService',
);

class APIService {
  final LoggerService logger;
  final Dio dio;
  final HiveService hive;

  APIService({
    required this.logger,
    required this.dio,
    required this.hive,
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
        hive.logPromajaEvent(
          text: 'Current weather -> ${parsedResponse.location.name}, ${parsedResponse.location.country}',
          logGroup: PromajaLogGroup.api,
        );
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        hive.logPromajaEvent(
          text: 'Current weather -> StatusCode ${response.statusCode} -> ${parsedError.error.message}',
          logGroup: PromajaLogGroup.api,
          isError: true,
        );
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'Current weather -> StatusCode ${response.statusCode} -> Generic error';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Current weather -> Catch -> $e';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
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
        hive.logPromajaEvent(
          text: 'Forecast weather -> ${parsedResponse.location.name}, ${parsedResponse.location.name}',
          logGroup: PromajaLogGroup.api,
        );
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        hive.logPromajaEvent(
          text: 'Forecast weather -> StatusCode ${response.statusCode} -> ${parsedError.error.message}',
          logGroup: PromajaLogGroup.api,
          isError: true,
        );
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'Forecast weather -> StatusCode ${response.statusCode} -> Generic error';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Forecast weather -> Catch -> $e';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
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
        final responseList = jsonDecode(jsonEncode(response.data)) as List;

        /// No locations found
        if (responseList.isEmpty) {
          hive.logPromajaEvent(
            text: 'Search -> No locations found',
            logGroup: PromajaLogGroup.api,
            isError: true,
          );
          return (response: null, error: null, genericError: 'noLocationsFound'.tr());
        }

        ///
        /// Locations found
        ///
        final parsedResponse = await computeSearch(
          responseList,
        );

        hive.logPromajaEvent(
          text: 'Search -> ${parsedResponse.first.name}, ${parsedResponse.first.country}',
          logGroup: PromajaLogGroup.api,
        );
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        hive.logPromajaEvent(
          text: 'Search -> StatusCode ${response.statusCode} -> ${parsedError.error.message}',
          logGroup: PromajaLogGroup.api,
        );
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'Search -> StatusCode ${response.statusCode} -> Generic error';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Search -> Catch -> $e';
      hive.logPromajaEvent(
        text: error,
        logGroup: PromajaLogGroup.api,
        isError: true,
      );
      return (response: null, error: null, genericError: error);
    }
  }

  /// Fetches current weather data
  Future<ResponseCurrentWeather?> fetchCurrentWeather({required Location location}) async {
    final response = await getCurrentWeather(
      query: '${location.lat},${location.lon}',
    );

    /// Data fetch was successful
    if (response.response != null && response.error == null) {
      return response.response;
    }

    /// Data fetch wasn't successful
    return null;
  }

  /// Fetches forecast weather data
  Future<ResponseForecastWeather?> fetchForecastWeather({
    required Location location,
    required bool isTomorrow,
  }) async {
    final response = await getForecastWeather(
      query: '${location.lat},${location.lon}',
      days: isTomorrow ? 2 : 1,
    );

    /// Data fetch was successful
    if (response.response != null && response.error == null) {
      return response.response;
    }

    /// Data fetch wasn't successful
    return null;
  }
}
