import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      location = weatherList.elementAtOrNull(0);
    }

    return weatherList.isNotEmpty ? location : null;
  },
  name: 'ActiveWeatherProvider',
);

final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, ResponseError? error, String? genericError}), ({Location location, int? days})>(
  (ref, forecastParameters) async => ref
      .read(apiProvider)
      .getForecastWeather(
        query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
        days: forecastParameters.days,
      ),
  name: 'GetForecastWeatherProvider',
);

final activeHourWeatherProvider = StateProvider.autoDispose<HourWeather?>(
  (_) => null,
  name: 'ActiveHourWeatherProvider',
);

final weatherAppinioControllerProvider = Provider.autoDispose<AppinioSwiperController>(
  (_) => AppinioSwiperController(),
  name: 'WeatherAppinioControllerProvider',
);
