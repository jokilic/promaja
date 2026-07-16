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
import 'location_service.dart';

class HomeWidgetService {
  final HiveService hive;
  final APIService api;
  final LocationService location;
  final String languageCode;
  final Future<void>? initialPhoneLocationRefresh;
  final bool updateInstalledWidgetsOnInit;

  HomeWidgetService({
    required this.hive,
    required this.api,
    required this.location,
    required this.languageCode,
    required this.updateInstalledWidgetsOnInit,
    this.initialPhoneLocationRefresh,
  });

  ///
  /// INIT
  ///

  Future<void> init() async {
    await HomeWidget.setAppGroupId('group.promaja.widget');

    /// Background work explicitly updates the widget after all services are initialized
    if (!updateInstalledWidgetsOnInit) {
      return;
    }

    /// Update after the foreground GPS refresh so startup cannot render stale phone coordinates
    if (initialPhoneLocationRefresh != null) {
      unawaited(
        initialPhoneLocationRefresh!.then(
          (_) => updateInstalledWidgets(
            languageCode: languageCode,
          ),
        ),
      );
      return;
    }

    await updateInstalledWidgets(
      languageCode: languageCode,
    );
  }

  ///
  /// METHODS
  ///

  /// Updates widgets if there are any emabled
  Future<bool> updateInstalledWidgets({required String languageCode}) async {
    try {
      final widgets = await HomeWidget.getInstalledWidgets();

      if (widgets.isNotEmpty) {
        return handleWidget(
          languageCode: languageCode,
        );
      }
    } catch (_) {}

    return false;
  }

  /// Renders new `HomeWidget` & updates it
  Future<bool> createHomeWidget(Widget widget) async {
    final rendered = await renderHomeWidget(widget);

    if (!rendered) {
      return false;
    }

    return updateHomeWidget();
  }

  /// Renders a Flutter widget  as a `HomeWidget`
  Future<bool> renderHomeWidget(Widget widget) async {
    try {
      await HomeWidget.renderFlutterWidget(
        widget,
        key: 'filePath',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Updates `HomeWidget`
  Future<bool> updateHomeWidget() async {
    try {
      return await HomeWidget.updateWidget(
            name: 'WidgetView',
            androidName: 'WidgetView',
            iOSName: 'PromajaWidget',
            qualifiedAndroidName: 'com.josipkilic.promaja.WidgetView',
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Handles widget logic, depending on `WidgetSettings`
  Future<bool> handleWidget({required String languageCode}) async {
    try {
      /// Check if user uses widgets
      final widgets = await HomeWidget.getInstalledWidgets();

      final settings = hive.getPromajaSettingsFromBox();

      final calculatedLocation = settings.widget.location;

      if (widgets.isEmpty || calculatedLocation == null) {
        return false;
      }

      final isPhoneLocation = calculatedLocation.isPhoneLocation ?? false;

      ///
      /// Current weather
      ///
      if (settings.widget.weatherType == WeatherType.current) {
        /// Fetch current weather
        final currentWeather = await api.getCachedCurrentWeather(
          query: '${calculatedLocation.lat},${calculatedLocation.lon}',
        );

        /// Current weather is successfully fetched
        if (currentWeather.response == null) {
          return false;
        }

        return triggerCurrentWidget(
          response: currentWeather.response!,
          showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
          location: calculatedLocation,
          languageCode: languageCode,
          isPhoneLocation: isPhoneLocation,
        );
      }

      ///
      /// Forecast weather
      ///
      if (settings.widget.weatherType == WeatherType.forecast) {
        /// Fetch today's forecast
        final forecastWeather = await api.getCachedForecastWeather(
          query: '${calculatedLocation.lat},${calculatedLocation.lon}',
          days: 1,
        );

        /// Forecast weather is successfully fetched
        if (forecastWeather.response == null) {
          return false;
        }

        return triggerForecastWidget(
          response: forecastWeather.response!,
          showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
          location: calculatedLocation,
          languageCode: languageCode,
          isPhoneLocation: isPhoneLocation,
        );
      }
    } catch (_) {}

    return false;
  }

  /// Triggers widget with current weather
  Future<bool> triggerCurrentWidget({
    required ResponseCurrentWeather response,
    required bool showCelsius,
    required Location location,
    required String languageCode,
    required bool isPhoneLocation,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = isPhoneLocation ? response.location.name : location.name;

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
      return createHomeWidget(widget);
    } catch (_) {
      return false;
    }
  }

  /// Triggers widget with forecast weather
  Future<bool> triggerForecastWidget({
    required ResponseForecastWeather response,
    required bool showCelsius,
    required Location location,
    required String languageCode,
    required bool isPhoneLocation,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = isPhoneLocation ? response.location.name : location.name;

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
        return createHomeWidget(widget);
      }
    } catch (_) {}

    return false;
  }
}
