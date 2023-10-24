import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';

class ListCardSuccess extends StatelessWidget {
  final String locationName;
  final CurrentWeather currentWeather;
  final Function() onTap;

  const ListCardSuccess({
    required this.locationName,
    required this.currentWeather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = getWeatherColor(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    final weatherIcon = getWeatherIcon(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            lightenColor(backgroundColor),
            darkenColor(backgroundColor),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          splashColor: Colors.transparent,
          highlightColor: PromajaColors.white.withOpacity(0.15),
          child: Container(
            height: 136,
            padding: const EdgeInsets.fromLTRB(32, 16, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///
                /// LOCATION & TEMPERATURE
                ///
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Location
                      Text(
                        locationName,
                        style: PromajaTextStyles.listLocation,
                      ),

                      /// Temperature
                      Text(
                        '${currentWeather.tempC.round()}°',
                        style: PromajaTextStyles.listTemperature,
                      ),
                    ],
                  ),
                ),

                ///
                /// WEATHER ICON
                ///
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Animate(
                    onPlay: (controller) => controller.loop(reverse: true),
                    delay: 10.seconds,
                    effects: [
                      ScaleEffect(
                        curve: Curves.easeIn,
                        end: const Offset(1.5, 1.5),
                        duration: 60.seconds,
                      ),
                    ],
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        weatherIcon,
                        height: 88,
                        width: 88,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
