import 'package:hive_ce/hive.dart';
import 'package:promaja/models/custom_color/custom_color.dart';
import 'package:promaja/models/location/location.dart';
import 'package:promaja/models/settings/appearance/appearance_settings.dart';
import 'package:promaja/models/settings/appearance/initial_section.dart';
import 'package:promaja/models/settings/notification/notification_last_shown.dart';
import 'package:promaja/models/settings/notification/notification_settings.dart';
import 'package:promaja/models/settings/promaja_settings.dart';
import 'package:promaja/models/settings/units/distance_speed_unit.dart';
import 'package:promaja/models/settings/units/precipitation_unit.dart';
import 'package:promaja/models/settings/units/pressure_unit.dart';
import 'package:promaja/models/settings/units/temperature_unit.dart';
import 'package:promaja/models/settings/units/unit_settings.dart';
import 'package:promaja/models/settings/widget/weather_type.dart';
import 'package:promaja/models/settings/widget/widget_settings.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(AppearanceSettingsAdapter());
    registerAdapter(CustomColorAdapter());
    registerAdapter(DistanceSpeedUnitAdapter());
    registerAdapter(InitialSectionAdapter());
    registerAdapter(LocationAdapter());
    registerAdapter(NotificationLastShownAdapter());
    registerAdapter(NotificationSettingsAdapter());
    registerAdapter(PrecipitationUnitAdapter());
    registerAdapter(PressureUnitAdapter());
    registerAdapter(PromajaSettingsAdapter());
    registerAdapter(TemperatureUnitAdapter());
    registerAdapter(UnitSettingsAdapter());
    registerAdapter(WeatherTypeAdapter());
    registerAdapter(WidgetSettingsAdapter());
  }
}
