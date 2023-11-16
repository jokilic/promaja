import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_weather/response_current_weather.dart';
import '../../models/forecast_weather/hour_weather.dart';
import '../../models/location/location.dart';
import '../../services/api_service.dart';
import '../../services/home_widget_service.dart';
import '../../services/work_manager_service.dart';
import '../weather/weather_notifiers.dart';

final cardIndexProvider = StateProvider<int>(
  (_) => 0,
  name: 'CardIndexProvider',
);

final cardMovingProvider = StateProvider<bool>(
  (_) => false,
  name: 'CardMovingProvider',
);

final cardAdditionalControllerProvider = Provider.autoDispose<PageController>(
  (ref) {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'CardAdditionalControllerProvider',
);

final getCurrentWeatherProvider = FutureProvider.family<({ResponseCurrentWeather? response, String? error}), ({Location location, BuildContext context})>(
  (ref, currentParameters) async {
    /// Fetch current weather
    final query = '${currentParameters.location.lat},${currentParameters.location.lon}';
    final response = await ref.read(apiProvider).getCurrentWeather(query: query);

    /// Get currently active location in [WeatherScreen] & check if it's fetched
    final activeLocation = ref.read(activeWeatherProvider);
    final responseSuccessful = response.response != null && response.error == null;
    final activeLocationFetched = response.response?.location.lat == activeLocation?.lat && response.response?.location.lon == activeLocation?.lon;

    /// Response is successful and currently active location is fetched
    /// Refresh [HomeWidget] & enable [WorkManager]
    if (responseSuccessful && activeLocationFetched) {
      /// Refresh [HomeWidget]
      unawaited(
        ref.read(homeWidgetProvider).refreshHomeWidget(
              response: response.response!,
              context: currentParameters.context,
            ),
      );

      /// Enable [WorkManager] task
      ref.read(workManagerProvider).registerTask();
    }

    return response;
  },
  name: 'GetCurrentWeatherProvider',
);

final weatherCardIndexProvider = StateProvider.autoDispose<int>(
  (_) => 0,
  name: 'WeatherCardIndexProvider',
);

final weatherCardMovingProvider = StateProvider.autoDispose<bool>(
  (_) => false,
  name: 'WeatherCardMovingProvider',
);

final activeHourWeatherProvider = StateProvider.autoDispose<HourWeather?>(
  (_) => null,
  name: 'ActiveHourWeatherProvider',
);

final weatherCardControllerProvider = Provider.autoDispose.family<ScrollController, int>(
  (ref, index) {
    final controller = ScrollController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherCardControllerProvider',
);
