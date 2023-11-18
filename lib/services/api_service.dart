import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_weather/response_current_weather.dart';
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
  Future<({ResponseCurrentWeather? response, String? error})> getCurrentWeather({required String query}) async {
    try {
      final response = await dio.get(
        '/current.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
        },
      );

      if (response.statusCode == 200) {
        final parsedResponse = await computeCurrentWeather(response.data);
        return (response: parsedResponse, error: null);
      } else {
        final error = 'getCurrentWeather -> StatusCode ${response.statusCode}';
        logger.e(error);
        return (response: null, error: error);
      }
    } catch (e) {
      final error = 'getCurrentWeather -> $e';
      logger.e(error);
      return (response: null, error: error);
    }
  }

  ///
  /// `forecast.json`
  ///
  Future<({ResponseForecastWeather? response, String? error})> getForecastWeather({required String query, int? days = 1}) async {
    try {
      final response = await dio.get(
        '/forecast.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
          'days': days,
        },
      );

      if (response.statusCode == 200) {
        final parsedResponse = await computeForecastWeather(response.data);
        return (response: parsedResponse, error: null);
      } else {
        final error = 'getForecastWeather -> StatusCode ${response.statusCode}';
        logger.e(error);
        return (response: null, error: error);
      }
    } catch (e) {
      final error = 'getForecastWeather -> $e';
      logger.e(error);
      return (response: null, error: error);
    }
  }

  ///
  /// `search.json`
  ///
  Future<({List<Location>? response, String? error})> getSearch({required String query}) async {
    try {
      final response = await dio.get(
        '/search.json',
        queryParameters: {
          'key': Env.apiKey,
          'q': query,
        },
      );

      if (response.statusCode == 200) {
        final parsedResponse = await computeSearch(
          jsonDecode(jsonEncode(response.data)),
        );
        return (response: parsedResponse, error: null);
      } else {
        final error = 'getSearch -> StatusCode ${response.statusCode}';
        logger.e(error);
        return (response: null, error: error);
      }
    } catch (e) {
      final error = 'getSearch -> $e';
      logger.e(error);
      return (response: null, error: error);
    }
  }
}
