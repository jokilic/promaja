import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../models/promaja_log/promaja_log_level.dart';
import '../../../../services/hive_service.dart';
import '../../../cards/cards_notifiers.dart';
import '../../weather_notifiers.dart';
import '../weather_card/weather_card_success.dart';

class WeatherSuccess extends ConsumerWidget {
  final Location location;
  final ForecastWeather forecastWeather;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherSuccess({
    required this.location,
    required this.forecastWeather,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  void cardSwiped({
    required int index,
    required WidgetRef ref,
    required double screenWidth,
  }) {
    if (ref.read(weatherCardIndexProvider) != index) {
      ref.read(weatherCardMovingProvider.notifier).state = false;
      ref.read(weatherCardIndexProvider.notifier).state = index;

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
        final scrollFactor = ((ref.read(weatherCardIndexProvider) == 1 ? DateTime.now().hour : 8) / 4).floor();

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(weatherDaysControllerProvider(screenWidth)).jumpTo(screenWidth * scrollFactor),
        );
      }

      ref.read(hiveProvider.notifier).logPromajaEvent(
            text: 'Card swipe $index -> ${location.name}, ${location.country}',
            logGroup: PromajaLogGroup.forecastWeather,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(weatherCardIndexProvider);
    final cardCount = forecastWeather.forecastDays.length;

    return Stack(
      children: [
        ///
        /// WEATHER
        ///
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 40),
          child: AppinioSwiper(
            loop: true,
            padding: const EdgeInsets.only(bottom: 24),
            isDisabled: cardCount <= 1,
            duration: PromajaDurations.cardSwiperAnimation,
            backgroundCardsCount: min(cardCount - 1, 3),
            cardsCount: cardCount,
            onSwiping: (_) {
              if (!ref.read(weatherCardMovingProvider)) {
                ref.read(weatherCardMovingProvider.notifier).state = true;
              }
            },
            onSwipeCancelled: () => ref.read(weatherCardMovingProvider.notifier).state = false,
            onSwipe: (index, __) => cardSwiped(
              index: index,
              ref: ref,
              screenWidth: MediaQuery.sizeOf(context).width,
            ),
            cardsBuilder: (_, cardIndex) => WeatherCardSuccess(
              location: location,
              forecast: forecastWeather.forecastDays[cardIndex],
              useOpacity: index != cardIndex && !ref.watch(weatherCardMovingProvider),
              index: cardIndex,
              isPhoneLocation: isPhoneLocation,
              showCelsius: showCelsius,
              showKph: showKph,
              showMm: showMm,
              showhPa: showhPa,
            ),
          ),
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
              count: cardCount,
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
