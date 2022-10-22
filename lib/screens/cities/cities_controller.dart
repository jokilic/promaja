import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/api_service.dart';
import '../../services/logger_service.dart';

final citiesProvider = Provider.family<CitiesController, BuildContext>(
  (ref, context) => CitiesController(
    logger: ref.watch(loggerProvider),
    api: ref.watch(apiServiceProvider(context)),
  ),
  name: 'CitiesProvider',
);

class CitiesController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final ApiService api;

  CitiesController({
    required this.logger,
    required this.api,
  });

  ///
  /// VARIABLES
  ///

  var someString = '';

  ///
  /// METHODS
  ///

  Future<void> fetchWeathers() async {
    final fetchWeatherList = [
      api.fetchCurrentWeather(lat: 55.7504461, lon: 37.6174943),
    ];

    final list = await Future.wait(fetchWeatherList);

    logger.wtf(list);
  }
}
