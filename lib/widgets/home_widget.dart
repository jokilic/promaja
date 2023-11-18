import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/text_styles.dart';
import '../util/color.dart';

class PromajaHomeWidget extends StatelessWidget {
  final String locationName;
  final int temp;
  final Color backgroundColor;
  final String weatherDescription;
  final AssetImage weatherIconWidget;
  final AssetImage promajaIconWidget;
  final String timestamp;

  const PromajaHomeWidget({
    required this.locationName,
    required this.temp,
    required this.backgroundColor,
    required this.weatherDescription,
    required this.weatherIconWidget,
    required this.promajaIconWidget,
    required this.timestamp,
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
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          '$temp',
                          style: PromajaTextStyles.homeWidgetTemperature,
                          textAlign: TextAlign.center,
                        ),
                        const Positioned(
                          top: 0,
                          right: -14,
                          child: Text(
                            '°',
                            style: PromajaTextStyles.homeWidgetTemperature,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
