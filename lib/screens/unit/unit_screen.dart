import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

// TODO: Localize file
class UnitScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: AnimateList(
            interval: PromajaDurations.settingsInterval,
            effects: [
              FadeEffect(
                curve: Curves.easeIn,
                duration: PromajaDurations.fadeAnimation,
              ),
            ],
            children: [
              const SizedBox(height: 16),

              ///
              /// BACK BUTTON
              ///
              const Row(
                children: [
                  PromajaBackButton(),
                ],
              ),
              const SizedBox(height: 24),

              ///
              /// UNITS TITLE
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Units',
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// UNITS DESCRIPTION
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Update units which get shown for temperature, pressure, wind speed and similar.',
                  style: PromajaTextStyles.settingsText,
                ),
              ),

              ///
              /// DIVIDER
              ///
              const SizedBox(height: 24),
              const Divider(
                indent: 120,
                endIndent: 120,
                color: PromajaColors.white,
              ),
              const SizedBox(height: 8),

              ///
              /// TEMPERATURE
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newTemperature = await ref.read(settingsProvider.notifier).showTemperatureUnitPopupMenu(context);

                  if (newTemperature != null) {
                    await ref.read(settingsProvider.notifier).updateTemperatureUnit(newTemperature);
                  }
                },
                activeValue: settings.unit.temperature.name,
                subtitle: 'Unit which is used for temperature',
              ),

              ///
              /// DISTANCE / SPEED
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newDistanceSpeed = await ref.read(settingsProvider.notifier).showDistanceSpeedUnitPopupMenu(context);

                  if (newDistanceSpeed != null) {
                    await ref.read(settingsProvider.notifier).updateDistanceSpeedUnit(newDistanceSpeed);
                  }
                },
                activeValue: settings.unit.distanceSpeed.name,
                subtitle: 'Unit which is used for distance & speed',
              ),

              ///
              /// PRESSURE
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newPressure = await ref.read(settingsProvider.notifier).showPressureUnitPopupMenu(context);

                  if (newPressure != null) {
                    await ref.read(settingsProvider.notifier).updatePressureUnit(newPressure);
                  }
                },
                activeValue: settings.unit.pressure.name,
                subtitle: 'Unit which is used for pressure',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
