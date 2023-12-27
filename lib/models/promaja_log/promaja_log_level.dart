import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'promaja_log_level.g.dart';

@HiveType(typeId: 16)
enum PromajaLogGroup {
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

String localizeLogGroup(PromajaLogGroup logGroup) => switch (logGroup) {
      PromajaLogGroup.initialization => 'loggingInitialization'.tr(),
      PromajaLogGroup.api => 'loggingApi'.tr(),
      PromajaLogGroup.currentWeather => 'loggingCurrentWeather'.tr(),
      PromajaLogGroup.forecastWeather => 'loggingForecastWeather'.tr(),
      PromajaLogGroup.list => 'loggingList'.tr(),
      PromajaLogGroup.settings => 'loggingSettings'.tr(),
      PromajaLogGroup.notification => 'loggingNotifications'.tr(),
      PromajaLogGroup.widget => 'loggingWidget'.tr(),
      PromajaLogGroup.location => 'loggingLocation'.tr(),
      PromajaLogGroup.cardColor => 'loggingCardColor'.tr(),
      PromajaLogGroup.logging => 'loggingLogging'.tr(),
      PromajaLogGroup.unit => 'loggingUnits'.tr(),
      PromajaLogGroup.background => 'loggingBackground'.tr(),
      PromajaLogGroup.navigation => 'loggingNavigation'.tr(),
    };
