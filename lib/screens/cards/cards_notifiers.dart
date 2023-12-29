import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_weather/response_current_weather.dart';
import '../../models/error/response_error.dart';
import '../../models/location/location.dart';
import '../../services/api_service.dart';

final appinioControllerProvider = Provider<AppinioSwiperController>(
  (_) => AppinioSwiperController(),
  name: 'appinioControllerProvider',
);

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

final getCurrentWeatherProvider = FutureProvider.family<({ResponseCurrentWeather? response, ResponseError? error, String? genericError}), Location>(
  (ref, location) async => ref.read(apiProvider).getCurrentWeather(query: '${location.lat},${location.lon}'),
  name: 'GetCurrentWeatherProvider',
);
