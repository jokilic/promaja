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
import '../unit/unit_screen.dart';
import '../widget/widget_screen.dart';
import 'widgets/settings_list_tile.dart';

// TODO: Localize file
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
                    icon: PromajaIcons.arrow,
                    title: 'cardColorsTitle'.tr(),
                    subtitle: 'cardColorsSubtitle'.tr(),
                  ),

                  ///
                  /// UNITS
                  ///
                  SettingsListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UnitScreen(),
                      ),
                    ),
                    icon: PromajaIcons.arrow,
                    title: 'Units',
                    subtitle: 'Update units you want to be shown for each weather',
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
                    onTap: () => launchUrl(
                      Uri(
                        scheme: 'mailto',
                        path: 'neksuses@gmail.com',
                        queryParameters: {'subject': 'Regarding Promaja...'},
                      ),
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
                                    Uri(scheme: 'https', host: 'www.weatherapi.com'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri(scheme: 'https', host: 'www.weatherapi.com'),
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
