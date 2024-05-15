import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../models/custom_color/custom_color.dart';
import '../../../../models/location/location.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';

class ListCardSuccess extends ConsumerWidget {
  final Location location;
  final bool isPhoneLocation;
  final CurrentWeather currentWeather;
  final Function() onTap;
  final bool showCelsius;

  const ListCardSuccess({
    required this.location,
    required this.isPhoneLocation,
    required this.currentWeather,
    required this.onTap,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherCode = currentWeather.condition.code;
    final isDay = currentWeather.isDay == 1;

    final backgroundColor = ref
        .watch(hiveProvider.notifier)
        .getCustomColorsFromBox()
        .firstWhere(
          (customColor) => customColor.code == weatherCode && customColor.isDay == isDay,
          orElse: () => CustomColor(
            code: weatherCode,
            isDay: isDay,
            color: getWeatherColor(
              code: weatherCode,
              isDay: isDay,
            ),
          ),
        )
        .color;

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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              location.name,
                              style: PromajaTextStyles.listLocation,
                            ),
                          ),
                          if (isPhoneLocation) ...[
                            const SizedBox(width: 8),
                            Image.asset(
                              PromajaIcons.location,
                              height: 24,
                              width: 24,
                              color: PromajaColors.white,
                            ),
                          ],
                        ],
                      ),

                      /// Temperature
                      Text(
                        showCelsius ? '${currentWeather.tempC.round()}°' : '${currentWeather.tempF.round()}°',
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
                    key: ValueKey(location),
                    onPlay: (controller) => controller.loop(reverse: true),
                    delay: PromajaDurations.weatherIconScaleDelay,
                    effects: [
                      ScaleEffect(
                        curve: Curves.easeIn,
                        end: const Offset(1.5, 1.5),
                        duration: PromajaDurations.weatherIconScalAnimation,
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
