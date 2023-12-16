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
import '../../widgets/promaja_navigation_bar.dart';
import '../card_colors/card_colors_screen.dart';
import '../notification/notification_screen.dart';
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
                  const SizedBox(height: 24),

                  ///
                  /// SETTINGS TITLE
                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CardColorsScreen(),
                      ),
                    ),
                    title: 'cardColorsTitle'.tr(),
                    subtitle: 'cardColorsSubtitle'.tr(),
                  ),

                  ///
                  /// TEMPERATURE SCALE
                  ///
                  SettingsListTile(
                    onTap: () {},
                    title: 'temperatureTitle'.tr(),
                    subtitle: 'temperatureSubtitle'.tr(),
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
                    title: 'notificationTitle'.tr(),
                    subtitle: 'notificationSubtitle'.tr(),
                  ),

                  ///
                  /// WIDGET
                  ///
                  SettingsListTile(
                    onTap: () {},
                    title: 'widgetTitle'.tr(),
                    subtitle: 'widgetSubtitle'.tr(),
                  ),

                  ///
                  /// CONTACT
                  ///
                  SettingsListTile(
                    onTap: () {},
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              ..onTap = () => launchUrl(
                                    Uri.parse('https://www.weatherapi.com'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('https://www.weatherapi.com'),
                    ),
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
