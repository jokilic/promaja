import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/custom_color/custom_color.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/location/location.dart';
import '../models/promaja_log/promaja_log_level.dart';
import '../models/settings/units/temperature_unit.dart';
import '../models/settings/widget/weather_type.dart';
import '../util/preload_image.dart';
import '../util/weather.dart';
import '../widgets/home_widget/current_home_widget.dart';
import '../widgets/home_widget/forecast_home_widget.dart';
import 'api_service.dart';
import 'hive_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `HomeWidget`
/// Used for showing widgets in the homescreens of Android & iOS
///

final homeWidgetProvider = Provider<HomeWidgetService>(
  (ref) => HomeWidgetService(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
    api: ref.watch(apiProvider),
  ),
  name: 'HomeWidgetProvider',
);

class HomeWidgetService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final APIService api;

  HomeWidgetService({
    required this.logger,
    required this.hive,
    required this.api,
  })

  ///
  /// INIT
  ///

  {
    HomeWidget.setAppGroupId('group.promaja.widget');
  }

  ///
  /// METHODS
  ///

  /// Renders new `HomeWidget` & updates it
  Future<void> createHomeWidget(Widget widget) async {
    await renderHomeWidget(widget);
    await updateHomeWidget();
  }

  /// Renders a Flutter widget  as a `HomeWidget`
  Future<void> renderHomeWidget(Widget widget) async {
    try {
      await HomeWidget.renderFlutterWidget(
        widget,
        key: 'filePath',
      );
    } catch (e) {
      hive.logPromajaEvent(
        text: 'Render widget -> $e',
        logGroup: PromajaLogGroup.widget,
        isError: true,
      );
    }
  }

  /// Updates `HomeWidget`
  Future<void> updateHomeWidget() async {
    try {
      await HomeWidget.updateWidget(
        name: 'WidgetView',
        androidName: 'WidgetView',
        iOSName: 'PromajaWidget',
        qualifiedAndroidName: 'com.josipkilic.promaja.WidgetView',
      );
    } catch (e) {
      hive.logPromajaEvent(
        text: 'Update widget -> $e',
        logGroup: PromajaLogGroup.widget,
        isError: true,
      );
    }
  }

  /// Handles widget logic, depending on `WidgetSettings`
  Future<void> handleWidget() async {
    try {
      final settings = hive.getPromajaSettingsFromBox();

      final location = settings.widget.location;

      /// Location exists
      if (location != null) {
        ///
        /// Current weather
        ///
        if (settings.widget.weatherType == WeatherType.current) {
          /// Fetch current weather
          final currentWeather = await api.fetchCurrentWeather(
            location: location,
          );

          /// Current weather is successfully fetched
          if (currentWeather != null) {
            await triggerCurrentWidget(
              response: currentWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              location: location,
            );

            hive.logPromajaEvent(
              text: 'Current widget updated',
              logGroup: PromajaLogGroup.widget,
            );
          }
        }

        ///
        /// Forecast weather
        ///
        if (settings.widget.weatherType == WeatherType.forecast) {
          /// Fetch today's forecast
          final forecastWeather = await api.fetchForecastWeather(
            location: location,
            isTomorrow: false,
          );

          /// Forecast weather is successfully fetched
          if (forecastWeather != null) {
            await triggerForecastWidget(
              response: forecastWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              location: location,
            );

            hive.logPromajaEvent(
              text: 'Forecast widget updated',
              logGroup: PromajaLogGroup.widget,
            );
          }
        }
      }

      /// Location doesn't exist
      else {
        hive.logPromajaEvent(
          text: 'Handle widget -> Location null',
          logGroup: PromajaLogGroup.widget,
          isError: true,
        );
      }
    } catch (e) {
      hive.logPromajaEvent(
        text: 'Handle widget -> $e',
        logGroup: PromajaLogGroup.widget,
        isError: true,
      );
    }
  }

  /// Triggers widget with current weather
  Future<void> triggerCurrentWidget({
    required ResponseCurrentWeather response,
    required bool showCelsius,
    required Location location,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = response.location.name;

      final currentWeather = response.current;

      final temp = showCelsius ? currentWeather.tempC.round() : currentWeather.tempF.round();
      final conditionCode = currentWeather.condition.code;
      final isDay = currentWeather.isDay == 1;

      final backgroundColor = hive
          .getCustomColorsFromBox()
          .firstWhere(
            (customColor) => customColor.code == conditionCode && customColor.isDay,
            orElse: () => CustomColor(
              code: conditionCode,
              isDay: isDay,
              color: getWeatherColor(
                code: conditionCode,
                isDay: isDay,
              ),
            ),
          )
          .color;

      final weatherIcon = getWeatherIcon(
        code: conditionCode,
        isDay: isDay,
      );

      final weatherDescription = getWeatherDescription(
        code: conditionCode,
        isDay: isDay,
      );

      final weatherIconWidget = AssetImage(weatherIcon);
      const promajaIconWidget = AssetImage(PromajaIcons.icon);

      await preloadImage(weatherIconWidget);
      await preloadImage(promajaIconWidget);

      final timestamp = DateFormat.Hm().format(DateTime.now());

      /// Create a Flutter widget to show in [HomeWidget]
      final widget = CurrentHomeWidget(
        locationName: locationName,
        temp: temp,
        weatherDescription: weatherDescription,
        backgroundColor: backgroundColor,
        weatherIconWidget: weatherIconWidget,
        promajaIconWidget: promajaIconWidget,
        timestamp: timestamp,
      );

      /// Update [HomeWidget]
      await createHomeWidget(widget);
    } catch (e) {
      hive.logPromajaEvent(
        text: 'Trigger current widget -> $e',
        logGroup: PromajaLogGroup.widget,
        isError: true,
      );
    }
  }

  /// Triggers widget with forecast weather
  Future<void> triggerForecastWidget({
    required ResponseForecastWeather response,
    required bool showCelsius,
    required Location location,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = response.location.name;

      final time = DateTime.now();

      final forecast = response.forecast.forecastDays
          .where(
            (forecastDay) => forecastDay.dateEpoch.year == time.year && forecastDay.dateEpoch.month == time.month && forecastDay.dateEpoch.day == time.day,
          )
          .toList()
          .firstOrNull;

      /// Forecast exists, show it
      if (forecast != null) {
        final minTemp = showCelsius ? forecast.day.minTempC.round() : forecast.day.minTempF.round();
        final maxTemp = showCelsius ? forecast.day.maxTempC.round() : forecast.day.maxTempF.round();
        final conditionCode = forecast.day.condition.code;
        const isDay = true;

        final backgroundColor = hive
            .getCustomColorsFromBox()
            .firstWhere(
              (customColor) => customColor.code == conditionCode && customColor.isDay,
              orElse: () => CustomColor(
                code: conditionCode,
                isDay: isDay,
                color: getWeatherColor(
                  code: conditionCode,
                  isDay: isDay,
                ),
              ),
            )
            .color;

        final weatherIcon = getWeatherIcon(
          code: conditionCode,
          isDay: isDay,
        );

        final weatherDescription = getWeatherDescription(
          code: conditionCode,
          isDay: isDay,
        );

        final showRain = forecast.day.dailyWillItRain == 1;
        final showSnow = forecast.day.dailyWillItSnow == 1;

        final dailyChanceOfRain = forecast.day.dailyChanceOfRain;
        final dailyChanceOfSnow = forecast.day.dailyChanceOfSnow;

        final weatherIconWidget = AssetImage(weatherIcon);
        const promajaIconWidget = AssetImage(PromajaIcons.icon);
        const umbrellaIconWidget = AssetImage(PromajaIcons.umbrella);
        const snowIconWidget = AssetImage(PromajaIcons.snow);

        await preloadImage(weatherIconWidget);
        await preloadImage(promajaIconWidget);
        await preloadImage(umbrellaIconWidget);
        await preloadImage(snowIconWidget);

        final timestamp = DateFormat.Hm().format(DateTime.now());

        /// Create a Flutter widget to show in [HomeWidget]
        final widget = ForecastHomeWidget(
          locationName: locationName,
          minTemp: minTemp,
          maxTemp: maxTemp,
          weatherDescription: weatherDescription,
          backgroundColor: backgroundColor,
          weatherIconWidget: weatherIconWidget,
          promajaIconWidget: promajaIconWidget,
          umbrellaIconWidget: umbrellaIconWidget,
          snowIconWidget: snowIconWidget,
          timestamp: timestamp,
          showRain: showRain,
          showSnow: showSnow,
          dailyChanceOfRain: dailyChanceOfRain,
          dailyChanceOfSnow: dailyChanceOfSnow,
        );

        /// Update [HomeWidget]
        await createHomeWidget(widget);
      }
    } catch (e) {
      hive.logPromajaEvent(
        text: 'Trigger forecast widget -> $e',
        logGroup: PromajaLogGroup.widget,
        isError: true,
      );
    }
  }
}
