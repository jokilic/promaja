import 'package:flutter/material.dart';

import '../models/settings/appearance/initial_section.dart';
import '../screens/cards/cards_screen.dart';
import '../screens/list/list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/weather/weather_screen.dart';
import 'hive_service.dart';
import 'logger_service.dart';

enum NavigationBarItem {
  cards,
  weather,
  list,
  settings,
}

class ScreenService extends ValueNotifier<NavigationBarItem> {
  final LoggerService logger;
  final HiveService hive;

  ScreenService({
    required this.logger,
    required this.hive,
  }) : super(NavigationBarItem.list) {
    value = getInitialNavigationBarItem();
  }

  ///
  /// METHODS
  ///

  /// Returns proper [Widget] and updates `state`, depending on [NavigationBarItem]
  Widget getProperWidget(NavigationBarItem item) {
    final newScreen = switch (item) {
      NavigationBarItem.cards => CardsScreen(),
      NavigationBarItem.weather => WeatherScreen(),
      NavigationBarItem.list => ListScreen(),
      NavigationBarItem.settings => SettingsScreen(),
    };

    return newScreen;
  }

  /// Returns proper [NavigationBarItem], depending on locations and previously opened screen
  NavigationBarItem getInitialNavigationBarItem() {
    final indexValue = hive.getActiveNavigationValueIndexFromBox();

    /// No locations, go to [ListScreen]
    if (hive.getLocationsFromBox().isEmpty) {
      return NavigationBarItem.list;
    }

    /// Get initial section
    final initialSection = hive.getPromajaSettingsFromBox().appearance.initialSection;

    /// Initial section is not `last opened`, open the active one
    if (initialSection != InitialSection.lastOpened) {
      return switch (initialSection) {
        InitialSection.current => NavigationBarItem.cards,
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
    final newItem = hive.getLocationsFromBox().isEmpty ? NavigationBarItem.list : passedItem;
    final oldItem = getInitialNavigationBarItem();

    if (oldItem != newItem) {
      await hive.addActiveNavigationValueIndexToBox(
        index: newItem.index,
      );

      getProperWidget(newItem);
    }
  }
}
