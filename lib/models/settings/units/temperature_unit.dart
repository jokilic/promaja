import 'package:hive/hive.dart';

part 'temperature_unit.g.dart';

@HiveType(typeId: 11)
enum TemperatureUnit {
  @HiveField(0)
  celsius,
  @HiveField(1)
  fahrenheit,
}
