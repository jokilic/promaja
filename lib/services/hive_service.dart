import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/custom_color/custom_color.dart';
import '../models/location/location.dart';
import '../models/promaja_log/promaja_log.dart';
import '../models/promaja_log/promaja_log_level.dart';
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
import 'logger_service.dart';

final hiveProvider = StateNotifierProvider<HiveService, List<Location>>(
  (ref) => HiveService(
    ref.watch(loggerProvider),
  ),
  name: 'HiveProvider',
);

class HiveService extends StateNotifier<List<Location>> {
  final LoggerService logger;

  HiveService(this.logger) : super([]);

  ///
  /// VARIABLES
  ///

  late final Box<Location> locationsBox;
  late final Box<CustomColor> customColorsBox;
  late final Box<int> activeLocationIndexBox;
  late final Box<int> activeNavigationValueIndexToBox;
  late final Box<PromajaSettings> promajaSettingsBox;
  late final Box<NotificationLastShown> notificationLastShownBox;
  late final Box<PromajaLog> promajaLogBox;

  late final PromajaSettings defaultSettings;

  ///
  /// INIT
  ///

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(LocationAdapter().typeId)) {
      Hive.registerAdapter(LocationAdapter());
    }

    if (!Hive.isAdapterRegistered(CustomColorAdapter().typeId)) {
      Hive.registerAdapter(CustomColorAdapter());
    }

    if (!Hive.isAdapterRegistered(ColorAdapter().typeId)) {
      Hive.registerAdapter(ColorAdapter());
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

    if (!Hive.isAdapterRegistered(PromajaLogLevelAdapter().typeId)) {
      Hive.registerAdapter(PromajaLogLevelAdapter());
    }

    if (!Hive.isAdapterRegistered(PromajaLogAdapter().typeId)) {
      Hive.registerAdapter(PromajaLogAdapter());
    }

    locationsBox = await Hive.openBox<Location>('locationsBox');
    customColorsBox = await Hive.openBox<CustomColor>('customColorsBox');
    activeLocationIndexBox = await Hive.openBox<int>('activeLocationIndexBox');
    activeNavigationValueIndexToBox = await Hive.openBox<int>('activeNavigationValueIndexToBox');
    promajaSettingsBox = await Hive.openBox<PromajaSettings>('promajaSettingsBox');
    notificationLastShownBox = await Hive.openBox<NotificationLastShown>('notificationLastShownBox');
    promajaLogBox = await Hive.openBox<PromajaLog>('promajaLogBox');

    state = getLocationsFromBox();

    defaultSettings = PromajaSettings(
      notification: NotificationSettings(
        location: state.firstOrNull,
        hourlyNotification: false,
        morningNotification: false,
        eveningNotification: false,
      ),
      widget: WidgetSettings(
        location: state.firstOrNull,
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
  Future<void> dispose() async {
    super.dispose();

    await locationsBox.close();
    await customColorsBox.close();
    await activeLocationIndexBox.close();
    await activeNavigationValueIndexToBox.close();
    await promajaSettingsBox.close();
    await notificationLastShownBox.close();
    await promajaLogBox.close();

    await Hive.close();
  }

  ///
  /// METHODS
  ///

  /// Called to add a new `PromajaLog` value to [Hive]
  Future<void> addPromajaLogToBox({required PromajaLog promajaLog}) async => promajaLogBox.add(promajaLog);

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
  Future<void> addLocationToBox({required Location location, required int index}) async {
    state = [...state, location];
    await locationsBox.put(index, location);
  }

  /// Called to get all `PromajaLog` values from [Hive]
  List<PromajaLog> getPromajaLogsFromBox() => promajaLogBox.values.toList();

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
  Future<void> deleteLocationFromBox({required Location passedLocation, required int index}) async {
    state = [
      for (final location in state)
        if (location != passedLocation) location,
    ];
    await locationsBox.deleteAt(index);
  }

  /// Replace [Hive] box with passed `List<Location>`
  Future<void> writeAllLocationsToHive({required List<Location> locations}) async {
    /// Update `state`
    state = locations;

    /// Clear current [Hive] box
    await locationsBox.clear();

    /// Add passed `List<Location` to [Hive]
    for (var i = 0; i < locations.length; i++) {
      await addLocationToBox(location: locations[i], index: i);
    }

    /// Update `state` again (needed because issues with `GlobalKey`)
    state = locations;
  }

  /// Triggered when reordering locations in [ListScreen]
  Future<void> reorderLocations(int oldIndex, int newIndex) async {
    final hasPhoneLocation = state.any((location) => location.isPhoneLocation);

    /// User tried moving [AddLocationResult]
    /// User tried moving location below [AddLocationResult]
    if (oldIndex == state.length || newIndex > state.length) {
      return;
    }

    /// Phone location is active and user tried moving it or moving some location above it
    if (hasPhoneLocation && (oldIndex == 0 || newIndex == 0)) {
      return;
    }

    var index = newIndex;

    if (oldIndex < newIndex) {
      index -= 1;
    }

    /// Modify `state`
    final item = state.removeAt(oldIndex);
    state.insert(index, item);

    /// Modify [Hive]
    await locationsBox.clear();
    for (var i = 0; i < state.length; i++) {
      await locationsBox.put(i, state[i]);
    }
  }
}
