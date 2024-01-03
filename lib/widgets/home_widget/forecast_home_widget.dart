import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../util/color.dart';

class ForecastHomeWidget extends StatelessWidget {
  final String locationName;
  final int minTemp;
  final int maxTemp;
  final Color backgroundColor;
  final String weatherDescription;
  final AssetImage weatherIconWidget;
  final AssetImage promajaIconWidget;
  final AssetImage umbrellaIconWidget;
  final AssetImage snowIconWidget;
  final String timestamp;
  final bool showRain;
  final bool showSnow;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;

  const ForecastHomeWidget({
    required this.locationName,
    required this.minTemp,
    required this.maxTemp,
    required this.backgroundColor,
    required this.weatherDescription,
    required this.weatherIconWidget,
    required this.promajaIconWidget,
    required this.umbrellaIconWidget,
    required this.snowIconWidget,
    required this.timestamp,
    required this.showRain,
    required this.showSnow,
    required this.dailyChanceOfRain,
    required this.dailyChanceOfSnow,
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

                /// Icon
                Transform.scale(
                  scale: 1.2,
                  child: Image(
                    image: weatherIconWidget,
                    height: 72,
                    width: 72,
                  ),
                ),

                /// Temperatures
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 46,
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
                                  '${minTemp.round()}',
                                  style: PromajaTextStyles.homeWidgetForecastTemperatureMin,
                                  textAlign: TextAlign.center,
                                ),
                                Positioned(
                                  top: 0,
                                  right: -12,
                                  child: Text(
                                    '°',
                                    style: PromajaTextStyles.homeWidgetForecastTemperatureMin,
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
                                  '${maxTemp.round()}',
                                  style: PromajaTextStyles.homeWidgetForecastTemperatureMax,
                                  textAlign: TextAlign.center,
                                ),
                                const Positioned(
                                  top: 0,
                                  right: -12,
                                  child: Text(
                                    '°',
                                    style: PromajaTextStyles.homeWidgetForecastTemperatureMax,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          ///
                          /// WEATHER DESCRIPTION
                          ///
                          TextSpan(
                            text: weatherDescription,
                          ),

                          ///
                          /// CHANCE OF RAIN
                          ///
                          if (showRain && !showSnow) ...[
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(width: 4),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: umbrellaIconWidget,
                                    color: PromajaColors.white,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Text(
                                    '$dailyChanceOfRain%',
                                    style: PromajaTextStyles.weatherCardIndividualHourChanceOfRain,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],

                          ///
                          /// CHANCE OF SNOW
                          ///
                          if (showSnow) ...[
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(width: 4),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: snowIconWidget,
                                    color: PromajaColors.white,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Text(
                                    '$dailyChanceOfSnow%',
                                    style: PromajaTextStyles.weatherCardIndividualHourChanceOfRain,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
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
                    Image(
                      image: promajaIconWidget,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'appNameString'.tr(),
                      style: PromajaTextStyles.homeWidgetPromaja,
                    ),
                  ],
                ),
              ),
            ),

            ///
            /// TIMESTAMP
            ///
            Positioned(
              right: -16,
              child: Transform.rotate(
                angle: pi * 0.5,
                child: Text(
                  timestamp,
                  style: PromajaTextStyles.homeWidgetPromaja,
                ),
              ),
            ),
          ],
        ),
      );
}
