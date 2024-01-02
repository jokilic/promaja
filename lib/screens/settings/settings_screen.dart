import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../services/hive_service.dart';
import '../../widgets/promaja_navigation_bar.dart';
import '../card_colors/card_colors_screen.dart';
import '../logging/logging_screen.dart';
import '../notification/notification_screen.dart';
import '../unit/unit_screen.dart';
import '../widget/widget_screen.dart';
import 'widgets/settings_list_tile.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        bottomNavigationBar: PromajaNavigationBar(),
        body: Animate(
          key: ValueKey(ref.read(navigationBarIndexProvider)),
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
                  /// CARD COLORS
                  ///
                  SettingsListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CardColorsScreen(),
                        ),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Card colors',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
                    icon: PromajaIcons.arrow,
                    title: 'cardColorsTitle'.tr(),
                    subtitle: 'cardColorsSubtitle'.tr(),
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

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Units',
                            logGroup: PromajaLogGroup.settings,
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Notifications',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
                    icon: PromajaIcons.arrow,
                    title: 'notificationTitle'.tr(),
                    subtitle: 'notificationSubtitle'.tr(),
                  ),

                  ///
                  /// WIDGET
                  ///
                  SettingsListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WidgetScreen(),
                        ),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Widget',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
                    icon: PromajaIcons.arrow,
                    title: 'widgetTitle'.tr(),
                    subtitle: 'widgetSubtitle'.tr(),
                  ),

                  ///
                  /// LOGGING
                  ///
                  SettingsListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoggingScreen(),
                        ),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Logging',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
                    icon: PromajaIcons.arrow,
                    title: 'loggingTitle'.tr(),
                    subtitle: 'loggingSubtitle'.tr(),
                  ),

                  ///
                  /// CONTACT
                  ///
                  SettingsListTile(
                    onTap: () {
                      launchUrl(
                        Uri(
                          scheme: 'mailto',
                          path: 'neksuses@gmail.com',
                          queryParameters: {
                            'subject': Uri.encodeComponent('Regarding Promaja...'),
                          },
                        ),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> Contact',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
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
                  /// WEATHER API
                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'weatherAPIInfo'.tr(),
                            style: PromajaTextStyles.settingsText,
                          ),
                          TextSpan(
                            text: 'WeatherAPI.com',
                            style: PromajaTextStyles.settingsText.copyWith(
                              fontWeight: FontWeight.w700,
                              color: PromajaColors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(
                                  Uri(scheme: 'https', host: 'www.weatherapi.com'),
                                );

                                ref.read(hiveProvider.notifier).logPromajaEvent(
                                      text: 'Open -> WeatherAPI link',
                                      logGroup: PromajaLogGroup.settings,
                                    );
                              },
                          ),
                          const TextSpan(
                            text: '.',
                            style: PromajaTextStyles.settingsText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri(scheme: 'https', host: 'www.weatherapi.com'),
                      );

                      ref.read(hiveProvider.notifier).logPromajaEvent(
                            text: 'Open -> WeatherAPI logo',
                            logGroup: PromajaLogGroup.settings,
                          );
                    },
                    child: Image.asset(
                      PromajaIcons.weatherAPI,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
}
