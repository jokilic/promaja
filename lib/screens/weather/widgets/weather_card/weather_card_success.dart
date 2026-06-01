import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../models/location/location.dart';
import '../../../../models/weather/forecast_day_weather.dart';
import '../../../../models/weather/forecast_weather.dart';
import '../../../../util/dependencies.dart';
import '../../weather_controller.dart';
import '../weather_card_forecast/weather_card_forecast.dart';
import '../weather_card_summary/weather_card_summary.dart';
import 'weather_card_error.dart';

class WeatherCardSuccess extends StatefulWidget {
  final Location originalLocation;
  final ForecastWeather forecastWeather;
  final ForecastDayWeather? forecast;
  final int index;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherCardSuccess({
    required this.originalLocation,
    required this.forecastWeather,
    required this.forecast,
    required this.index,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
    required super.key,
  });

  @override
  State<WeatherCardSuccess> createState() => _WeatherCardSuccessState();
}

class _WeatherCardSuccessState extends State<WeatherCardSuccess> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    /// Checks if date is today
    final isToday = DateUtils.isSameDay(
      widget.forecast?.dateEpoch,
      DateTime.now(),
    );

    /// Update `activeHour` to current hour if date is today
    if (isToday) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final currentHour = widget.forecast?.hours.firstWhere(
            (hour) => hour.timeEpoch.hour == DateTime.now().hour,
          );

          getIt.get<WeatherController>().updateState(
            newActiveHour: currentHour,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = getIt.get<WeatherController>();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
      child: Builder(
        builder: (context) {
          ///
          /// WEATHER CARD SUMMARY
          ///
          if (widget.forecast == null) {
            return WeatherCardSummary(
              originalLocation: widget.originalLocation,
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
              originalLocation: widget.originalLocation,
              forecast: widget.forecast!,
              index: widget.index,
              isPhoneLocation: widget.isPhoneLocation,
              showCelsius: widget.showCelsius,
              showKph: widget.showKph,
              showMm: widget.showMm,
              showhPa: widget.showhPa,
              scrollController: scrollController,
              weatherCardHourPressed: weather.weatherCardHourPressed,
              key: ValueKey(widget.index),
            );
          }

          ///
          /// ERROR
          ///
          return WeatherCardError(
            originalLocationName: widget.originalLocation.name,
            error: 'noForecastsOrSummary'.tr(),
            isPhoneLocation: widget.isPhoneLocation,
          );
        },
      ),
    );
  }
}
