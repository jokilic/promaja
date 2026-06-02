import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/custom_color/custom_color.dart';
import '../models/location/location.dart';
import '../models/settings/units/temperature_unit.dart';
import '../models/settings/widget/weather_type.dart';
import '../models/weather/response_forecast_weather.dart';
import '../util/preload_image.dart';
import '../util/weather.dart';
import '../widgets/home_widget/current_home_widget.dart';
import '../widgets/home_widget/forecast_home_widget.dart';
import 'api_service.dart';
import 'hive_service.dart';

class HomeWidgetService {
  final HiveService hive;
  final APIService api;

  HomeWidgetService({
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
      final error = 'RenderHomeWidget -> catch -> $e';
      debugPrint(error);
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
      final error = 'UpdateHomeWidget -> catch -> $e';
      debugPrint(error);
    }
  }

  /// Handles widget logic, depending on `WidgetSettings`
  Future<void> handleWidget({required String languageCode}) async {
    try {
      /// Check if user uses widgets
      final widgets = await HomeWidget.getInstalledWidgets();

      /// There are no widgets active, return
      if (widgets.isEmpty) {
        return;
      }

      final settings = hive.getPromajaSettingsFromBox();

      final location = settings.widget.location;

      /// Location exists
      if (location != null) {
        ///
        /// Current weather
        ///
        if (settings.widget.weatherType == WeatherType.current) {
          /// Fetch current weather
          final currentWeather = await api.getCachedCurrentWeather(
            query: '${location.lat},${location.lon}',
          );

          /// Current weather is successfully fetched
          if (currentWeather.response != null) {
            await triggerCurrentWidget(
              response: currentWeather.response!,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              location: location,
              languageCode: languageCode,
            );
          }
        }

        ///
        /// Forecast weather
        ///
        if (settings.widget.weatherType == WeatherType.forecast) {
          /// Fetch today's forecast
          final forecastWeather = await api.getCachedForecastWeather(
            query: '${location.lat},${location.lon}',
            days: 1,
          );

          /// Forecast weather is successfully fetched
          if (forecastWeather.response != null) {
            await triggerForecastWidget(
              response: forecastWeather.response!,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              location: location,
              languageCode: languageCode,
            );
          }
        }
      }
      /// Location doesn't exist
      else {
        debugPrint('Handle widget -> Location null');
      }
    } catch (e) {
      final error = 'HandleWidget -> catch -> $e';
      debugPrint(error);
    }
  }

  /// Triggers widget with current weather
  Future<void> triggerCurrentWidget({
    required ResponseCurrentWeather response,
    required bool showCelsius,
    required Location location,
    required String languageCode,
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

      final weatherDescription =
          getWeatherDescription(
            code: conditionCode,
            isDay: isDay,
          ) ??
          '';

      final weatherIconWidget = AssetImage(weatherIcon);
      const promajaIconWidget = AssetImage(PromajaIcons.icon);

      await preloadImage(weatherIconWidget);
      await preloadImage(promajaIconWidget);

      final timestamp = DateFormat.Hm(languageCode).format(DateTime.now());

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
      final error = 'TriggerCurrentWidget -> catch -> $e';
      debugPrint(error);
    }
  }

  /// Triggers widget with forecast weather
  Future<void> triggerForecastWidget({
    required ResponseForecastWeather response,
    required bool showCelsius,
    required Location location,
    required String languageCode,
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

        final weatherDescription =
            getWeatherDescription(
              code: conditionCode,
              isDay: isDay,
            ) ??
            '';

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

        final timestamp = DateFormat.Hm(languageCode).format(DateTime.now());

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
      final error = 'TriggerForecastWidget -> catch -> $e';
      debugPrint(error);
    }
  }
}
