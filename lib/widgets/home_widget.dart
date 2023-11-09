import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';
import '../constants/text_styles.dart';
import '../util/color.dart';

class PromajaHomeWidget extends StatelessWidget {
  final String locationName;
  final int minTemp;
  final int maxTemp;
  final Color backgroundColor;
  final String weatherDescription;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final Image weatherIconWidget;
  final Image promajaIconWidget;

  const PromajaHomeWidget({
    required this.locationName,
    required this.minTemp,
    required this.maxTemp,
    required this.backgroundColor,
    required this.weatherDescription,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.weatherIconWidget,
    required this.promajaIconWidget,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 200,
        width: 200,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lightenColor(backgroundColor),
              darkenColor(backgroundColor),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ///
            /// MAIN CONTENT
            ///
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Location
                Text(
                  locationName,
                  style: PromajaTextStyles.homeWidgetLocation,
                  textAlign: TextAlign.center,
                ),

                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    /// Icon
                    Transform.scale(
                      scale: 1.2,
                      child: weatherIconWidget,
                    ),

                    ///
                    /// CHANCE OF RAIN
                    ///
                    if (dailyWillItRain == 1)
                      Positioned(
                        top: 0,
                        right: -40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              PromajaIcons.umbrella,
                              color: PromajaColors.white,
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              '$dailyChanceOfRain%',
                              style: PromajaTextStyles.homeWidgetChanceOfRain,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                /// Temperatures
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///
                          /// MIN TEMP
                          ///
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  '$minTemp',
                                  style: PromajaTextStyles.homeWidgetTemperatureMin,
                                  textAlign: TextAlign.center,
                                ),
                                Positioned(
                                  top: 0,
                                  right: -14,
                                  child: Text(
                                    '°',
                                    style: PromajaTextStyles.homeWidgetTemperatureMin,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          ///
                          /// MAX TEMP
                          ///
                          Align(
                            alignment: Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  '$maxTemp',
                                  style: PromajaTextStyles.homeWidgetTemperatureMax,
                                  textAlign: TextAlign.center,
                                ),
                                const Positioned(
                                  top: 0,
                                  right: -14,
                                  child: Text(
                                    '°',
                                    style: PromajaTextStyles.homeWidgetTemperatureMax,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    ///
                    /// WEATHER DESCRIPTION
                    ///
                    Text(
                      weatherDescription,
                      style: PromajaTextStyles.homeWidgetDescription,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),

            ///
            /// PROMAJA
            ///
            Positioned(
              left: -36,
              child: Transform.rotate(
                angle: pi * 1.5,
                child: Row(
                  children: [
                    promajaIconWidget,
                    const SizedBox(width: 6),
                    Text(
                      'appNameString'.tr(),
                      style: PromajaTextStyles.homeWidgetPromaja,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
