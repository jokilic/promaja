import 'package:hive/hive.dart';

part 'promaja_log_level.g.dart';

@HiveType(typeId: 16)
enum PromajaLogLevel {
  @HiveField(0)
  info,
  @HiveField(1)
  api,
  @HiveField(2)
  currentWeather,
  @HiveField(3)
  forecastWeather,
  @HiveField(4)
  list,
  @HiveField(5)
  settings,
  @HiveField(6)
  notification,
  @HiveField(7)
  widget,
  @HiveField(8)
  location,
}

String localizeLogLevel(PromajaLogLevel logLevel) => switch (logLevel) {
      PromajaLogLevel.info => 'Info',
      PromajaLogLevel.api => 'API',
      PromajaLogLevel.currentWeather => 'Current weather',
      PromajaLogLevel.forecastWeather => 'Forecast weather',
      PromajaLogLevel.list => 'List',
      PromajaLogLevel.settings => 'Settings',
      PromajaLogLevel.notification => 'Notifications',
      PromajaLogLevel.widget => 'Widget',
      PromajaLogLevel.location => 'Location',
    };
