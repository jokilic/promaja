import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/location/location.dart';
import '../../../cards/cards_notifiers.dart';
import '../../weather_notifiers.dart';
import '../weather_card/weather_card_error.dart';
import '../weather_card/weather_card_success.dart';

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
    if (ref.read(weatherCardControllerProvider(index)).hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider(index)).animateTo(
              0,
              duration: PromajaDurations.scrollAnimation,
              curve: Curves.easeIn,
            ),
      );
    }
    if (ref.read(weatherDaysControllerProvider(screenWidth)).hasClients) {
      ref.read(weatherDaysControllerProvider(screenWidth)).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(weatherCardIndexProvider);
    final cardsCount = forecastWeather.forecastDays.length;

    return Stack(
      children: [
        ///
        /// WEATHER
        ///
        AppinioSwiper(
          loop: true,
          padding: const EdgeInsets.only(bottom: 24),
          isDisabled: cardsCount <= 1,
          duration: PromajaDurations.cardSwiperAnimation,
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
                index: cardIndex,
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
    );
  }
}
