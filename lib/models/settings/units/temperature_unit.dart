import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'temperature_unit.g.dart';

@HiveType(typeId: 11)
enum TemperatureUnit {
  @HiveField(0)
  celsius,
  @HiveField(1)
  fahrenheit,
}

String localizeTemperature(TemperatureUnit temperature) {
  switch (temperature) {
    case TemperatureUnit.celsius:
      return 'unitCelsius'.tr();
    case TemperatureUnit.fahrenheit:
      return 'unitFahrenheit'.tr();
  }
}
