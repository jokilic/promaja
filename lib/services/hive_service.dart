import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../models/custom_color/custom_color.dart';
import '../models/location/location.dart';
import '../models/settings/appearance/appearance_settings.dart';
import '../models/settings/appearance/initial_section.dart';
import '../models/settings/appearance/weather_card_layout.dart';
import '../models/settings/notification/notification_last_shown.dart';
import '../models/settings/notification/notification_settings.dart';
import '../models/settings/promaja_settings.dart';
import '../models/settings/units/distance_speed_unit.dart';
import '../models/settings/units/precipitation_unit.dart';
import '../models/settings/units/pressure_unit.dart';
import '../models/settings/units/temperature_unit.dart';
import '../models/settings/units/unit_settings.dart';
import '../models/settings/widget/weather_type.dart';
import '../models/settings/widget/widget_settings.dart';
import '../util/path.dart';

class HiveService extends ValueNotifier<List<Location>> implements Disposable {
  HiveService() : super([]);

  ///
  /// INIT
  ///

  Future<void> init() async {
    final directory = await getHiveDirectory();

    Hive.init(directory?.path);

    if (!Hive.isAdapterRegistered(LocationAdapter().typeId)) {
      Hive.registerAdapter(LocationAdapter());
    }

    if (!Hive.isAdapterRegistered(CustomColorAdapter().typeId)) {
      Hive.registerAdapter(CustomColorAdapter());
    }

    if (!Hive.isAdapterRegistered(ColorAdapter().typeId)) {
      Hive.registerAdapter(ColorAdapter());
    }

    if (!Hive.isAdapterRegistered(AppearanceSettingsAdapter().typeId)) {
      Hive.registerAdapter(AppearanceSettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(NotificationSettingsAdapter().typeId)) {
      Hive.registerAdapter(NotificationSettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(WidgetSettingsAdapter().typeId)) {
      Hive.registerAdapter(WidgetSettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(WeatherTypeAdapter().typeId)) {
      Hive.registerAdapter(WeatherTypeAdapter());
    }

    if (!Hive.isAdapterRegistered(UnitSettingsAdapter().typeId)) {
      Hive.registerAdapter(UnitSettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(InitialSectionAdapter().typeId)) {
      Hive.registerAdapter(InitialSectionAdapter());
    }

    if (!Hive.isAdapterRegistered(WeatherCardLayoutAdapter().typeId)) {
      Hive.registerAdapter(WeatherCardLayoutAdapter());
    }

    if (!Hive.isAdapterRegistered(TemperatureUnitAdapter().typeId)) {
      Hive.registerAdapter(TemperatureUnitAdapter());
    }

    if (!Hive.isAdapterRegistered(DistanceSpeedUnitAdapter().typeId)) {
      Hive.registerAdapter(DistanceSpeedUnitAdapter());
    }

    if (!Hive.isAdapterRegistered(PrecipitationUnitAdapter().typeId)) {
      Hive.registerAdapter(PrecipitationUnitAdapter());
    }

    if (!Hive.isAdapterRegistered(PressureUnitAdapter().typeId)) {
      Hive.registerAdapter(PressureUnitAdapter());
    }

    if (!Hive.isAdapterRegistered(PromajaSettingsAdapter().typeId)) {
      Hive.registerAdapter(PromajaSettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(NotificationLastShownAdapter().typeId)) {
      Hive.registerAdapter(NotificationLastShownAdapter());
    }

    locationsBox = await Hive.openBox<Location>('locationsBox');
    customColorsBox = await Hive.openBox<CustomColor>('customColorsBox');
    activeLocationIndexBox = await Hive.openBox<int>('activeLocationIndexBox');
    activeNavigationValueIndexToBox = await Hive.openBox<int>('activeNavigationValueIndexToBox');
    promajaSettingsBox = await Hive.openBox<PromajaSettings>('promajaSettingsBox');
    notificationLastShownBox = await Hive.openBox<NotificationLastShown>('notificationLastShownBox');

    value = getLocationsFromBox();

    defaultSettings = PromajaSettings(
      appearance: AppearanceSettings(
        initialSection: InitialSection.lastOpened,
        weatherSummaryFirst: true,
        weatherCardLayout: WeatherCardLayout.stacked,
      ),
      notification: NotificationSettings(
        location: value.firstOrNull,
        hourlyNotification: false,
        morningNotification: false,
        eveningNotification: false,
      ),
      widget: WidgetSettings(
        location: value.firstOrNull,
        weatherType: WeatherType.current,
      ),
      unit: UnitSettings(
        temperature: TemperatureUnit.celsius,
        distanceSpeed: DistanceSpeedUnit.kilometers,
        precipitation: PrecipitationUnit.millimeters,
        pressure: PressureUnit.hectopascal,
      ),
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    await locationsBox.close();
    await customColorsBox.close();
    await activeLocationIndexBox.close();
    await activeNavigationValueIndexToBox.close();
    await promajaSettingsBox.close();
    await notificationLastShownBox.close();

    await Hive.close();
  }

  ///
  /// VARIABLES
  ///

  late final Box<Location> locationsBox;
  late final Box<CustomColor> customColorsBox;
  late final Box<int> activeLocationIndexBox;
  late final Box<int> activeNavigationValueIndexToBox;
  late final Box<PromajaSettings> promajaSettingsBox;
  late final Box<NotificationLastShown> notificationLastShownBox;

  late final PromajaSettings defaultSettings;

  ///
  /// METHODS
  ///

  /// Called to add a new active navigation value index to [Hive]
  Future<void> addActiveNavigationValueIndexToBox({required int index}) async => activeNavigationValueIndexToBox.put(0, index);

  /// Called to add new settings value to [Hive]
  Future<void> addPromajaSettingsToBox({required PromajaSettings promajaSettings}) async => promajaSettingsBox.put(0, promajaSettings);

  /// Called to add new navigation last shown to [Hive]
  Future<void> addNotificationLastShownToBox({required NotificationLastShown notificationLastShown}) async => notificationLastShownBox.put(0, notificationLastShown);

  /// Called to add a new active [Location] index to [Hive]
  Future<void> addActiveLocationIndexToBox({required int index}) async => activeLocationIndexBox.put(0, index);

  /// Called to add [CustomColor] to [Hive]
  Future<void> addCustomColorToBox({required CustomColor customColor}) async {
    /// Generate `key`
    final isDay = customColor.isDay ? 'day' : 'night';
    final key = '${customColor.code}_$isDay';

    /// Add value to [Hive]
    await customColorsBox.delete(key);
    await customColorsBox.put(key, customColor);
  }

  /// Called to delete [CustomColor] from [Hive]
  Future<void> deleteCustomColorFromBox({required CustomColor customColor}) async {
    /// Generate `key`
    final isDay = customColor.isDay ? 'day' : 'night';
    final key = '${customColor.code}_$isDay';

    /// Delete value from [Hive]
    await customColorsBox.delete(key);
  }

  /// Called to add a new [Location] value to [Hive]
  Future<void> addLocationToBox({
    required Location location,
    required int index,
  }) async {
    final isFirstLocation = value.isEmpty;

    value = [...value, location];
    await locationsBox.put(index, location);

    if (isFirstLocation) {
      await updateSettingsForFirstLocation(
        location: location,
      );
    }
  }

  /// Uses the first added [Location] for settings that require a location
  Future<void> updateSettingsForFirstLocation({required Location location}) async {
    final settings = getPromajaSettingsFromBox();

    await addPromajaSettingsToBox(
      promajaSettings: settings.copyWith(
        notification: settings.notification.copyWith(
          location: location,
        ),
        widget: settings.widget.copyWith(
          location: location,
        ),
      ),
    );
  }

  /// Updates settings when a saved [Location] is replaced or removed
  Future<void> updateSettingsForChangedLocation({
    required Location oldLocation,
    required Location? newLocation,
  }) async {
    final settings = getPromajaSettingsFromBox();
    final oldLocationIsPhoneLocation = oldLocation.isPhoneLocation ?? false;
    final notificationUsesOldLocation = settings.notification.location == oldLocation || (oldLocationIsPhoneLocation && (settings.notification.location?.isPhoneLocation ?? false));
    final widgetUsesOldLocation = settings.widget.location == oldLocation || (oldLocationIsPhoneLocation && (settings.widget.location?.isPhoneLocation ?? false));

    if (!notificationUsesOldLocation && !widgetUsesOldLocation) {
      return;
    }

    await addPromajaSettingsToBox(
      promajaSettings: settings.copyWith(
        notification: NotificationSettings(
          location: notificationUsesOldLocation ? newLocation : settings.notification.location,
          hourlyNotification: settings.notification.hourlyNotification,
          morningNotification: settings.notification.morningNotification,
          eveningNotification: settings.notification.eveningNotification,
        ),
        widget: WidgetSettings(
          location: widgetUsesOldLocation ? newLocation : settings.widget.location,
          weatherType: settings.widget.weatherType,
        ),
      ),
    );
  }

  /// Gets current active location from [Hive]
  Location? getActiveLocation() {
    final locations = getLocationsFromBox();
    final activeLocationIndex = getActiveLocationIndexFromBox();

    final activeLocation = locations.elementAtOrNull(activeLocationIndex);

    return activeLocation;
  }

  /// Called to get all [Location] values from [Hive]
  List<Location> getLocationsFromBox() => locationsBox.values.toList();

  /// Called to get all [CustomColor] values from [Hive]
  List<CustomColor> getCustomColorsFromBox() => customColorsBox.values.toList();

  /// Called to get active location index from [Hive]
  int getActiveLocationIndexFromBox() => activeLocationIndexBox.get(0) ?? 0;

  /// Called to get active navigation value index from [Hive]
  int? getActiveNavigationValueIndexFromBox() => activeNavigationValueIndexToBox.get(0);

  /// Called to get settings from [Hive]
  PromajaSettings getPromajaSettingsFromBox() => promajaSettingsBox.get(0) ?? defaultSettings;

  /// Called to get notification last shown from [Hive]
  NotificationLastShown? getNotificationLastShownFromBox() => notificationLastShownBox.get(0);

  /// Called to delete a [Location] value from [Hive]
  Future<void> deleteLocationFromBox({required int index}) async {
    final oldLocation = value[index];
    final locations = List<Location>.from(value)..removeAt(index);

    await writeAllLocationsToHive(
      locations: locations,
    );

    await updateSettingsForChangedLocation(
      oldLocation: oldLocation,
      newLocation: locations.firstOrNull,
    );
  }

  /// Called to replace a [Location] value in [Hive]
  Future<void> replaceLocationInBox({
    required int index,
    required Location location,
  }) async {
    final oldLocation = value[index];
    final locations = List<Location>.from(value);
    locations[index] = location;

    await writeAllLocationsToHive(
      locations: locations,
    );

    await updateSettingsForChangedLocation(
      oldLocation: oldLocation,
      newLocation: location,
    );
  }

  /// Replace [Hive] box with passed `List<Location>`
  Future<void> writeAllLocationsToHive({required List<Location> locations}) async {
    final isAddingFirstLocation = value.isEmpty && locations.isNotEmpty;

    /// Update `state`
    value = List<Location>.from(locations);

    /// Clear current [Hive] box
    await locationsBox.clear();

    /// Add passed `List<Location>` to [Hive] without appending to `state`
    for (var i = 0; i < locations.length; i++) {
      await locationsBox.put(i, locations[i]);
    }

    if (isAddingFirstLocation) {
      await updateSettingsForFirstLocation(
        location: locations.first,
      );
    }
  }

  /// Triggered when reordering locations in [ListScreen]
  Future<void> reorderLocations(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= value.length) {
      return;
    }

    final locations = List<Location>.from(value);
    final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    /// Clamp the drop index because [ListScreen] includes a trailing empty item.
    final insertIndex = adjustedNewIndex.clamp(0, locations.length - 1).toInt();

    if (oldIndex == insertIndex) {
      return;
    }

    /// Modify `state`
    final item = locations.removeAt(oldIndex);
    locations.insert(insertIndex, item);

    /// Update all locations in [Hive]
    await writeAllLocationsToHive(locations: locations);
  }
}
