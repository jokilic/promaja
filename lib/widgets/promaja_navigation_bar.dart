import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../constants/durations.dart';
import '../constants/icons.dart';
import '../screens/cards/cards_screen.dart';
import '../services/hive_service.dart';

final navigationBarIndexProvider = StateNotifierProvider<PromajaNavigationBarController, int>(
  (ref) => PromajaNavigationBarController(
    hiveService: ref.watch(hiveProvider.notifier),
  ),
  name: 'NavigationBarIndexProvider',
);

enum NavigationBarItems { cards, weather, list }

class PromajaNavigationBarController extends StateNotifier<int> {
  final HiveService hiveService;

  PromajaNavigationBarController({
    required this.hiveService,
  }) : super(hiveService.getLocationsFromBox().isEmpty ? NavigationBarItems.list.index : NavigationBarItems.cards.index);

  void changeNavigationBarIndex(int newIndex) => state = hiveService.getLocationsFromBox().isEmpty ? NavigationBarItems.list.index : NavigationBarItems.values[newIndex].index;
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
              PromajaIcons.cards,
              height: 20,
              width: 20,
              color: PromajaColors.white.withOpacity(0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.cards,
              height: 20,
              width: 20,
              color: PromajaColors.white,
            ),
            label: 'Home',
          ),

          ///
          /// WEATHER
          ///
          NavigationDestination(
            icon: Image.asset(
              PromajaIcons.pressure,
              height: 20,
              width: 20,
              color: PromajaColors.white.withOpacity(0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.pressure,
              height: 20,
              width: 20,
              color: PromajaColors.white,
            ),
            label: 'Weather',
          ),

          ///
          /// LIST
          ///
          NavigationDestination(
            icon: Image.asset(
              PromajaIcons.search,
              height: 20,
              width: 20,
              color: PromajaColors.white.withOpacity(0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.search,
              height: 20,
              width: 20,
              color: PromajaColors.white,
            ),
            label: 'Search',
          ),
        ],
      );
}
