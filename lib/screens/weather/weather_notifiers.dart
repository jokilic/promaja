import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/error/response_error.dart';
import '../../models/location/location.dart';
import '../../models/weather/hour_weather.dart';
import '../../models/weather/response_forecast_weather.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';

final weatherCardIndexProvider = NotifierProvider.autoDispose<WeatherCardIndexNotifier, int>(
  WeatherCardIndexNotifier.new,
  name: 'WeatherCardIndexProvider',
);

final weatherCardMovingProvider = NotifierProvider<WeatherCardMovingNotifier, bool>(
  WeatherCardMovingNotifier.new,
  name: 'WeatherCardMovingProvider',
);

final weatherCardSummaryShowAnimationProvider = NotifierProvider.autoDispose<WeatherCardSummaryShowAnimationNotifier, bool>(
  WeatherCardSummaryShowAnimationNotifier.new,
  name: 'WeatherCardSummaryShowAnimationProvider',
);

final showWeatherTopContainerProvider = NotifierProvider.autoDispose<ShowWeatherTopContainerNotifier, bool>(
  ShowWeatherTopContainerNotifier.new,
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

final activeWeatherProvider = NotifierProvider.autoDispose<ActiveWeatherNotifier, Location?>(
  ActiveWeatherNotifier.new,
  name: 'ActiveWeatherProvider',
);

final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, ResponseError? error, String? genericError}), ({Location location, int days})>(
  (ref, forecastParameters) async => ref
      .read(apiProvider)
      .getForecastWeather(
        query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
        days: forecastParameters.days,
      ),
  name: 'GetForecastWeatherProvider',
);

final activeHourWeatherProvider = NotifierProvider.autoDispose<ActiveHourWeatherNotifier, HourWeather?>(
  ActiveHourWeatherNotifier.new,
  name: 'ActiveHourWeatherProvider',
);

final weatherSwiperControllerProvider = Provider.autoDispose<CardSwiperController>(
  (ref) {
    final controller = CardSwiperController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherSwiperControllerProvider',
);

class WeatherCardIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  set activeIndex(int value) => state = value;

  void reset() => state = 0;
}

class WeatherCardMovingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  set moving(bool isMoving) => state = isMoving;
}

class WeatherCardSummaryShowAnimationNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  set visible(bool isVisible) => state = isVisible;
}

class ShowWeatherTopContainerNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  set visible(bool isVisible) => state = isVisible;
}

class ActiveWeatherNotifier extends Notifier<Location?> {
  @override
  Location? build() {
    final weatherList = ref.watch(hiveProvider);
    final hiveService = ref.read(hiveProvider.notifier);
    final weatherIndex = hiveService.getActiveLocationIndexFromBox();

    Location? location;
    try {
      location = weatherList.elementAt(weatherIndex);
    } catch (e) {
      location = weatherList.elementAtOrNull(0);
    }

    return weatherList.isNotEmpty ? location : null;
  }
}

class ActiveHourWeatherNotifier extends Notifier<HourWeather?> {
  @override
  HourWeather? build() => null;

  set activeHour(HourWeather? hour) => state = hour;
}
