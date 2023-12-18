import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../services/notification_service.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_notifier.dart';
import '../settings/widgets/settings_list_tile.dart';

class NotificationScreen extends ConsumerWidget {
  void showNotImplementedSnackBar(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Not implemented yet...',
            style: PromajaTextStyles.snackbar,
          ),
          backgroundColor: PromajaColors.indigo,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

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
              /// NOTIFICATIONS TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'notificationTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// NOTIFICATIONS DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'notificationDescription'.tr(),
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
              SettingsListTile(
                onTap: () => showNotImplementedSnackBar(context),
                // TODO
                title: 'Location',
                subtitle: 'Location which will be shown in notifications',
              ),

              ///
              /// HOURLY NOTIFICATION
              ///
              SettingsListTile(
                onTap: () => showNotImplementedSnackBar(context),
                // TODO
                title: 'Hourly notification',
                subtitle: 'Show a weather notification each hour',
              ),

              ///
              /// MORNING NOTIFICATION
              ///
              SettingsListTile(
                onTap: () => showNotImplementedSnackBar(context),
                title: 'morningNotificationTitle'.tr(),
                subtitle: 'morningNotificationSubtitle'.tr(),
              ),

              ///
              /// EVENING NOTIFICATION
              ///
              SettingsListTile(
                onTap: () => showNotImplementedSnackBar(context),
                // TODO
                title: 'Evening notification',
                subtitle: 'Each night, show a notification with forecast for tomorrow',
              ),

              ///
              /// TEST NOTIFICATION
              ///
              SettingsListTile(
                onTap: ref.read(notificationProvider).testNotification,
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
