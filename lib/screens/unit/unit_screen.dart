import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../util/dependencies.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_controller.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

class UnitScreen extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final settings = getIt.get<SettingsController>();
    final settingsState = watchIt<SettingsController>().value;

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
                onTapDown: (details) => settings.tapDownDetails = details,
                onTapUp: (_) async {
                  final newTemperature = await settings.showTemperatureUnitPopupMenu(context);

                  if (newTemperature != null) {
                    await settings.updateTemperatureUnit(newTemperature);
                  }
                },
                activeValue: localizeTemperature(settingsState.unit.temperature),
                subtitle: 'unitsTemperatureSubtitle'.tr(),
              ),

              ///
              /// DISTANCE / SPEED
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => settings.tapDownDetails = details,
                onTapUp: (_) async {
                  final newDistanceSpeed = await settings.showDistanceSpeedUnitPopupMenu(context);

                  if (newDistanceSpeed != null) {
                    await settings.updateDistanceSpeedUnit(newDistanceSpeed);
                  }
                },
                activeValue: localizeDistanceSpeed(settingsState.unit.distanceSpeed),
                subtitle: 'unitsDistanceSpeedSubtitle'.tr(),
              ),

              ///
              /// PRECIPITATION
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => settings.tapDownDetails = details,
                onTapUp: (_) async {
                  final newPrecipitation = await settings.showPrecipitationUnitPopupMenu(context);

                  if (newPrecipitation != null) {
                    await settings.updatePrecipitationUnit(newPrecipitation);
                  }
                },
                activeValue: localizePrecipitation(settingsState.unit.precipitation),
                subtitle: 'unitsPrecipitationSubtitle'.tr(),
              ),

              ///
              /// PRESSURE
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => settings.tapDownDetails = details,
                onTapUp: (_) async {
                  final newPressure = await settings.showPressureUnitPopupMenu(context);

                  if (newPressure != null) {
                    await settings.updatePressureUnit(newPressure);
                  }
                },
                activeValue: localizePressure(settingsState.unit.pressure),
                subtitle: 'unitsPressureSubtitle'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
