import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../models/custom_color/custom_color.dart';
import '../models/location/location.dart';
import '../models/settings/appearance/appearance_settings.dart';
import '../models/settings/appearance/initial_section.dart';
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
import 'logger_service.dart';

final hiveProvider = NotifierProvider<HiveService, List<Location>>(
  HiveService.new,
  name: 'HiveProvider',
);

class HiveService extends Notifier<List<Location>> {
  late final logger = ref.read(loggerProvider);

  late final Box<Location> locationsBox;
  late final Box<CustomColor> customColorsBox;
  late final Box<int> activeLocationIndexBox;
  late final Box<int> activeNavigationValueIndexToBox;
  late final Box<PromajaSettings> promajaSettingsBox;
  late final Box<NotificationLastShown> notificationLastShownBox;
  late final Box<bool> notificationDialogShownBox;

  late final PromajaSettings defaultSettings;

  @override
  List<Location> build() {
    ref.onDispose(dispose);
    return const [];
  }

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
    notificationDialogShownBox = await Hive.openBox<bool>('notificationDialogShownBox');

    state = getLocationsFromBox();

    defaultSettings = PromajaSettings(
      appearance: AppearanceSettings(
        initialSection: InitialSection.lastOpened,
        weatherSummaryFirst: true,
      ),
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

  Future<void> dispose() async {
    await locationsBox.close();
    await customColorsBox.close();
    await activeLocationIndexBox.close();
    await activeNavigationValueIndexToBox.close();
    await promajaSettingsBox.close();
    await notificationLastShownBox.close();
    await notificationDialogShownBox.close();

    await Hive.close();
  }

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

  /// Called to add notification dialog shown to [Hive]
  Future<void> addNotificationDialogShownToBox() async => notificationDialogShownBox.put(0, true);

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
    state = [...state, location];
    await locationsBox.put(index, location);
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

  /// Called to get notification dialog shown from [Hive]
  bool getNotificationDialogShownFromBox() => notificationDialogShownBox.get(0) ?? false;

  /// Called to delete a [Location] value from [Hive]
  Future<void> deleteLocationFromBox({required int index}) => writeAllLocationsToHive(
    locations: List.from(state..removeAt(index)),
  );

  /// Replace [Hive] box with passed `List<Location>`
  Future<void> writeAllLocationsToHive({required List<Location> locations}) async {
    /// Update `state`
    state = locations;

    /// Clear current [Hive] box
    await locationsBox.clear();

    if (locations.isNotEmpty) {
      /// Add passed `List<Location` to [Hive]
      for (var i = 0; i < locations.length; i++) {
        await addLocationToBox(location: locations[i], index: i);
      }

      /// Update `state` again (needed because issues with `GlobalKey`)
      state = locations;
    }
  }

  /// Triggered when reordering locations in [ListScreen]
  Future<void> reorderLocations(int oldIndex, int newIndex) async {
    /// Modify `state`
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);

    /// Update all locations in [Hive]
    await writeAllLocationsToHive(locations: state);
  }
}

class HiveInitializationResult {
  final Box<Location> locationsBox;
  final Box<CustomColor> customColorsBox;
  final Box<int> activeLocationIndexBox;
  final Box<int> activeNavigationValueIndexToBox;
  final Box<PromajaSettings> promajaSettingsBox;
  final Box<NotificationLastShown> notificationLastShownBox;
  final Box<bool> notificationDialogShownBox;

  HiveInitializationResult({
    required this.locationsBox,
    required this.customColorsBox,
    required this.activeLocationIndexBox,
    required this.activeNavigationValueIndexToBox,
    required this.promajaSettingsBox,
    required this.notificationLastShownBox,
    required this.notificationDialogShownBox,
  });

  Future<void> close() async {
    if (locationsBox.isOpen) {
      await locationsBox.close();
    }
    if (customColorsBox.isOpen) {
      await customColorsBox.close();
    }
    if (activeLocationIndexBox.isOpen) {
      await activeLocationIndexBox.close();
    }
    if (activeNavigationValueIndexToBox.isOpen) {
      await activeNavigationValueIndexToBox.close();
    }
    if (promajaSettingsBox.isOpen) {
      await promajaSettingsBox.close();
    }
    if (notificationLastShownBox.isOpen) {
      await notificationLastShownBox.close();
    }
    if (notificationDialogShownBox.isOpen) {
      await notificationDialogShownBox.close();
    }

    await Hive.close();
  }
}

Future<HiveInitializationResult> initializeHive({required LoggerService logger}) async {
  try {
    final directory = await getHiveDirectory();

    Hive.init(directory?.path);

    void registerAdapter(TypeAdapter<dynamic> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    registerAdapter(LocationAdapter());
    registerAdapter(CustomColorAdapter());
    registerAdapter(ColorAdapter());
    registerAdapter(AppearanceSettingsAdapter());
    registerAdapter(NotificationSettingsAdapter());
    registerAdapter(WidgetSettingsAdapter());
    registerAdapter(WeatherTypeAdapter());
    registerAdapter(UnitSettingsAdapter());
    registerAdapter(InitialSectionAdapter());
    registerAdapter(TemperatureUnitAdapter());
    registerAdapter(DistanceSpeedUnitAdapter());
    registerAdapter(PrecipitationUnitAdapter());
    registerAdapter(PressureUnitAdapter());
    registerAdapter(PromajaSettingsAdapter());
    registerAdapter(NotificationLastShownAdapter());

    final locationsBox = await Hive.openBox<Location>('locationsBox');
    final customColorsBox = await Hive.openBox<CustomColor>('customColorsBox');
    final activeLocationIndexBox = await Hive.openBox<int>('activeLocationIndexBox');
    final activeNavigationValueIndexToBox = await Hive.openBox<int>('activeNavigationValueIndexToBox');
    final promajaSettingsBox = await Hive.openBox<PromajaSettings>('promajaSettingsBox');
    final notificationLastShownBox = await Hive.openBox<NotificationLastShown>('notificationLastShownBox');
    final notificationDialogShownBox = await Hive.openBox<bool>('notificationDialogShownBox');

    return HiveInitializationResult(
      locationsBox: locationsBox,
      customColorsBox: customColorsBox,
      activeLocationIndexBox: activeLocationIndexBox,
      activeNavigationValueIndexToBox: activeNavigationValueIndexToBox,
      promajaSettingsBox: promajaSettingsBox,
      notificationLastShownBox: notificationLastShownBox,
      notificationDialogShownBox: notificationDialogShownBox,
    );
  } catch (e) {
    logger.e(e);
    rethrow;
  }
}
