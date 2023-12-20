import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../services/notification_service.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_checkbox_list_tile.dart';
import '../settings/widgets/settings_list_tile.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

// TODO: Localize file
class UnitsScreen extends ConsumerWidget {
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
                  'Update units that you will see when checking weather info',
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
                  final newLocation = await ref.read(settingsProvider.notifier).showNotificationLocationPopupMenu(context);

                  if (newLocation != null) {
                    await ref.read(settingsProvider.notifier).updateNotificationLocation(newLocation);
                  }
                },
                activeValue: '${settings.notification.location?.name}, ${settings.notification.location?.country}',
                subtitle: 'Location which will be shown in notifications',
              ),

              ///
              /// HOURLY NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settings.notification.hourlyNotification,
                onTap: () => ref.read(settingsProvider.notifier).toggleHourlyNotification(),
                title: 'Hourly notification',
                subtitle: 'Show a weather notification each hour',
              ),

              ///
              /// MORNING NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settings.notification.morningNotification,
                onTap: () => ref.read(settingsProvider.notifier).toggleMonthlyNotification(),
                title: 'morningNotificationTitle'.tr(),
                subtitle: 'morningNotificationSubtitle'.tr(),
              ),

              ///
              /// EVENING NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settings.notification.eveningNotification,
                onTap: () => ref.read(settingsProvider.notifier).toggleEveningNotification(),
                title: 'Evening notification',
                subtitle: 'Each night, show a notification with forecast for tomorrow',
              ),

              ///
              /// TEST NOTIFICATION
              ///
              SettingsListTile(
                onTap: ref.read(notificationProvider).testNotification,
                icon: PromajaIcons.dot,
                title: 'testNotificationTitle'.tr(),
                subtitle: 'testNotificationSubtitle'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
