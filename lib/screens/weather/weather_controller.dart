import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_weather/response_current_weather.dart';
import '../../providers.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';
import '../../services/logger_service.dart';

///
/// PROVIDER
///

final weatherProvider = StateNotifierProvider.family<WeatherController, AsyncValue<ResponseCurrentWeather?>, BuildContext>(
  (ref, context) => WeatherController(
    logger: ref.watch(loggerProvider),
    locationService: ref.watch(locationProvider),
    api: ref.watch(apiServiceProvider(context)),
  ),
  name: 'WeatherProvider',
);

class WeatherController extends StateNotifier<AsyncValue<ResponseCurrentWeather?>> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final LocationService locationService;
  final ApiService api;

  WeatherController({
    required this.logger,
    required this.locationService,
    required this.api,
  }) : super(const AsyncLoading()) {
    fetchWeather();
  }

  ///
  /// METHODS
  ///

  Future<AsyncValue<ResponseCurrentWeather?>> fetchWeather() async => state = await AsyncValue.guard<ResponseCurrentWeather?>(
        () => api.fetchCurrentWeather(
          lat: 45.8150,
          lon: 15.9819,
        ),
      );
}
