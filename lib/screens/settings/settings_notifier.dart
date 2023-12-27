import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/location/location.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../models/settings/promaja_settings.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../models/settings/widget/weather_type.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/notification_service.dart';

final settingsProvider = StateNotifierProvider.autoDispose<SettingsNotifier, PromajaSettings>(
  (ref) => SettingsNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
    notification: ref.watch(notificationProvider),
  ),
  name: 'SettingsProvider',
);

class SettingsNotifier extends StateNotifier<PromajaSettings> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final NotificationService notification;

  SettingsNotifier({
    required this.logger,
    required this.hive,
    required this.notification,
  }) : super(hive.getPromajaSettingsFromBox())

  ///
  /// INIT
  ///

  {
    final locations = hive.getLocationsFromBox();

    /// Notification location is `null`, set it to the first location from [Hive]
    if (state.notification.location == null) {
      if (locations.isNotEmpty) {
        updateNotificationLocation(locations.first);
      }
    }

    /// Widget location is `null`, set it to the first location from [Hive]
    if (state.widget.location == null) {
      if (locations.isNotEmpty) {
        updateWidgetLocation(locations.first);
      }
    }
  }

  ///
  /// VARIABLES
  ///

  TapDownDetails? tapDownDetails;

  ///
  /// METHODS
  ///

  /// Updates settings with new [PromajaSettings]
  Future<void> updateSettings(PromajaSettings newSettings) async {
    state = newSettings;
    await hive.addPromajaSettingsToBox(promajaSettings: newSettings);
  }

  ///
  /// NOTIFICATIONS
  ///

  /// Opens popup menu which chooses location to be used in notifications
  Future<Location?> showNotificationLocationPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    final locations = hive.getLocationsFromBox();

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: locations
          .map(
            (location) => PopupMenuItem(
              value: location,
              padding: const EdgeInsets.all(20),
              child: Text(
                '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in notifications
  Future<void> updateNotificationLocation(Location newLocation) async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            location: newLocation,
          ),
        ),
      );

  /// Triggered when the user taps the `Hourly notification` checkbox
  Future<void> toggleHourlyNotification() async {
    /// Update `state` and [Hive] with proper value
    final newState = !state.notification.hourlyNotification;

    await updateSettings(
      state.copyWith(
        notification: state.notification.copyWith(
          hourlyNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();

    hive.logPromajaEvent(
      text: 'Hourly notification -> ${newState ? 'enabled' : 'disabled'}',
      logGroup: PromajaLogGroup.notification,
    );
  }

  /// Triggered when the user taps the `Morning notification` checkbox
  Future<void> toggleMorningNotification() async {
    /// Update `state` and [Hive] with proper value

    final newState = !state.notification.morningNotification;

    await updateSettings(
      state.copyWith(
        notification: state.notification.copyWith(
          morningNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();

    hive.logPromajaEvent(
      text: 'Morning notification -> ${newState ? 'enabled' : 'disabled'}',
      logGroup: PromajaLogGroup.notification,
    );
  }

  /// Triggered when the user taps the `Evening notification` checkbox
  Future<void> toggleEveningNotification() async {
    /// Update `state` and [Hive] with proper value

    final newState = !state.notification.eveningNotification;

    await updateSettings(
      state.copyWith(
        notification: state.notification.copyWith(
          eveningNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();

    hive.logPromajaEvent(
      text: 'Evening notification -> ${newState ? 'enabled' : 'disabled'}',
      logGroup: PromajaLogGroup.notification,
    );
  }

  ///
  /// UNITS
  ///

  /// Opens popup menu which chooses temperature units to be used
  Future<TemperatureUnit?> showTemperatureUnitPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const temperatureUnits = TemperatureUnit.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: temperatureUnits
          .map(
            (temperatureUnit) => PopupMenuItem(
              value: temperatureUnit,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizeTemperature(temperatureUnit),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates temperature unit to be used
  Future<void> updateTemperatureUnit(TemperatureUnit newTemperature) async => updateSettings(
        state.copyWith(
          unit: state.unit.copyWith(
            temperature: newTemperature,
          ),
        ),
      );

  /// Opens popup menu which chooses distance & speed units to be used
  Future<DistanceSpeedUnit?> showDistanceSpeedUnitPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const distanceSpeedUnits = DistanceSpeedUnit.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: distanceSpeedUnits
          .map(
            (distanceSpeedUnit) => PopupMenuItem(
              value: distanceSpeedUnit,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizeDistanceSpeed(distanceSpeedUnit),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates distance & speed unit to be used
  Future<void> updateDistanceSpeedUnit(DistanceSpeedUnit newDistanceSpeed) async => updateSettings(
        state.copyWith(
          unit: state.unit.copyWith(
            distanceSpeed: newDistanceSpeed,
          ),
        ),
      );

  /// Opens popup menu which chooses precipitation units to be used
  Future<PrecipitationUnit?> showPrecipitationUnitPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const precipitationUnits = PrecipitationUnit.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: precipitationUnits
          .map(
            (precipitationUnit) => PopupMenuItem(
              value: precipitationUnit,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizePrecipitation(precipitationUnit),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates precipitation unit to be used
  Future<void> updatePrecipitationUnit(PrecipitationUnit newPrecipitation) async => updateSettings(
        state.copyWith(
          unit: state.unit.copyWith(
            precipitation: newPrecipitation,
          ),
        ),
      );

  /// Opens popup menu which chooses pressure units to be used
  Future<PressureUnit?> showPressureUnitPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const pressureUnits = PressureUnit.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: pressureUnits
          .map(
            (pressureUnit) => PopupMenuItem(
              value: pressureUnit,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizePressure(pressureUnit),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates pressure unit to be used
  Future<void> updatePressureUnit(PressureUnit newPressureUnit) async => updateSettings(
        state.copyWith(
          unit: state.unit.copyWith(
            pressure: newPressureUnit,
          ),
        ),
      );

  ///
  /// WIDGET
  ///

  /// Opens popup menu which chooses location to be used in widget
  Future<Location?> showWidgetLocationPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    final locations = hive.getLocationsFromBox();

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: locations
          .map(
            (location) => PopupMenuItem(
              value: location,
              padding: const EdgeInsets.all(20),
              child: Text(
                '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in widget
  Future<void> updateWidgetLocation(Location newLocation) async => updateSettings(
        state.copyWith(
          widget: state.widget.copyWith(
            location: newLocation,
          ),
        ),
      );

  /// Opens popup menu which chooses weather type to be used in widget
  Future<WeatherType?> showWidgetWeatherTypePopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const weatherTypes = WeatherType.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: weatherTypes
          .map(
            (weatherType) => PopupMenuItem(
              value: weatherType,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizeWeatherType(weatherType),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates weather type to be used in widget
  Future<void> updateWidgetWeatherType(WeatherType newWeatherType) async => updateSettings(
        state.copyWith(
          widget: state.widget.copyWith(
            weatherType: newWeatherType,
          ),
        ),
      );
}
