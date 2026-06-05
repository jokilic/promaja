import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/durations.dart';
import '../constants/typedefs.dart';
import '../models/location/location.dart';
import '../util/env.dart';
import '../util/isolates.dart';
import 'location_service.dart';

class APIService {
  final Dio dio;
  final LocationService location;

  APIService({
    required this.dio,
    required this.location,
  });

  ///
  /// VARIABLES
  ///

  final currentWeatherCache = <String, CurrentWeatherCacheEntry>{};
  final currentWeatherRequests = <String, Future<CurrentWeatherResult>>{};

  final forecastWeatherCache = <String, ForecastWeatherCacheEntry>{};
  final forecastWeatherRequests = <String, Future<ForecastWeatherResult>>{};

  ///
  /// `current.json`
  ///
  Future<CurrentWeatherResult> getCurrentWeather({
    required String query,
  }) async {
    try {
      final response = await dio.get(
        '/current.json',
        queryParameters: {
          'key': Env.weatherApiKey,
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
      final error = 'Current weather -> StatusCode ${response.statusCode} -> Generic error';
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Current weather -> catch -> $e';
      return (response: null, error: null, genericError: error);
    }
  }

  ///
  /// `forecast.json`
  ///
  Future<ForecastWeatherResult> getForecastWeather({
    required String query,
    required int days,
  }) async {
    try {
      final response = await dio.get(
        '/forecast.json',
        queryParameters: {
          'key': Env.weatherApiKey,
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
      final error = 'Forecast weather -> StatusCode ${response.statusCode} -> Generic error';
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Forecast weather -> catch -> $e';
      return (response: null, error: null, genericError: error);
    }
  }

  ///
  /// `search.json`
  ///
  Future<SearchResult> getSearch({
    required String query,
  }) async {
    try {
      final response = await dio.get(
        '/search.json',
        queryParameters: {
          'key': Env.weatherApiKey,
          'q': query,
        },
      );

      /// Status code is `200`, response is successful
      if (response.statusCode == 200) {
        final responseList = jsonDecode(jsonEncode(response.data)) as List;

        /// No locations found
        if (responseList.isEmpty) {
          return (response: null, error: null, genericError: 'noLocationsFound'.tr());
        }

        ///
        /// Locations found
        ///
        final parsedResponse = await computeSearch(responseList);
        return (response: parsedResponse, error: null, genericError: null);
      }

      /// Status code starts with a `4`, some API error happened
      if ((response.statusCode ?? 0) ~/ 100 == 4) {
        final parsedError = await computeError(response.data);
        return (response: null, error: parsedError, genericError: null);
      }

      /// Some weird error happened
      final error = 'Search -> StatusCode ${response.statusCode} -> Generic error';
      return (response: null, error: null, genericError: error);
    } catch (e) {
      final error = 'Search -> catch -> $e';
      return (response: null, error: null, genericError: error);
    }
  }

  ///
  /// METHODS
  ///

  /// Returns fresh current weather data from memory when the same location was recently fetched
  Future<CurrentWeatherResult> getCachedCurrentWeatherWithProperLocation({
    required Location passedLocation,
  }) async {
    /// Get proper location
    final newLocation = await location.getLocationForWeatherFetch(
      location: passedLocation,
    );

    /// Generate `query`
    final query = '${newLocation.lat},${newLocation.lon}';

    final cachedCurrentWeather = currentWeatherCache[query];

    /// Fetched weather already exists and is within cache timeframe
    if (cachedCurrentWeather != null && DateTime.now().difference(cachedCurrentWeather.fetchedAt) < PromajaDurations.apiCacheDuration) {
      return Future.value(
        (
          response: cachedCurrentWeather.response,
          error: null,
          genericError: null,
        ),
      );
    }

    currentWeatherCache.remove(query);

    /// Reuse an active request when the same location is requested before its fetch completes
    return currentWeatherRequests.putIfAbsent(
      query,
      () async {
        final result = await getCurrentWeather(
          query: query,
        );

        if (result.response != null && result.error == null && result.genericError == null) {
          currentWeatherCache[query] = (
            response: result.response!,
            fetchedAt: DateTime.now(),
          );
        }

        unawaited(
          currentWeatherRequests.remove(query),
        );

        return result;
      },
    );
  }

  /// Returns fresh forecast data from memory when the same location was recently fetched
  Future<ForecastWeatherResult> getCachedForecastWeather({
    required Location passedLocation,
    required int days,
  }) async {
    /// Get proper location
    final newLocation = await location.getLocationForWeatherFetch(
      location: passedLocation,
    );

    /// Generate `query`
    final query = '${newLocation.lat},${newLocation.lon}';

    final cacheKey = '$query:$days';
    final cachedForecastWeather = forecastWeatherCache[cacheKey];

    /// Fetched weather already exists and is within cache timeframe
    if (cachedForecastWeather != null && DateTime.now().difference(cachedForecastWeather.fetchedAt) < PromajaDurations.apiCacheDuration) {
      return Future.value(
        (
          response: cachedForecastWeather.response,
          error: null,
          genericError: null,
        ),
      );
    }

    forecastWeatherCache.remove(cacheKey);

    /// Reuse an active request when the same location is requested before its fetch completes
    return forecastWeatherRequests.putIfAbsent(
      cacheKey,
      () async {
        final result = await getForecastWeather(
          query: query,
          days: days,
        );

        if (result.response != null && result.error == null && result.genericError == null) {
          forecastWeatherCache[cacheKey] = (
            response: result.response!,
            fetchedAt: DateTime.now(),
          );
        }

        unawaited(
          forecastWeatherRequests.remove(cacheKey),
        );

        return result;
      },
    );
  }
}
