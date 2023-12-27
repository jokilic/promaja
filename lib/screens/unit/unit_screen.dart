import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

class UnitScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    PromajaBackButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ///
              /// UNITS TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'unitsTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// UNITS DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'unitsDescription'.tr(),
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

                    ref.read(hiveProvider.notifier).logPromajaEvent(
                          text: 'Temperature -> ${newTemperature.name}',
                          logGroup: PromajaLogGroup.unit,
                        );
                  }
                },
                activeValue: localizeTemperature(settings.unit.temperature),
                subtitle: 'unitsTemperatureSubtitle'.tr(),
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

                    ref.read(hiveProvider.notifier).logPromajaEvent(
                          text: 'Distance & speed -> ${newDistanceSpeed.name}',
                          logGroup: PromajaLogGroup.unit,
                        );
                  }
                },
                activeValue: localizeDistanceSpeed(settings.unit.distanceSpeed),
                subtitle: 'unitsDistanceSpeedSubtitle'.tr(),
              ),

              ///
              /// PRECIPITATION
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newPrecipitation = await ref.read(settingsProvider.notifier).showPrecipitationUnitPopupMenu(context);

                  if (newPrecipitation != null) {
                    await ref.read(settingsProvider.notifier).updatePrecipitationUnit(newPrecipitation);

                    ref.read(hiveProvider.notifier).logPromajaEvent(
                          text: 'Precipitation -> ${newPrecipitation.name}',
                          logGroup: PromajaLogGroup.unit,
                        );
                  }
                },
                activeValue: localizePrecipitation(settings.unit.precipitation),
                subtitle: 'unitsPrecipitationSubtitle'.tr(),
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

                    ref.read(hiveProvider.notifier).logPromajaEvent(
                          text: 'Pressure -> ${newPressure.name}',
                          logGroup: PromajaLogGroup.unit,
                        );
                  }
                },
                activeValue: localizePressure(settings.unit.pressure),
                subtitle: 'unitsPressureSubtitle'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
