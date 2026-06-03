import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../services/hive_service.dart';
import '../../services/notification_service.dart';
import '../../util/app_version.dart';
import '../../util/dependencies.dart';
import '../../util/url_launch.dart';
import '../../widgets/promaja_navigation_bar.dart';
import '../appearance/appearance_screen.dart';
import '../notification/notification_screen.dart';
import '../unit/unit_screen.dart';
import '../widget/widget_screen.dart';
import 'settings_controller.dart';
import 'widgets/settings_list_tile.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<SettingsController>(
      () => SettingsController(
        hive: getIt.get<HiveService>(),
        notification: getIt.get<NotificationService>(),
      ),
    );

    /// Remove splash screen
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<SettingsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: PromajaNavigationBar(),
    body: Animate(
      effects: [
        FadeEffect(
          curve: Curves.easeIn,
          duration: PromajaDurations.fadeAnimation,
        ),
      ],
      child: SafeArea(
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
              const SizedBox(height: 24),

              ///
              /// SETTINGS TITLE
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'settingsTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// SETTINGS DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'settingsSubtitle'.tr(),
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
              /// APPEARANCE
              ///
              SettingsListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppearanceScreen(),
                  ),
                ),
                icon: PromajaIcons.arrow,
                title: 'appearanceTitle'.tr(),
                subtitle: 'appearanceSubtitle'.tr(),
              ),

              ///
              /// UNITS
              ///
              SettingsListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UnitScreen(),
                    ),
                  );
                },
                icon: PromajaIcons.arrow,
                title: 'unitsTitle'.tr(),
                subtitle: 'unitsSubtitle'.tr(),
              ),

              ///
              /// NOTIFICATION
              ///
              SettingsListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                ),
                icon: PromajaIcons.arrow,
                title: 'notificationTitle'.tr(),
                subtitle: 'notificationSubtitle'.tr(),
              ),

              ///
              /// WIDGET
              ///
              SettingsListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WidgetScreen(),
                  ),
                ),
                icon: PromajaIcons.arrow,
                title: 'widgetTitle'.tr(),
                subtitle: 'widgetSubtitle'.tr(),
              ),

              ///
              /// CONTACT
              ///
              SettingsListTile(
                onTap: () => openUrlExternalBrowser(
                  context,
                  url: 'mailto:neksuses@gmail.com?subject=${'Regarding Promaja...'}',
                ),
                icon: PromajaIcons.arrow,
                title: 'contactTitle'.tr(),
                subtitle: 'contactSubtitle'.tr(),
              ),

              ///
              /// DIVIDER
              ///
              const SizedBox(height: 16),
              const Divider(
                indent: 120,
                endIndent: 120,
                color: PromajaColors.white,
              ),
              const SizedBox(height: 24),

              ///
              /// PROMAJA INFO
              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: PromajaColors.white,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          PromajaIcons.icon,
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Promaja',
                        style: PromajaTextStyles.settingsPromajaTitle,
                      ),
                      FutureBuilder(
                        future: getAppVersion(),
                        builder: (_, snapshot) {
                          final version = snapshot.data;

                          if (version != null) {
                            return Text(
                              'v$version',
                              style: PromajaTextStyles.settingsPromajaVersion,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}
