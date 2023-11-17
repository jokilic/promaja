import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_weather/response_current_weather.dart';
import '../../models/forecast_weather/hour_weather.dart';
import '../../models/location/location.dart';
import '../../services/api_service.dart';
import '../../services/home_widget_service.dart';

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

final getCurrentWeatherProvider = FutureProvider.family<({ResponseCurrentWeather? response, String? error}), Location>(
  (ref, location) async {
    /// Fetch current weather
    final query = '${location.lat},${location.lon}';
    final response = await ref.read(apiProvider).getCurrentWeather(query: query);

    /// Update [HomeWidget]
    unawaited(ref.read(updateHomeWidgetProvider(response).future));

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
