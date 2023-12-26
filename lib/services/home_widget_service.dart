import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/custom_color/custom_color.dart';
import '../models/promaja_log/promaja_log_level.dart';
import '../models/settings/promaja_settings.dart';
import '../util/preload_image.dart';
import '../util/weather.dart';
import '../widgets/home_widget.dart';
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
  ),
  name: 'HomeWidgetProvider',
);

class HomeWidgetService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  HomeWidgetService({
    required this.logger,
    required this.hive,
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
        text: 'Widget -> renderHomeWidget -> $e',
        logLevel: PromajaLogLevel.widget,
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
        text: 'Widget -> updateHomeWidget -> $e',
        logLevel: PromajaLogLevel.widget,
        isError: true,
      );
    }
  }

  /// Checks if location exists and updates [HomeWidget]
  Future<void> refreshHomeWidget({required ResponseCurrentWeather response}) async {
    /// Store relevant values in variables
    final locationName = response.location.name;

    final currentWeather = response.current;

    final temp = currentWeather.tempC.round();
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
    final widget = PromajaHomeWidget(
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
  }

  /// Handles widget logic, depending on `WidgetSettings`
  Future<void> handleWidget({
    required PromajaSettings settings,
    required ProviderContainer container,
  }) async {
    // TODO: Implement this

    final location = settings.widget.location;

    if (location != null) {}
  }

  /// Refreshes widget in the home screen
  Future<void> updateWidget() async {
    // TODO: Implement this

    hive.logPromajaEvent(
      text: 'Widget -> Updated manually',
      logLevel: PromajaLogLevel.widget,
    );
  }
}
