import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../constants/durations.dart';
import '../constants/icons.dart';
import '../screens/cards/cards_notifiers.dart';
import '../screens/cards/cards_screen.dart';
import '../screens/list/list_screen.dart';
import '../screens/weather/weather_notifiers.dart';
import '../screens/weather/weather_screen.dart';
import '../services/hive_service.dart';

final navigationBarIndexProvider = StateNotifierProvider<PromajaNavigationBarController, int>(
  (ref) => PromajaNavigationBarController(
    hiveService: ref.watch(hiveProvider.notifier),
  ),
  name: 'NavigationBarIndexProvider',
);

final screenProvider = StateProvider.autoDispose<Widget>(
  (ref) => switch (ref.watch(navigationBarIndexProvider)) {
    0 => CardsScreen(),
    1 => WeatherScreen(
        originalLocation: ref.watch(activeWeatherProvider),
      ),
    _ => ListScreen(),
  },
  name: 'ScreenProvider',
);

enum NavigationBarItems { cards, weather, list }

class PromajaNavigationBarController extends StateNotifier<int> {
  final HiveService hiveService;

  PromajaNavigationBarController({
    required this.hiveService,
  }) : super(
          hiveService.getLocationsFromBox().isEmpty ? NavigationBarItems.list.index : hiveService.activeNavigationValueIndexToBox.get(0) ?? 0,
        );

  ///
  /// METHODS
  ///

  Future<void> changeNavigationBarIndex(int newIndex) async {
    state = hiveService.getLocationsFromBox().isEmpty ? NavigationBarItems.list.index : NavigationBarItems.values[newIndex].index;
    await hiveService.addActiveNavigationValueIndexToBox(index: newIndex);
  }
}

class PromajaNavigationBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: ref.watch(navigationBarIndexProvider),
        onDestinationSelected: (newIndex) {
          if (ref.read(navigationBarIndexProvider) != newIndex) {
            ref.read(cardIndexProvider.notifier).state = 0;
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
              color: PromajaColors.white.withOpacity(0.15),
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
              color: PromajaColors.white.withOpacity(0.15),
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
          /// LIST
          ///
          NavigationDestination(
            icon: Image.asset(
              PromajaIcons.list,
              height: 20,
              width: 20,
              color: PromajaColors.white.withOpacity(0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.list,
              height: 20,
              width: 20,
              color: PromajaColors.white,
            ),
            label: '',
          ),
        ],
      );
}
