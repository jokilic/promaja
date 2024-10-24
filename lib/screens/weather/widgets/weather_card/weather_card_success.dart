import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/durations.dart';
import '../../../../models/location/location.dart';
import '../../../../models/weather/forecast_day_weather.dart';
import '../../../../models/weather/forecast_weather.dart';
import '../../../../models/weather/hour_weather.dart';
import '../../weather_notifiers.dart';
import '../weather_card_forecast/weather_card_forecast.dart';
import '../weather_card_summary/weather_card_summary.dart';
import 'weather_card_error.dart';

class WeatherCardSuccess extends ConsumerStatefulWidget {
  final Location location;
  final ForecastWeather forecastWeather;
  final ForecastDayWeather? forecast;
  final int index;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherCardSuccess({
    required this.location,
    required this.forecastWeather,
    required this.forecast,
    required this.index,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherCardSuccessState();
}

class _WeatherCardSuccessState extends ConsumerState<WeatherCardSuccess> {
  @override
  void initState() {
    super.initState();

    /// Initialize [WeatherCardForecast]
    if (widget.forecast != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(activeHourWeatherProvider.notifier).state = widget.forecast?.hours.firstWhere(
          (hour) => hour.timeEpoch.hour == DateTime.now().hour,
        ),
      );
    }
  }

  void weatherCardHourPressed({
    required WidgetRef ref,
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
    required int index,
  }) {
    /// User pressed already active hour
    /// Disable active hour and scroll up
    if (activeHourWeather == hourWeather) {
      ref.read(activeHourWeatherProvider.notifier).state = null;
      ref.read(showWeatherTopContainerProvider.notifier).state = false;

      ref.read(weatherCardControllerProvider(index)).animateTo(
            0,
            duration: PromajaDurations.scrollAnimation,
            curve: Curves.easeIn,
          );
    }

    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      ref.read(activeHourWeatherProvider.notifier).state = hourWeather;
      ref.read(showWeatherTopContainerProvider.notifier).state = true;
      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider(index)).animateTo(
              ref.read(weatherCardControllerProvider(index)).position.maxScrollExtent,
              duration: PromajaDurations.scrollAnimation,
              curve: Curves.easeIn,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// WEATHER CARD SUMMARY
    ///
    if (widget.forecast == null) {
      return WeatherCardSummary(
        location: widget.location,
        forecastWeather: widget.forecastWeather,
        isPhoneLocation: widget.isPhoneLocation,
        showCelsius: widget.showCelsius,
      );
    }

    ///
    /// WEATHER CARD FORECAST
    ///
    if (widget.forecast != null) {
      return WeatherCardForecast(
        location: widget.location,
        forecast: widget.forecast!,
        index: widget.index,
        isPhoneLocation: widget.isPhoneLocation,
        showCelsius: widget.showCelsius,
        showKph: widget.showKph,
        showMm: widget.showMm,
        showhPa: widget.showhPa,
        weatherCardHourPressed: weatherCardHourPressed,
      );
    }

    ///
    /// ERROR
    ///
    return WeatherCardError(
      location: widget.location,
      error: 'noForecastsOrSummary'.tr(),
      isPhoneLocation: widget.isPhoneLocation,
    );
  }
}
