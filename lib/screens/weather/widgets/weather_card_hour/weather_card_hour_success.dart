import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/custom_color/custom_color.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';

class WeatherCardHourSuccess extends ConsumerWidget {
  final HourWeather hourWeather;
  final bool useOpacity;
  final bool isActive;
  final Color borderColor;
  final bool showCelsius;
  final Function() onPressed;

  const WeatherCardHourSuccess({
    required this.hourWeather,
    required this.useOpacity,
    required this.isActive,
    required this.borderColor,
    required this.showCelsius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherCode = hourWeather.condition.code;
    final isDay = hourWeather.isDay == 1;

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
      code: hourWeather.condition.code,
      isDay: hourWeather.isDay == 1,
    );

    final showRain = hourWeather.willItRain == 1;
    final showSnow = hourWeather.willItSnow == 1;

    return AnimatedOpacity(
      duration: PromajaDurations.opacityAnimation,
      curve: Curves.easeIn,
      opacity: useOpacity ? 0 : 1,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 4 - 16,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ///
            /// MAIN CONTENT
            ///
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? null
                    : Border.all(
                        color: showSnow
                            ? PromajaColors.white
                            : showRain
                                ? PromajaColors.blue
                                : borderColor,
                        width: showRain || showSnow ? 4 : 2,
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
                    style: PromajaTextStyles.weatherCardHourHour,
                    textAlign: TextAlign.center,
                  ),

                  ///
                  /// WEATHER ICON
                  ///
                  Animate(
                    key: UniqueKey(),
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
                      scale: 1.35,
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
                    showCelsius ? '${hourWeather.tempC.round()}°' : '${hourWeather.tempF.round()}°',
                    style: PromajaTextStyles.weatherCardHourTemperature,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            ///
            /// CHANCE OF RAIN
            ///
            if (showRain || showSnow)
              Positioned(
                top: -24,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Rain
                    if (showRain && !showSnow) ...[
                      Image.asset(
                        PromajaIcons.umbrella,
                        color: PromajaColors.white,
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '${hourWeather.chanceOfRain}%',
                        style: PromajaTextStyles.weatherCardHourChanceOfRain,
                        textAlign: TextAlign.center,
                      ),
                    ],

                    /// Snow
                    if (showSnow) ...[
                      Image.asset(
                        PromajaIcons.snow,
                        color: PromajaColors.white,
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '${hourWeather.chanceOfSnow}%',
                        style: PromajaTextStyles.weatherCardHourChanceOfRain,
                        textAlign: TextAlign.center,
                      ),
                    ],
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
