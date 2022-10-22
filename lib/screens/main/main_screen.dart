import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/enums.dart';
import '../cities/cities_screen.dart';
import '../settings/settings_screen.dart';
import '../weather/weather_screen.dart';

final navigationScreenProvider = StateProvider(
  (_) => NavigationScreen.settings,
);

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationScreen = ref.watch(navigationScreenProvider);

    return Scaffold(
      body: Column(
        children: [
          ///
          /// Main content
          ///
          Expanded(
            child: Builder(
              builder: (context) {
                switch (navigationScreen) {
                  case NavigationScreen.weather:
                    return WeatherScreen();

                  case NavigationScreen.cities:
                    return CitiesScreen();

                  case NavigationScreen.settings:
                    return SettingsScreen();

                  default:
                    const SizedBox.shrink();
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          ///
          /// Button
          ///
          ElevatedButton(
            onPressed: () {
              ref.read(navigationScreenProvider.notifier).state = NavigationScreen.cities;
            },
            child: const Text('Change screen'),
          ),
        ],
      ),
    );
  }
}
