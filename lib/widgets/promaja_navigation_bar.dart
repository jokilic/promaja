import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../constants/colors.dart';
import '../constants/durations.dart';
import '../constants/icons.dart';
import '../services/screen_service.dart';
import '../util/dependencies.dart';
import '../util/spacing.dart';

class PromajaNavigationBar extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final screen = getIt.get<ScreenService>();

    final navigationBarItem = watchIt<ScreenService>().value;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: NavigationBar(
        height: navigationBarHeight,
        backgroundColor: PromajaColors.black,
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        animationDuration: PromajaDurations.navigationAnimation,
        selectedIndex: navigationBarItem.index,
        onDestinationSelected: (newIndex) => screen.changeNavigationBarItem(
          NavigationBarItem.values[newIndex],
        ),
        destinations: [
          ///
          /// CARDS
          ///
          NavigationDestination(
            icon: Image.asset(
              PromajaIcons.globe,
              height: 22,
              width: 22,
              color: PromajaColors.white.withValues(alpha: 0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.globe,
              height: 22,
              width: 22,
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
              height: 22,
              width: 22,
              color: PromajaColors.white.withValues(alpha: 0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.temperature,
              height: 22,
              width: 22,
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
              height: 22,
              width: 22,
              color: PromajaColors.white.withValues(alpha: 0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.list,
              height: 22,
              width: 22,
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
              height: 22,
              width: 22,
              color: PromajaColors.white.withValues(alpha: 0.15),
            ),
            selectedIcon: Image.asset(
              PromajaIcons.settings,
              height: 22,
              width: 22,
              color: PromajaColors.white,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
