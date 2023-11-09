import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../constants/icons.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../util/weather.dart';
import '../widgets/home_widget.dart';
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

  HomeWidgetService(this.logger)

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
    required ResponseForecastWeather response,
    required HomeWidgetService homeWidget,
    BuildContext? context,
  }) async {
    /// Store relevant values in variables
    final locationName = response.location.name;

    final firstDayForecast = response.forecast.forecastDays.first.day;

    final minTemp = firstDayForecast.minTempC.round();
    final maxTemp = firstDayForecast.maxTempC.round();
    final conditionCode = firstDayForecast.condition.code;

    final dailyWillItRain = firstDayForecast.dailyWillItRain;
    final dailyChanceOfRain = firstDayForecast.dailyChanceOfRain;

    final backgroundColor = getWeatherColor(
      code: conditionCode,
      isDay: true,
    );
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

    /// Create a Flutter widget to show in [HomeWidget]
    final widget = PromajaHomeWidget(
      locationName: locationName,
      minTemp: minTemp,
      maxTemp: maxTemp,
      weatherDescription: weatherDescription,
      backgroundColor: backgroundColor,
      dailyWillItRain: dailyWillItRain,
      dailyChanceOfRain: dailyChanceOfRain,
      weatherIconWidget: weatherIconWidget,
      promajaIconWidget: promajaIconWidget,
    );

    /// Update [HomeWidget]
    await homeWidget.createHomeWidget(widget);
  }
}
