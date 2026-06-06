import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/location/location.dart';
import '../../models/settings/appearance/initial_section.dart';
import '../../models/settings/appearance/weather_card_layout.dart';
import '../../models/settings/promaja_settings.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../models/settings/widget/weather_type.dart';
import '../../services/hive_service.dart';
import '../../services/notification_service.dart';

class SettingsController extends ValueNotifier<PromajaSettings> {
  final HiveService hive;
  final NotificationService notification;

  SettingsController({
    required this.hive,
    required this.notification,
  }) : super(
         hive.getPromajaSettingsFromBox(),
       );

  ///
  /// VARIABLES
  ///

  TapDownDetails? tapDownDetails;

  ///
  /// METHODS
  ///

  /// Updates settings with new [PromajaSettings]
  Future<void> updateSettings(PromajaSettings newSettings) async {
    value = newSettings;
    await hive.addPromajaSettingsToBox(
      promajaSettings: newSettings,
    );
  }

  ///
  /// APPEARANCE
  ///

  /// Opens popup menu which chooses initial section to be used
  Future<InitialSection?> showInitialSectionPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const initialSections = InitialSection.values;

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
      items: initialSections
          .map(
            (initialSection) => PopupMenuItem(
              value: initialSection,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizeInitialSection(initialSection),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates initial section to be used
  Future<void> updateInitialSection(InitialSection newSection) async => updateSettings(
    value.copyWith(
      appearance: value.appearance.copyWith(
        initialSection: newSection,
      ),
    ),
  );

  /// Opens popup menu which chooses how weather cards should be displayed
  Future<WeatherCardLayout?> showWeatherCardLayoutPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const weatherCardLayouts = WeatherCardLayout.values;

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
      items: weatherCardLayouts
          .map(
            (weatherCardLayout) => PopupMenuItem(
              value: weatherCardLayout,
              padding: const EdgeInsets.all(20),
              child: Text(
                localizeWeatherCardLayout(weatherCardLayout),
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates how weather cards should be displayed
  Future<void> updateWeatherCardLayout(WeatherCardLayout newWeatherCardLayout) async => updateSettings(
    value.copyWith(
      appearance: value.appearance.copyWith(
        weatherCardLayout: newWeatherCardLayout,
      ),
    ),
  );

  /// Opens popup menu which chooses language to be used
  Future<Locale?> showLanguagePopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

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
      items: [
        PopupMenuItem(
          value: const Locale('hr'),
          padding: const EdgeInsets.all(20),
          child: Text(
            'appearanceLanguageHr'.tr(),
            style: PromajaTextStyles.settingsPopupMenuItem,
          ),
        ),
        PopupMenuItem(
          value: const Locale('en'),
          padding: const EdgeInsets.all(20),
          child: Text(
            'appearanceLanguageEn'.tr(),
            style: PromajaTextStyles.settingsPopupMenuItem,
          ),
        ),
      ],
    );
  }

  /// Triggered when the user taps the `Weather summary first` checkbox
  Future<void> toggleWeatherSummaryFirst() async {
    /// Update `state` and [Hive] with proper value
    final newState = !value.appearance.weatherSummaryFirst;

    await updateSettings(
      value.copyWith(
        appearance: value.appearance.copyWith(
          weatherSummaryFirst: newState,
        ),
      ),
    );
  }

  ///
  /// NOTIFICATIONS
  ///

  /// Opens popup menu which chooses location to be used in notifications
  Future<Location?> showNotificationLocationPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    /// Get currently stored `locations`
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
                (location.isPhoneLocation ?? false) ? 'notificatioPhoneLocationChosen'.tr() : '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in notifications
  Future<void> updateNotificationLocation(Location newLocation) async => updateSettings(
    value.copyWith(
      notification: value.notification.copyWith(
        location: newLocation,
      ),
    ),
  );

  /// Triggered when the user taps the `Hourly notification` checkbox
  Future<void> toggleHourlyNotification() async {
    /// Update `state` and [Hive] with proper value
    final newState = !value.notification.hourlyNotification;

    await updateSettings(
      value.copyWith(
        notification: value.notification.copyWith(
          hourlyNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();
  }

  /// Triggered when the user taps the `Morning notification` checkbox
  Future<void> toggleMorningNotification() async {
    /// Update `state` and [Hive] with proper value

    final newState = !value.notification.morningNotification;

    await updateSettings(
      value.copyWith(
        notification: value.notification.copyWith(
          morningNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();
  }

  /// Triggered when the user taps the `Evening notification` checkbox
  Future<void> toggleEveningNotification() async {
    /// Update `state` and [Hive] with proper value

    final newState = !value.notification.eveningNotification;

    await updateSettings(
      value.copyWith(
        notification: value.notification.copyWith(
          eveningNotification: newState,
        ),
      ),
    );

    /// Initialize notifications if necessary
    await notification.init();
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
    value.copyWith(
      unit: value.unit.copyWith(
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
    value.copyWith(
      unit: value.unit.copyWith(
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
    value.copyWith(
      unit: value.unit.copyWith(
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
    value.copyWith(
      unit: value.unit.copyWith(
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

    /// Get currently stored `locations`
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
                (location.isPhoneLocation ?? false) ? 'notificatioPhoneLocationChosen'.tr() : '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in widget
  Future<void> updateWidgetLocation(Location newLocation) async => updateSettings(
    value.copyWith(
      widget: value.widget.copyWith(
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
    value.copyWith(
      widget: value.widget.copyWith(
        weatherType: newWeatherType,
      ),
    ),
  );
}
