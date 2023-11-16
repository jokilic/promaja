import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/custom_color/custom_color.dart';
import '../util/weather.dart';
import '../widgets/home_widget.dart';
import 'hive_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `HomeWidget`
/// Used for showing widgets in the homescreens of Android & iOS
///

final homeWidgetProvider = Provider<HomeWidgetService>(
  (_) => throw UnimplementedError(),
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
      final error = 'renderWidget - $e';
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
      final error = 'updateWidget - $e';
      logger.e(error);
    }
  }

  /// Checks if location exists and updates [HomeWidget]
  Future<void> refreshHomeWidget({
    required ResponseCurrentWeather response,
    BuildContext? context,
  }) async {
    /// Store relevant values in variables
    final locationName = response.location.name;

    final currentWeather = response.current;

    final temp = currentWeather.tempC.round();
    final conditionCode = currentWeather.condition.code;

    final backgroundColor = hive
        .getCustomColorsFromBox()
        .firstWhere(
          (customColor) => customColor.code == conditionCode && customColor.isDay,
          orElse: () => CustomColor(
            code: conditionCode,
            isDay: true,
            color: getWeatherColor(
              code: conditionCode,
              isDay: true,
            ),
          ),
        )
        .color;

    final weatherIcon = getWeatherIcon(
      code: conditionCode,
      isDay: true,
    );

    final weatherDescription = getWeatherDescription(
      code: conditionCode,
      isDay: true,
    );

    final weatherIconWidget = Image.asset(
      weatherIcon,
      height: 72,
      width: 72,
    );

    final promajaIconWidget = Image.asset(
      PromajaIcons.icon,
      height: 20,
      width: 20,
    );

    /// Precache images
    if (context != null) {
      await precacheImage(weatherIconWidget.image, context);
      await precacheImage(promajaIconWidget.image, context);
    }

    /// No context, delay the logic for a moment
    else {
      await Future.delayed(const Duration(seconds: 3));
    }

    /// Create a Flutter widget to show in [HomeWidget]
    final widget = PromajaHomeWidget(
      locationName: locationName,
      temp: temp,
      weatherDescription: weatherDescription,
      backgroundColor: backgroundColor,
      weatherIconWidget: weatherIconWidget,
      promajaIconWidget: promajaIconWidget,
    );

    /// Update [HomeWidget]
    await createHomeWidget(widget);
  }
}
