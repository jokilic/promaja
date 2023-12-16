import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../services/notification_service.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/widgets/settings_list_tile.dart';

class NotificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Notifications',
                    style: PromajaTextStyles.settingsTitle,
                  ),
                ),
                const SizedBox(height: 16),

                ///
                /// NOTIFICATIONS DESCRIPTION
                ///
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Change settings related to weather notifications which you can receive if you're so inclined.",
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
                /// SCHEDULE NOTIFICATION
                ///
                SettingsListTile(
                  onTap: () {},
                  title: 'Schedule notification',
                  subtitle: 'Show a weather notification each morning',
                ),

                ///
                /// TEST NOTIFICATION
                ///
                SettingsListTile(
                  onTap: ref.read(notificationProvider).testNotification,
                  title: 'Test notification',
                  subtitle: 'Show a test notification on your device',
                ),
              ],
            ),
          ),
        ),
      );
}
