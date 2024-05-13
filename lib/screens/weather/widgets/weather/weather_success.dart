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
    final summaryFirst = ref.read(settingsProvider).appearance.weatherSummaryFirst;

    if (!summaryFirst) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherAppinioControllerProvider).swipe(),
      );
    }

    super.initState();
  }

  void cardSwiped({required int index, required WidgetRef ref}) {
    if (ref.read(weatherCardIndexProvider) != index) {
      ref.read(weatherCardSummaryShowAnimationProvider.notifier).state = false;
      ref.read(weatherCardMovingProvider.notifier).state = false;
      ref.read(weatherCardIndexProvider.notifier).state = index;

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

      if (ref.read(weatherHoursControllerProvider(index)).hasClients) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(weatherHoursControllerProvider(index)).animateToPage(
                ((ref.read(weatherCardIndexProvider) == 1 ? DateTime.now().hour : 8) / 4).floor(),
                duration: PromajaDurations.hoursScrollAnimation,
                curve: Curves.easeIn,
              ),
        );
      }

      ref.read(hiveProvider.notifier).logPromajaEvent(
            text: 'Card swipe -> ${widget.location.name}, ${widget.location.country}',
            logGroup: PromajaLogGroup.forecastWeather,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(weatherCardIndexProvider);
    final cardCount = 1 + widget.forecastWeather.forecastDays.length;

    return Stack(
      children: [
        ///
        /// WEATHER
        ///
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 40),
          child: AppinioSwiper(
            controller: ref.watch(weatherAppinioControllerProvider),
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
            onSwipe: (index, __) => cardSwiped(index: index, ref: ref),
            cardsBuilder: (_, cardIndex) => WeatherCardSuccess(
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
