import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';

class WeatherCardHourSuccess extends StatelessWidget {
  final HourWeather hourWeather;
  final bool useOpacity;
  final bool isActive;
  final Function() onPressed;

  const WeatherCardHourSuccess({
    required this.hourWeather,
    required this.useOpacity,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = getWeatherColor(
      code: hourWeather.condition.code,
      isDay: hourWeather.isDay == 1,
    );

    final weatherIcon = getWeatherIcon(
      code: hourWeather.condition.code,
      isDay: hourWeather.isDay == 1,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      opacity: useOpacity ? 0 : 1,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 4 - 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          children: [
            ///
            /// MAIN CONTENT
            ///
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: isActive
                    ? null
                    : Border.all(
                        color: backgroundColor,
                        width: 2,
                      ),
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          lightenColor(backgroundColor),
                          darkenColor(backgroundColor),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///
                  /// TIME
                  ///
                  Text(
                    DateFormat.Hm().format(hourWeather.timeEpoch),
                    style: PromajaTextStyles.weatherCardHourLastUpdated,
                    textAlign: TextAlign.center,
                  ),

                  ///
                  /// WEATHER ICON
                  ///
                  Animate(
                    onPlay: (controller) => controller.loop(reverse: true),
                    delay: 10.seconds,
                    effects: [
                      ScaleEffect(
                        curve: Curves.easeIn,
                        end: const Offset(1.15, 1.15),
                        duration: 60.seconds,
                      ),
                    ],
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        weatherIcon,
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ),

                  ///
                  /// TEMPERATURE
                  ///
                  Text(
                    '${hourWeather.tempC.round()}°',
                    style: PromajaTextStyles.weatherCardHourTemperature,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            ///
            /// INKWELL RIPPLE
            ///
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(32),
                  splashColor: Colors.transparent,
                  highlightColor: PromajaColors.white.withOpacity(0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
