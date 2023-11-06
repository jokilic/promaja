import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/location/location.dart';
import 'logger_service.dart';

final hiveProvider = StateNotifierProvider<HiveService, List<Location>>(
  (_) => throw UnimplementedError(),
  name: 'HiveProvider',
);

class HiveService extends StateNotifier<List<Location>> {
  final LoggerService logger;

  HiveService(this.logger) : super([]);

  ///
  /// VARIABLES
  ///

  late final Box<Location> locationsBox;
  late final Box<int> activeLocationIndexBox;
  late final Box<int> activeNavigationValueIndexToBox;

  ///
  /// INIT
  ///

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LocationAdapter());
    locationsBox = await Hive.openBox<Location>('locationsBox');
    activeLocationIndexBox = await Hive.openBox<int>('activeLocationIndexBox');
    activeNavigationValueIndexToBox = await Hive.openBox<int>('activeNavigationValueIndexToBox');
    state = getLocationsFromBox();
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> dispose() async {
    super.dispose();
    await locationsBox.close();
    await activeLocationIndexBox.close();
    await activeNavigationValueIndexToBox.close();
    await Hive.close();
  }

  ///
  /// METHODS
  ///

  /// Called to add a new active navigation value index to [Hive]
  Future<void> addActiveNavigationValueIndexToBox({required int index}) async => activeNavigationValueIndexToBox.put(0, index);

  /// Called to add a new active [Location] index to [Hive]
  Future<void> addActiveLocationIndexToBox({required int index}) async => activeLocationIndexBox.put(0, index);

  /// Called to add a new [Location] value to [Hive]
  Future<void> addLocationToBox({required Location location, required int index}) async {
    state = [...state, location];
    await locationsBox.put(index, location);
  }

  /// Called to get all [Location] values from [Hive]
  List<Location> getLocationsFromBox() => locationsBox.values.toList();

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

  /// Deletes all [Location] values from [Hive]
  Future<void> deleteAllLocationsFromBox() async {
    state = [];
    await locationsBox.clear();
    await activeLocationIndexBox.clear();
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
