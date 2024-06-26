import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../models/settings/widget/weather_type.dart';
import '../../services/home_widget_service.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_list_tile.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

class WidgetScreen extends ConsumerWidget {
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
              /// WIDGET TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'widgetTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// WIDGET DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'widgetDescription'.tr(),
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
              /// LOCATION
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newLocation = await ref.read(settingsProvider.notifier).showWidgetLocationPopupMenu(context);

                  if (newLocation != null) {
                    await ref.read(settingsProvider.notifier).updateWidgetLocation(newLocation);
                  }
                },
                activeValue: '${settings.widget.location?.name}, ${settings.widget.location?.country}',
                subtitle: 'widgetLocationDescription'.tr(),
              ),

              ///
              /// WEATHER TYPE
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(settingsProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newWeatherType = await ref.read(settingsProvider.notifier).showWidgetWeatherTypePopupMenu(context);

                  if (newWeatherType != null) {
                    await ref.read(settingsProvider.notifier).updateWidgetWeatherType(newWeatherType);
                  }
                },
                activeValue: localizeWeatherType(settings.widget.weatherType),
                subtitle: 'widgetWeatherTypeDescription'.tr(),
              ),

              ///
              /// UPDATE WIDGET
              ///
              SettingsListTile(
                onTap: () async {
                  await ref.read(homeWidgetProvider).handleWidget();

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'widgetUpdated'.tr(),
                        style: PromajaTextStyles.snackbar,
                      ),
                      backgroundColor: PromajaColors.black,
                      behavior: SnackBarBehavior.floating,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: PromajaColors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
                icon: PromajaIcons.dot,
                title: 'widgetUpdateTitle'.tr(),
                subtitle: 'widgetUpdateSubtitle'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
