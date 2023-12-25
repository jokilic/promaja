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
