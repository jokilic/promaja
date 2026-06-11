import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';

part 'weather_card_layout.g.dart';

@HiveType(typeId: 19)
enum WeatherCardLayout {
  @HiveField(0)
  stacked,
  @HiveField(1)
  horizontal,
  @HiveField(2)
  vertical,
}

String localizeWeatherCardLayout(WeatherCardLayout weatherCardLayout) => switch (weatherCardLayout) {
  WeatherCardLayout.stacked => 'appearanceWeatherCardLayoutStacked'.tr(),
  WeatherCardLayout.horizontal => 'appearanceWeatherCardLayoutHorizontal'.tr(),
  WeatherCardLayout.vertical => 'appearanceWeatherCardLayoutVertical'.tr(),
};
