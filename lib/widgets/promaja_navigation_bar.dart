import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';
import '../screens/cards/cards_screen.dart';
import '../services/hive_service.dart';

final navigationBarIndexProvider = StateNotifierProvider<PromajaNavigationBarController, int>(
  (ref) => PromajaNavigationBarController(
    hiveService: ref.watch(hiveProvider.notifier),
  ),
  name: 'NavigationBarIndexProvider',
);

class PromajaNavigationBarController extends StateNotifier<int> {
  final HiveService hiveService;

  PromajaNavigationBarController({
    required this.hiveService,
  }) : super(hiveService.getLocationsFromBox().isEmpty ? 1 : 0);

  void changeNavigationBarIndex(int newIndex) => state = hiveService.getLocationsFromBox().isEmpty ? 1 : newIndex;
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
            ref.read(navigationBarIndexProvider.notifier).changeNavigationBarIndex(newIndex);
          }
        },
        animationDuration: const Duration(milliseconds: 300),
        destinations: [
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
