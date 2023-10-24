import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_weather/response_current_weather.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/location/location.dart';
import '../screens/cards/cards_screen.dart';
import '../screens/list/list_screen.dart';
import '../services/api_service.dart';
import '../widgets/promaja_navigation_bar.dart';

final cardAdditionalControllerProvider = Provider.autoDispose<PageController>(
  (ref) {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'CardAdditionalControllerProvider',
);

final weatherCardAdditionalControllerProvider = Provider.autoDispose<PageController>(
  (ref) {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherCardAdditionalControllerProvider',
);

final weatherCardHourAdditionalControllerProvider = Provider.autoDispose<PageController>(
  (ref) {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherCardHourAdditionalControllerProvider',
);

final weatherDaysControllerProvider = Provider.autoDispose.family<PageController, double>(
  (ref, screenWidth) {
    final controller = PageController();
    ref.onDispose(controller.dispose);

    final scrollFactor = (DateTime.now().hour / 4).floor();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.jumpTo(screenWidth * scrollFactor),
    );

    return controller;
  },
  name: 'WeatherDaysControllerProvider',
);

final getCurrentWeatherProvider = FutureProvider.family<({ResponseCurrentWeather? response, String? error}), Location>(
  (ref, location) async => ref.read(apiProvider).getCurrentWeather(
        query: '${location.lat},${location.lon}',
      ),
  name: 'GetCurrentWeatherProvider',
);

final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, String? error}), ({Location location, int? days})>(
  (ref, forecastParameters) async => ref.read(apiProvider).getForecastWeather(
        query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
        days: forecastParameters.days,
      ),
  name: 'GetForecastWeatherProvider',
);

final screenProvider = StateProvider<Widget>(
  (ref) => ref.watch(navigationBarIndexProvider) == 0 ? CardsScreen() : ListScreen(),
  name: 'ScreenProvider',
);
