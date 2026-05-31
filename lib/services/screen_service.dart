import 'package:flutter/material.dart';

import '../models/settings/appearance/initial_section.dart';
import '../screens/current/current_screen.dart';
import '../screens/list/list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/weather/weather_screen.dart';
import 'hive_service.dart';

enum NavigationBarItem {
  current,
  weather,
  list,
  settings,
}

class ScreenService extends ValueNotifier<NavigationBarItem> {
  final HiveService hive;

  ScreenService({
    required this.hive,
  }) : super(NavigationBarItem.list) {
    value = getInitialNavigationBarItem();
  }

  ///
  /// METHODS
  ///

  /// Returns proper [Widget], depending on [NavigationBarItem]
  Widget getProperWidget(NavigationBarItem item) {
    final newScreen = switch (item) {
      NavigationBarItem.current => CurrentScreen(),
      NavigationBarItem.weather => WeatherScreen(
        originalLocation: hive.getActiveLocation(),
      ),
      NavigationBarItem.list => ListScreen(),
      NavigationBarItem.settings => SettingsScreen(),
    };

    return newScreen;
  }

  /// Returns proper [NavigationBarItem], depending on locations and previously opened screen
  NavigationBarItem getInitialNavigationBarItem() {
    final indexValue = hive.getActiveNavigationValueIndexFromBox();

    /// Get currently stored `locations`
    final locations = hive.getLocationsFromBox();

    /// No locations, go to [ListScreen]
    if (locations.isEmpty) {
      return NavigationBarItem.list;
    }

    /// Get initial section
    final initialSection = hive.getPromajaSettingsFromBox().appearance.initialSection;

    /// Initial section is not `last opened`, open the active one
    if (initialSection != InitialSection.lastOpened) {
      return switch (initialSection) {
        InitialSection.current => NavigationBarItem.current,
        InitialSection.forecast => NavigationBarItem.weather,
        InitialSection.list => NavigationBarItem.list,
        InitialSection.settings => NavigationBarItem.settings,
        _ => throw UnimplementedError(),
      };
    }

    /// Initial section is set to `last opened`, open section from [Hive]
    if (initialSection == InitialSection.lastOpened) {
      /// Return currently opened screen or `ListScreen` if there's no stored `index`
      return NavigationBarItem.values[indexValue ?? 3];
    }

    /// Return `ListScreen`
    return NavigationBarItem.list;
  }

  /// Triggered when navigation bar needs changing
  Future<void> changeNavigationBarItem(NavigationBarItem passedItem) async {
    /// Generate `newItem`
    final newItem = hive.getLocationsFromBox().isEmpty ? NavigationBarItem.list : passedItem;

    /// User pressed a different item
    if (value != newItem) {
      await hive.addActiveNavigationValueIndexToBox(
        index: newItem.index,
      );

      value = newItem;

      getProperWidget(newItem);
    }
  }
}
