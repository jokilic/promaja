import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../notifiers/weather_notifier.dart';
import '../weather_card/weather_card_error.dart';
import '../weather_card/weather_card_success.dart';
import '../weather_card_hour/weather_card_individual_hour.dart';

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

final weatherCardControllerProvider = Provider.autoDispose<ScrollController>(
  (ref) {
    final controller = ScrollController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'WeatherCardControllerProvider',
);

class WeatherSuccess extends ConsumerWidget {
  final Location location;
  final CurrentWeather currentWeather;
  final ForecastWeather forecastWeather;

  const WeatherSuccess({
    required this.location,
    required this.currentWeather,
    required this.forecastWeather,
  });

  void cardSwiped({
    required int index,
    required WidgetRef ref,
    required double screenWidth,
  }) {
    ref.read(weatherCardMovingProvider.notifier).state = false;
    ref.read(weatherCardIndexProvider.notifier).state = index;
    ref.read(activeHourWeatherProvider.notifier).state = null;
    if (ref.read(weatherCardAdditionalControllerProvider).hasClients) {
      ref.read(weatherCardAdditionalControllerProvider).jumpTo(0);
    }
    if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
      ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
    }
    if (ref.read(weatherCardControllerProvider).hasClients) {
      ref.read(weatherCardControllerProvider).animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
    }
    if (ref.read(weatherDaysControllerProvider(screenWidth)).hasClients) {
      ref.read(weatherDaysControllerProvider(screenWidth)).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(weatherCardIndexProvider);
    final activeHourWeather = ref.watch(activeHourWeatherProvider);
    final cardsCount = forecastWeather.forecastDays.length;

    return ListView(
      controller: ref.watch(weatherCardControllerProvider),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        ///
        /// MAIN CONTENT
        ///
        SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              ///
              /// CARD
              ///
              Stack(
                children: [
                  ///
                  /// WEATHER
                  ///
                  AppinioSwiper(
                    loop: true,
                    padding: const EdgeInsets.only(bottom: 140),
                    isDisabled: cardsCount <= 1,
                    duration: const Duration(milliseconds: 300),
                    backgroundCardsCount: min(cardsCount - 1, 3),
                    cardsCount: cardsCount,
                    onSwiping: (_) => ref.read(weatherCardMovingProvider.notifier).state = true,
                    onSwipeCancelled: () => ref.read(weatherCardMovingProvider.notifier).state = false,
                    onSwipe: (index, __) => cardSwiped(
                      index: index,
                      ref: ref,
                      screenWidth: MediaQuery.sizeOf(context).width,
                    ),
                    cardsBuilder: (_, cardIndex) {
                      final forecast = forecastWeather.forecastDays.elementAtOrNull(cardIndex);

                      /// Return proper [ForecastSuccess]
                      if (forecast != null) {
                        return WeatherCardSuccess(
                          location: location,
                          forecast: forecast,
                          useOpacity: index != cardIndex && !ref.watch(weatherCardMovingProvider),
                        );
                      }

                      /// This should never happen, but if it does, return [ForecastError]
                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                        child: WeatherCardError(
                          location: location,
                          error: 'No more forecasts',
                          useOpacity: index != cardIndex && !ref.watch(weatherCardMovingProvider),
                        ),
                      );
                    },
                  ),

                  ///
                  /// DOTS
                  ///
                  Positioned(
                    right: 16,
                    top: -160,
                    bottom: 0,
                    child: Align(
                      child: AnimatedSmoothIndicator(
                        activeIndex: index,
                        count: cardsCount,
                        effect: WormEffect(
                          activeDotColor: PromajaColors.white,
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: PromajaColors.black.withOpacity(0.25),
                        ),
                        axisDirection: Axis.vertical,
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        ///
        /// INDIVIDUAL HOUR
        ///
        // TODO: Think about what to do with this
        WeatherCardIndividualHour(
          hourWeather: activeHourWeather,
          useOpacity: ref.watch(weatherCardMovingProvider),
          key: ValueKey(activeHourWeather),
        ),
      ],
    );
  }
}
