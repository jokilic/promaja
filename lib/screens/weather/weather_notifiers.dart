import 'dart:async';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/error/response_error.dart';
import '../../models/location/location.dart';
import '../../models/weather/hour_weather.dart';
import '../../models/weather/response_forecast_weather.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';

final weatherCardIndexProvider = StateProvider.autoDispose<int>(
  (_) => 0,
  name: 'WeatherCardIndexProvider',
);

final weatherCardMovingProvider = StateProvider<bool>(
  (_) => false,
  name: 'WeatherCardMovingProvider',
);

final weatherCardSummaryShowAnimationProvider = StateProvider.autoDispose<bool>(
  (_) => true,
  name: 'WeatherCardSummaryShowAnimationProvider',
);

final showWeatherTopContainerProvider = StateProvider.autoDispose<bool>(
  (_) => false,
  name: 'ShowWeatherTopContainerProvider',
);

final weatherCardHourAdditionalControllerProvider = Provider.autoDispose<PageController>(
  (ref) {
    final controller = PageController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherCardHourAdditionalControllerProvider',
);

final activeWeatherProvider = StateProvider.autoDispose<Location?>(
  (ref) {
    final weatherIndex = ref.watch(hiveProvider.notifier).getActiveLocationIndexFromBox();
    final weatherList = ref.watch(hiveProvider);

    late final Location? location;
    try {
      location = weatherList.elementAt(weatherIndex);
    } catch (e) {
      unawaited(
        Sentry.captureException(
          'ActiveWeatherProvider -> catch -> element at index $weatherIndex is not found',
        ),
      );
      location = weatherList.elementAtOrNull(0);
    }

    return weatherList.isNotEmpty ? location : null;
  },
  name: 'ActiveWeatherProvider',
);

final weatherHoursControllerProvider = Provider.autoDispose.family<PageController, int>(
  (ref, index) {
    final controller = PageController(
      initialPage: index == 0 ? (DateTime.now().hour / 4).floor() : 1,
    );
    ref.onDispose(controller.dispose);

    return controller;
  },
  name: 'WeatherHoursControllerProvider',
);

final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, ResponseError? error, String? genericError}), ({Location location, int? days})>(
  (ref, forecastParameters) async => ref.read(apiProvider).getForecastWeather(
        query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
        days: forecastParameters.days,
      ),
  name: 'GetForecastWeatherProvider',
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

final weatherAppinioControllerProvider = Provider.autoDispose<AppinioSwiperController>(
  (_) => AppinioSwiperController(),
  name: 'WeatherAppinioControllerProvider',
);
