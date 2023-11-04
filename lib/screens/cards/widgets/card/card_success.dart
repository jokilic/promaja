import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/current_weather/current_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';
import '../../../../widgets/additional/additional_fug.dart';
import '../../../../widgets/additional/additional_pcv.dart';
import '../../../../widgets/additional/additional_whp.dart';
import '../../../../widgets/keep_alive_widget.dart';
import '../../cards_notifiers.dart';

class CardSuccess extends ConsumerWidget {
  final Location location;
  final CurrentWeather currentWeather;
  final bool useOpacity;

  const CardSuccess({
    required this.location,
    required this.currentWeather,
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = getWeatherColor(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    final weatherIcon = getWeatherIcon(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    final weatherDescription = getWeatherDescription(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    return AnimatedOpacity(
      duration: PromajaDurations.opacityAnimation,
      curve: Curves.easeIn,
      opacity: useOpacity ? 0.45 : 1,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
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
        child: AnimatedOpacity(
          duration: PromajaDurations.opacityAnimation,
          curve: Curves.easeIn,
          opacity: useOpacity ? 0 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AnimateList(
              delay: PromajaDurations.weatherDataAnimationDelay,
              interval: PromajaDurations.weatherDataAnimationDelay,
              effects: [
                FadeEffect(
                  curve: Curves.easeIn,
                  duration: PromajaDurations.fadeAnimation,
                ),
              ],
              children: [
                const SizedBox.shrink(),

                ///
                /// LAST UPDATED & LOCATION
                ///
                Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Current weather',
                      style: PromajaTextStyles.currentLastUpdated,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location.name,
                      style: PromajaTextStyles.currentLocation,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                      end: const Offset(1.5, 1.5),
                      duration: 60.seconds,
                    ),
                  ],
                  child: Animate(
                    delay: PromajaDurations.cardWeatherIconAnimationDelay,
                    effects: [
                      FlipEffect(
                        curve: Curves.easeIn,
                        duration: PromajaDurations.fadeAnimation,
                      ),
                    ],
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        weatherIcon,
                        height: 176,
                        width: 176,
                      ),
                    ),
                  ),
                ),

                ///
                /// TEMPERATURE & WEATHER
                ///
                Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          '${currentWeather.tempC.round()}',
                          style: PromajaTextStyles.currentTemperature,
                          textAlign: TextAlign.center,
                        ),
                        const Positioned(
                          right: -24,
                          top: 2,
                          child: Text(
                            '°',
                            style: PromajaTextStyles.currentTemperatureDegrees,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        weatherDescription,
                        style: PromajaTextStyles.currentWeather,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                ///
                /// ADDITIONAL INFO
                ///
                SizedBox(
                  height: 144,
                  child: PageView(
                    controller: ref.watch(cardAdditionalControllerProvider),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ///
                      /// WIND, HUMIDITY, PRECIPITATION
                      ///
                      KeepAlivePage(
                        child: AdditionalWHP(
                          windDegree: currentWeather.windDegree,
                          windKph: currentWeather.windKph,
                          humidity: currentWeather.humidity,
                          precipitation: currentWeather.precipMm,
                        ),
                      ),

                      ///
                      /// PRESSURE, CLOUD, VISIBILITY
                      ///
                      AdditionalPCV(
                        pressure: currentWeather.pressurehPa,
                        cloud: currentWeather.cloud,
                        visibility: currentWeather.visKm,
                      ),

                      ///
                      /// FEELS LIKE, UV, GUST
                      ///
                      AdditionalFUG(
                        feelsLikeTemperature: currentWeather.feelsLikeC,
                        uv: currentWeather.uv,
                        gust: currentWeather.gustKph,
                      ),
                    ],
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
