import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_weather/response_current_weather.dart';
import '../../providers.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';
import '../../services/logger_service.dart';

final weatherProvider = Provider.family<WeatherController, BuildContext>(
  (ref, context) => WeatherController(
    logger: ref.watch(loggerProvider),
    locationService: ref.watch(locationProvider),
    api: ref.watch(apiServiceProvider(context)),
  ),
  name: 'WeatherProvider',
);

final fetchWeatherProvider = FutureProvider.autoDispose.family<ResponseCurrentWeather?, BuildContext>(
  (ref, context) => ref.watch(weatherProvider(context)).fetchWeather(),
  name: 'FetchWeatherProvider',
);

class WeatherController {
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
  });

  ///
  /// METHODS
  ///

  Future<ResponseCurrentWeather?> fetchWeather() async {
    final position = await locationService.getLocationWithGeolocatorPackage();

    if (position != null) {
      return api.fetchCurrentWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
    }

    return null;
  }
}
