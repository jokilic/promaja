import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/location/location.dart';
import '../../models/settings/promaja_settings.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final settingsProvider = StateNotifierProvider.autoDispose<SettingsNotifier, PromajaSettings>(
  (ref) => SettingsNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'SettingsProvider',
);

class SettingsNotifier extends StateNotifier<PromajaSettings> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  SettingsNotifier({
    required this.logger,
    required this.hive,
  }) : super(hive.getPromajaSettingsFromBox())

  ///
  /// INIT
  ///

  {
    /// Notification location is `null`, set it to the first location from [Hive]
    if (state.notification.location == null) {
      final locations = hive.getLocationsFromBox();
      if (locations.isNotEmpty) {
        updateNotificationLocation(locations.first);
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
  /// NOTIFICATION
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
              onTap: () {},
              child: Text(
                '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in Notification
  Future<void> updateNotificationLocation(Location newLocation) async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            location: newLocation,
          ),
        ),
      );

  /// Triggered when the user taps the `Hourly notification` checkbox
  Future<void> toggleHourlyNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            hourlyNotification: !state.notification.hourlyNotification,
          ),
        ),
      );

  /// Triggered when the user taps the `Morning notification` checkbox
  Future<void> toggleMonthlyNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            morningNotification: !state.notification.morningNotification,
          ),
        ),
      );

  /// Triggered when the user taps the `Evening notification` checkbox
  Future<void> toggleEveningNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            eveningNotification: !state.notification.eveningNotification,
          ),
        ),
      );

  ///
  /// TEMPERATURE
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
              onTap: () {},
              child: Text(
                temperatureUnit.name,
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

  ///
  /// DISTANCE & SPEED
  ///

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
              onTap: () {},
              child: Text(
                distanceSpeedUnit.name,
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

  ///
  /// PRESSURE
  ///

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
              onTap: () {},
              child: Text(
                pressureUnit.name,
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
}
