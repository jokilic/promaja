import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/settings/appearance/weather_card_layout.dart';
import '../../../../models/weather/forecast_weather.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/dependencies.dart';
import '../../../../util/promaja_weather_card_helpers.dart';
import '../../../../util/spacing.dart';
import '../../../../widgets/promaja_weather_card.dart';
import '../../weather_controller.dart';
import '../weather_card/weather_card_error.dart';
import '../weather_card/weather_card_success.dart';

class WeatherSuccess extends WatchingStatefulWidget {
  final String locationName;
  final ForecastWeather forecastWeather;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherSuccess({
    required this.locationName,
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
  late final cardCount = 1 + widget.forecastWeather.forecastDays.length;

  @override
  void initState() {
    super.initState();

    /// Check if weather summary should be shown as first card
    final appearance = getIt.get<HiveService>().getPromajaSettingsFromBox().appearance;

    /// Summary should not be shown first, swipe to first weather day
    if (!appearance.weatherSummaryFirst) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final weather = getIt.get<WeatherController>();

          switch (appearance.weatherCardLayout) {
            case WeatherCardLayout.stacked:
              weather.cardSwiperController.swipe(
                CardSwiperDirection.right,
              );
            case WeatherCardLayout.horizontal || WeatherCardLayout.vertical:
              weather.pageController.animateToPage(
                getWeatherCardLoopedPage(
                  pageController: weather.pageController,
                  cardCount: cardCount,
                  cardIndex: 1,
                ),
                duration: PromajaDurations.cardSwiperAnimation,
                curve: Curves.easeIn,
              );
            case WeatherCardLayout.flip:
              weather.flipPageController.animateTo(1);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = getIt.get<WeatherController>();

    final currentState = watchIt<WeatherController>().value;
    final index = currentState.index;

    final hive = getIt.get<HiveService>();
    final appearance = hive.getPromajaSettingsFromBox().appearance;

    final weatherCardLayout = appearance.weatherCardLayout;

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
              locationName: widget.locationName,
              error: 'noCards'.tr(),
              isPhoneLocation: widget.isPhoneLocation,
            ),
          )
        else
          PromajaWeatherCard(
            weatherCardLayout: weatherCardLayout,
            cardCount: cardCount,
            activeIndex: index,
            padding: EdgeInsets.only(
              bottom: getWeatherCardBottomPadding(context),
            ),
            cardSwiperController: weather.cardSwiperController,
            pageController: weather.pageController,
            flipPageController: weather.flipPageController,
            onIndexChanged: (index) {
              weather.cardSwiped(
                newIndex: index,
              );
            },
            cardBuilder: (_, cardIndex) => WeatherCardSuccess(
              key: weatherCardLayout == WeatherCardLayout.stacked ? GlobalObjectKey(cardIndex) : null,
              locationName: widget.locationName,
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
