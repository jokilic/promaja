import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/location/location.dart';
import '../../../../models/weather/forecast_weather.dart';
import '../../../settings/settings_notifier.dart';
import '../../weather_notifiers.dart';
import '../weather_card/weather_card_success.dart';

class WeatherSuccess extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherSuccessState();
}

class _WeatherSuccessState extends ConsumerState<WeatherSuccess> {
  @override
  void initState() {
    super.initState();

    final summaryFirst = ref.read(settingsProvider).appearance.weatherSummaryFirst;

    if (!summaryFirst) {
      Future.delayed(
        Duration.zero,
        () => ref.read(weatherAppinioControllerProvider).swipeDefault(),
      );
    }
  }

  void cardSwiped({
    required int index,
    required WidgetRef ref,
  }) {
    if (ref.read(weatherCardIndexProvider) != index) {
      ref.read(weatherCardSummaryShowAnimationProvider.notifier).state = false;
      ref.read(weatherCardMovingProvider.notifier).state = false;
      ref.read(weatherCardIndexProvider.notifier).state = index;

      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = ref.watch(weatherCardIndexProvider);
    late final cardCount = 1 + widget.forecastWeather.forecastDays.length;

    return Stack(
      children: [
        ///
        /// WEATHER
        ///
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 64),
          child: AppinioSwiper(
            controller: ref.watch(weatherAppinioControllerProvider),
            loop: true,
            isDisabled: cardCount <= 1,
            duration: PromajaDurations.cardSwiperAnimation,
            backgroundCardCount: min(cardCount - 1, 3),
            cardCount: cardCount,
            onCardPositionChanged: (_) {
              if (!ref.read(weatherCardMovingProvider)) {
                ref.read(weatherCardMovingProvider.notifier).state = true;
              }
            },
            onSwipeCancelled: (_) => ref.read(weatherCardMovingProvider.notifier).state = false,
            onSwipeEnd: (_, index, __) => cardSwiped(
              index: index,
              ref: ref,
            ),
            cardBuilder: (_, cardIndex) => WeatherCardSuccess(
              location: widget.location,
              forecastWeather: widget.forecastWeather,
              forecast: cardIndex == 0 ? null : widget.forecastWeather.forecastDays.elementAtOrNull(cardIndex - 1),
              index: cardIndex,
              isPhoneLocation: widget.isPhoneLocation,
              showCelsius: widget.showCelsius,
              showKph: widget.showKph,
              showMm: widget.showMm,
              showhPa: widget.showhPa,
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
              activeIndex: activeIndex,
              count: cardCount,
              effect: WormEffect(
                activeDotColor: PromajaColors.white,
                dotHeight: 8,
                dotWidth: 8,
                dotColor: PromajaColors.black.withValues(alpha: 0.25),
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
