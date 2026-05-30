import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/location/location.dart';
import '../../../../models/weather/forecast_weather.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/dependencies.dart';
import '../../../../util/spacing.dart';
import '../../weather_controller.dart';
import '../weather_card/weather_card_error.dart';
import '../weather_card/weather_card_success.dart';

class WeatherSuccess extends WatchingStatefulWidget {
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
  State<WeatherSuccess> createState() => _WeatherSuccessState();
}

class _WeatherSuccessState extends State<WeatherSuccess> {
  @override
  void initState() {
    super.initState();

    /// Check if weather summary should be shown as first card
    final summaryFirst = getIt.get<HiveService>().getPromajaSettingsFromBox().appearance.weatherSummaryFirst;

    /// Summary should not be shown first, swipe to first weather day
    if (!summaryFirst) {
      Future.delayed(
        Duration.zero,
        () => getIt.get<WeatherController>().cardSwiperController.swipe(
          CardSwiperDirection.right,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = getIt.get<WeatherController>();

    final currentState = watchIt<WeatherController>().value;
    final index = currentState.index;

    late final cardCount = 1 + widget.forecastWeather.forecastDays.length;

    return Stack(
      children: [
        ///
        /// WEATHER
        ///
        if (cardCount == 0)
          Padding(
            padding: EdgeInsets.only(
              bottom: getWeatherCardBottomPadding(context),
            ),
            child: WeatherCardError(
              locationName: widget.location.name,
              error: 'noCards'.tr(),
              isPhoneLocation: widget.isPhoneLocation,
            ),
          )
        else
          CardSwiper(
            backCardOffset: const Offset(0, 48),
            padding: EdgeInsets.only(
              bottom: getWeatherCardBottomPadding(context),
            ),
            controller: weather.cardSwiperController,
            isDisabled: cardCount <= 1,
            duration: PromajaDurations.cardSwiperAnimation,
            numberOfCardsDisplayed: min(cardCount, 4),
            cardsCount: cardCount,
            onSwipeDirectionChange: (horizontal, vertical) => weather.onSwipeDirectionChange(
              newIsMoving: horizontal != CardSwiperDirection.none || vertical != CardSwiperDirection.none,
            ),
            onSwipe: (previousIndex, index, __) {
              weather.cardSwiped(
                newIndex: index ?? previousIndex,
              );
              return true;
            },
            cardBuilder: (_, cardIndex, __, ___) => WeatherCardSuccess(
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
