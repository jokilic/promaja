import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'weather_type.g.dart';

@HiveType(typeId: 7)
enum WeatherType {
  @HiveField(0)
  current,
  @HiveField(1)
  forecast,
}

String localizeWeatherType(WeatherType weatherType) => switch (weatherType) {
      WeatherType.current => 'weatherTypeCurrent'.tr(),
      WeatherType.forecast => 'weatherTypeForecast'.tr(),
    };
