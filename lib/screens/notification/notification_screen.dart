import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../services/notification_service.dart';
import '../../util/dependencies.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/settings_controller.dart';
import '../settings/widgets/settings_checkbox_list_tile.dart';
import '../settings/widgets/settings_list_tile.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';

class NotificationScreen extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final notification = getIt.get<NotificationService>();

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
              /// NOTIFICATIONS TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
              SettingsPopupMenuListTile(
                onTapDown: (details) => settings.tapDownDetails = details,
                onTapUp: (_) async {
                  final newLocation = await settings.showNotificationLocationPopupMenu(context);

                  if (newLocation != null) {
                    await settings.updateNotificationLocation(newLocation);
                  }
                },
                activeValue: settingsState.notification.location != null
                    ? '${settingsState.notification.location?.name}, ${settingsState.notification.location?.country}'
                    : 'notificationNoLocationChosen'.tr(),
                subtitle: 'notificationLocationDescription'.tr(),
              ),

              ///
              /// HOURLY NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settingsState.notification.hourlyNotification,
                onTap: settings.toggleHourlyNotification,
                title: 'hourlyNotificationTitle'.tr(),
                subtitle: 'hourlyNotificationSubtitle'.tr(),
              ),

              ///
              /// MORNING NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settingsState.notification.morningNotification,
                onTap: settings.toggleMorningNotification,
                title: 'morningNotificationTitle'.tr(),
                subtitle: 'morningNotificationSubtitle'.tr(),
              ),

              ///
              /// EVENING NOTIFICATION
              ///
              SettingsCheckboxListTile(
                value: settingsState.notification.eveningNotification,
                onTap: settings.toggleEveningNotification,
                title: 'eveningNotificationTitle'.tr(),
                subtitle: 'eveningNotificationSubtitle'.tr(),
              ),

              ///
              /// TEST NOTIFICATION
              ///
              SettingsListTile(
                onTap: notification.testNotification,
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
