import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/forecast_weather/response_forecast_weather.dart';
import '../../models/location/location.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';
import '../../services/home_widget_service.dart';

final activeWeatherProvider = StateProvider.autoDispose<Location?>(
  (ref) {
    final weatherIndex = ref.watch(hiveProvider.notifier).activeLocationIndexBox.get(0) ?? 0;
    final weatherList = ref.watch(hiveProvider);
    return weatherList[weatherIndex];
  },
  name: 'ActiveWeatherProvider',
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

final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, String? error}), ({Location location, int? days, BuildContext context})>(
  (ref, forecastParameters) async {
    final response = await ref.read(apiProvider).getForecastWeather(
          query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
          days: forecastParameters.days,
        );

    /// Response is successful, refresh [HomeWidget]
    if (response.response != null && response.error == null) {
      unawaited(
        ref.read(homeWidgetProvider).refreshHomeWidget(
              response: response.response!,
              homeWidget: ref.watch(homeWidgetProvider),
              context: forecastParameters.context,
            ),
      );
    }

    return response;
  },
  name: 'GetForecastWeatherProvider',
);
