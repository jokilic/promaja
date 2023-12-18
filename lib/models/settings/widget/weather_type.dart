import 'package:hive/hive.dart';

part 'weather_type.g.dart';

@HiveType(typeId: 7)
enum WeatherType {
  @HiveField(0)
  current,
  @HiveField(1)
  forecast,
}
