import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/durations.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'widgets/list_cards.dart';
import 'widgets/list_empty.dart';

class ListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(hiveProvider);

    return Scaffold(
      bottomNavigationBar: PromajaNavigationBar(),
      body: Animate(
        key: ValueKey(ref.read(navigationBarIndexProvider)),
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: PromajaDurations.fadeAnimation,
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeIn,
            child: locations.isEmpty
                ? ListEmpty()
                : ListCards(
                    locations: locations,
                    showCelsius: ref.watch(hiveProvider.notifier).getPromajaSettingsFromBox().unit.temperature == TemperatureUnit.celsius,
                  ),
          ),
        ),
      ),
    );
  }
}
