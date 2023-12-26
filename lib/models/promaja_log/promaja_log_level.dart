import 'package:hive/hive.dart';

part 'promaja_log_level.g.dart';

@HiveType(typeId: 16)
enum PromajaLogLevel {
  @HiveField(0)
  initialization,
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
  @HiveField(9)
  cardColor,
  @HiveField(10)
  logging,
  @HiveField(11)
  unit,
  @HiveField(12)
  background,
  @HiveField(13)
  navigation,
}

// TODO: Localize this
String localizeLogLevel(PromajaLogLevel logLevel) => switch (logLevel) {
      PromajaLogLevel.initialization => 'Init',
      PromajaLogLevel.api => 'API',
      PromajaLogLevel.currentWeather => 'Current weather',
      PromajaLogLevel.forecastWeather => 'Forecast weather',
      PromajaLogLevel.list => 'List',
      PromajaLogLevel.settings => 'Settings',
      PromajaLogLevel.notification => 'Notifications',
      PromajaLogLevel.widget => 'Widget',
      PromajaLogLevel.location => 'Location',
      PromajaLogLevel.cardColor => 'Card color',
      PromajaLogLevel.logging => 'Logging',
      PromajaLogLevel.unit => 'Unit',
      PromajaLogLevel.background => 'Background',
      PromajaLogLevel.navigation => 'Navigation',
    };
