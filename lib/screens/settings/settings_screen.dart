import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
import '../../widgets/promaja_navigation_bar.dart';
import '../card_colors/card_colors_screen.dart';
import '../notification/notification_screen.dart';
import 'widgets/settings_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: PromajaNavigationBar(),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 24),

              ///
              /// SETTINGS TITLE
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Settings',
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// SETTINGS DESCRIPTION
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Here you can change settings related to Promaja.',
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
                title: 'Card colors',
                subtitle: 'Change background color for any weather type',
              ),

              ///
              /// TEMPERATURE SCALE
              ///
              SettingsListTile(
                onTap: () {},
                title: 'Temperature',
                subtitle: 'Celsius or Fahrenheit?',
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
                title: 'Notification',
                subtitle: 'Get a daily weather notification',
              ),

              ///
              /// WIDGET
              ///
              SettingsListTile(
                onTap: () {},
                title: 'Widget',
                subtitle: 'Choose location to be shown in home widget',
              ),

              ///
              /// CONTACT
              ///
              SettingsListTile(
                onTap: () {},
                title: 'Contact',
                subtitle: 'Having some ideas regarding Promaja?',
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
                      const TextSpan(
                        text: "Promaja wouldn't be possible without ",
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
      );
}
