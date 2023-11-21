import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/custom_color/custom_color.dart';
import '../screens/weather/weather_notifiers.dart';
import '../util/preload_image.dart';
import '../util/weather.dart';
import '../widgets/home_widget.dart';
import 'hive_service.dart';
import 'logger_service.dart';

final updateHomeWidgetProvider = FutureProvider.family<void, ResponseCurrentWeather>(
  (ref, response) async {
    /// Get currently active location in [WeatherScreen]
    final activeLocation = ref.read(activeWeatherProvider);

    final activeLocationSameAsResponse = (activeLocation?.lat == response.location.lat) && (activeLocation?.lon == response.location.lon);

    /// Update [HomeWidget] if `activeLocation` is being fetched
    if (activeLocationSameAsResponse) {
      /// Refresh [HomeWidget]
      unawaited(
        ref.read(homeWidgetProvider).refreshHomeWidget(
              response: response,
            ),
      );
    }
  },
  name: 'UpdateHomeWidgetProvider',
);

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
      final error = 'renderWidget -> $e';
      logger.e(error);
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
      final error = 'updateWidget -> $e';
      logger.e(error);
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
}
