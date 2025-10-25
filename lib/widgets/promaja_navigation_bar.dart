import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../constants/durations.dart';
import '../constants/icons.dart';
import '../models/settings/appearance/initial_section.dart';
import '../screens/cards/cards_notifiers.dart';
import '../screens/cards/cards_screen.dart';
import '../screens/list/list_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/weather/weather_notifiers.dart';
import '../screens/weather/weather_screen.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';

final navigationBarIndexProvider = StateNotifierProvider<PromajaNavigationBarController, int>(
  (ref) => PromajaNavigationBarController(
    logger: ref.watch(loggerProvider),
    hiveService: ref.watch(hiveProvider.notifier),
  ),
  name: 'NavigationBarIndexProvider',
);

final screenProvider = StateProvider.autoDispose<Widget>(
  (ref) {
    final navigationBarIndex = ref.watch(navigationBarIndexProvider);

    return switch (navigationBarIndex) {
      0 => CardsScreen(),
      1 => WeatherScreen(
        originalLocation: ref.watch(activeWeatherProvider),
      ),
      2 => MapScreen(),
      3 => ListScreen(),
      4 => SettingsScreen(),
      _ => ListScreen(),
    };
  },
  name: 'ScreenProvider',
);

enum NavigationBarItems {
  cards,
  weather,
  map,
  list,
  settings,
}

class PromajaNavigationBarController extends StateNotifier<int> {
  final LoggerService logger;
  final HiveService hiveService;

  PromajaNavigationBarController({
    required this.logger,
    required this.hiveService,
  }) : super(3) {
    state = getInitialNavigationBarIndex();
  }

  ///
  /// METHODS
  ///

  /// Returns proper initial index, depending on locations and previously opened screen
  int getInitialNavigationBarIndex() {
    final indexValue = hiveService.getActiveNavigationValueIndexFromBox();

    /// No locations, go to [ListScreen]
    if (hiveService.getLocationsFromBox().isEmpty) {
      return NavigationBarItems.list.index;
    }

    /// Get initial section
    final initialSection = hiveService.getPromajaSettingsFromBox().appearance.initialSection;

    /// Initial section is not `last opened`, open the active one
    if (initialSection != InitialSection.lastOpened) {
      return switch (initialSection) {
        InitialSection.current => 0,
        InitialSection.forecast => 1,
        InitialSection.map => 2,
        InitialSection.list => 3,
        InitialSection.settings => 4,
        InitialSection.lastOpened => 3,
      };
    }

    /// Initial section is set to `last opened`, open section from [Hive]
    if (initialSection == InitialSection.lastOpened) {
      /// Return currently opened screen or `ListScreen` if there's no stored `index`
      return indexValue ?? 3;
    }

    /// Return `ListScreen`
    return 3;
  }

  /// Triggered when navigation bar needs changing
  Future<void> changeNavigationBarIndex(int newIndex) async {
    final newState = hiveService.getLocationsFromBox().isEmpty ? NavigationBarItems.list.index : NavigationBarItems.values[newIndex].index;

    if (state != newState) {
      state = newState;
      await hiveService.addActiveNavigationValueIndexToBox(index: newIndex);
    }
  }
}

class PromajaNavigationBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(32),
    ),
    child: NavigationBar(
      backgroundColor: PromajaColors.black,
      elevation: 0,
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: ref.watch(navigationBarIndexProvider),
      onDestinationSelected: (newIndex) {
        if (ref.read(navigationBarIndexProvider) != newIndex) {
          ref.read(cardIndexProvider.notifier).state = 0;
          ref.read(weatherCardIndexProvider.notifier).state = 0;

          ref.read(navigationBarIndexProvider.notifier).changeNavigationBarIndex(NavigationBarItems.values[newIndex].index);
        }
      },
      animationDuration: PromajaDurations.navigationAnimation,
      destinations: [
        ///
        /// CARDS
        ///
        NavigationDestination(
          icon: Image.asset(
            PromajaIcons.globe,
            height: 20,
            width: 20,
            color: PromajaColors.white.withValues(alpha: 0.15),
          ),
          selectedIcon: Image.asset(
            PromajaIcons.globe,
            height: 20,
            width: 20,
            color: PromajaColors.white,
          ),
          label: '',
        ),

        ///
        /// WEATHER
        ///
        NavigationDestination(
          icon: Image.asset(
            PromajaIcons.temperature,
            height: 20,
            width: 20,
            color: PromajaColors.white.withValues(alpha: 0.15),
          ),
          selectedIcon: Image.asset(
            PromajaIcons.temperature,
            height: 20,
            width: 20,
            color: PromajaColors.white,
          ),
          label: '',
        ),

        ///
        /// MAP
        ///
        NavigationDestination(
          icon: Image.asset(
            PromajaIcons.map,
            height: 20,
            width: 20,
            color: PromajaColors.white.withValues(alpha: 0.15),
          ),
          selectedIcon: Image.asset(
            PromajaIcons.map,
            height: 20,
            width: 20,
            color: PromajaColors.white,
          ),
          label: '',
        ),

        ///
        /// LIST
        ///
        NavigationDestination(
          icon: Image.asset(
            PromajaIcons.list,
            height: 20,
            width: 20,
            color: PromajaColors.white.withValues(alpha: 0.15),
          ),
          selectedIcon: Image.asset(
            PromajaIcons.list,
            height: 20,
            width: 20,
            color: PromajaColors.white,
          ),
          label: '',
        ),

        ///
        /// SETTINGS
        ///
        NavigationDestination(
          icon: Image.asset(
            PromajaIcons.settings,
            height: 20,
            width: 20,
            color: PromajaColors.white.withValues(alpha: 0.15),
          ),
          selectedIcon: Image.asset(
            PromajaIcons.settings,
            height: 20,
            width: 20,
            color: PromajaColors.white,
          ),
          label: '',
        ),
      ],
    ),
  );
}
