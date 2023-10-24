import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../notifiers/weather_notifier.dart';
import '../../../../widgets/fade_animation.dart';
import '../weather_card/weather_card_error.dart';
import '../weather_card/weather_card_success.dart';
import '../weather_card_hour/weather_card_hour_error.dart';
import '../weather_card_hour/weather_card_hour_success.dart';
import '../weather_card_hour/weather_card_individual_hour.dart';

final weatherCardIndexProvider = StateProvider.autoDispose<int>(
  (_) => 0,
  name: 'WeatherCardIndexProvider',
);

final weatherCardMovingProvider = StateProvider.autoDispose<bool>(
  (_) => false,
  name: 'WeatherCardMovingProvider',
);

final weatherForecastDayProvider = StateProvider.autoDispose.family<ForecastDayWeather, ForecastDayWeather>(
  (ref, initial) => initial,
  name: 'WeatherForecastDayProvider',
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
    ref.read(weatherForecastDayProvider(forecastWeather.forecastDays.first).notifier).state = forecastWeather.forecastDays[index];
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

  void weatherCardHourPressed({
    required WidgetRef ref,
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
  }) {
    /// User pressed already active hour
    /// Disable active hour and scroll up
    if (activeHourWeather == hourWeather) {
      ref.read(activeHourWeatherProvider.notifier).state = null;
      ref.read(weatherCardControllerProvider).animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
    }

    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      ref.read(activeHourWeatherProvider.notifier).state = hourWeather;
      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider).animateTo(
              ref.read(weatherCardControllerProvider).position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(weatherCardIndexProvider);
    final activeHourWeather = ref.watch(activeHourWeatherProvider);
    final cardsCount = forecastWeather.forecastDays.length;
    final weatherForecastDay = ref.watch(
      weatherForecastDayProvider(
        forecastWeather.forecastDays.first,
      ),
    );

    return FadeAnimation(
      child: ListView(
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

                ///
                /// DAYS
                ///
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      height: 88,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        scrollDirection: Axis.horizontal,
                        itemCount: weatherForecastDay.hours.length,
                        controller: ref.watch(
                          weatherDaysControllerProvider(
                            MediaQuery.sizeOf(context).width,
                          ),
                        ),
                        physics: const PageScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, hourIndex) {
                          final hourWeather = weatherForecastDay.hours.elementAtOrNull(hourIndex);

                          /// Return proper [ForecastHourSuccess]
                          if (hourWeather != null) {
                            return WeatherCardHourSuccess(
                              hourWeather: hourWeather,
                              useOpacity: ref.watch(weatherCardMovingProvider),
                              isActive: activeHourWeather == hourWeather,
                              onPressed: () => weatherCardHourPressed(
                                activeHourWeather: activeHourWeather,
                                hourWeather: hourWeather,
                                ref: ref,
                              ),
                            );
                          }

                          /// This should never happen, but if it does, return [ForecastHourError]
                          return WeatherCardHourError(
                            useOpacity: ref.watch(weatherCardMovingProvider),
                            onPressed: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///
          /// INDIVIDUAL HOUR
          ///
          WeatherCardIndividualHour(
            hourWeather: activeHourWeather,
            useOpacity: ref.watch(weatherCardMovingProvider),
            key: ValueKey(activeHourWeather),
          ),
        ],
      ),
    );
  }
}
