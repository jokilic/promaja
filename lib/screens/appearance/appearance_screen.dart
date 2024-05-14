import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../models/settings/appearance/initial_section.dart';
import '../../widgets/promaja_back_button.dart';
import '../card_colors/card_colors_screen.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_checkbox_list_tile.dart';
import '../settings/widgets/settings_list_tile.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

class AppearanceScreen extends ConsumerWidget {
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
              /// APPEARANCE TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'appearanceTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// APPEARANCE DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'appearanceDescription'.tr(),
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
              /// CARD COLORS
              ///
              SettingsListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CardColorsScreen(),
                    ),
                  );
                },
                icon: PromajaIcons.arrow,
                title: 'cardColorsTitle'.tr(),
                subtitle: 'cardColorsSubtitle'.tr(),
              ),

              ///
              /// INITIAL SECTION
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newSection = await ref.read(settingsProvider.notifier).showInitialSectionPopupMenu(context);

                  if (newSection != null) {
                    await ref.read(settingsProvider.notifier).updateInitialSection(newSection);
                  }
                },
                activeValue: localizeInitialSection(settings.appearance.initialSection),
                subtitle: 'appearanceInitialSectionSubtitle'.tr(),
              ),

              ///
              /// WEATHER SUMMARY FIRST
              ///
              SettingsCheckboxListTile(
                value: settings.appearance.weatherSummaryFirst,
                onTap: ref.read(settingsProvider.notifier).toggleWeatherSummaryFirst,
                title: 'appearanceWeatherSummaryFirstTitle'.tr(),
                subtitle: 'appearanceWeatherSummaryFirstSubtitle'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
