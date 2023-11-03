import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../notifiers/weather_notifier.dart';
import '../../../../util/weather.dart';
import '../../../../widgets/additional/additional_fug.dart';
import '../../../../widgets/additional/additional_pcv.dart';
import '../../../../widgets/additional/additional_whp.dart';

class WeatherCardIndividualHour extends ConsumerWidget {
  final HourWeather? hourWeather;
  final bool useOpacity;

  const WeatherCardIndividualHour({
    required this.hourWeather,
    required this.useOpacity,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherIcon = getWeatherIcon(
      code: hourWeather?.condition.code ?? 0,
      isDay: hourWeather?.isDay == 1,
    );

    final weatherDescription = getWeatherDescription(
      code: hourWeather?.condition.code ?? 0,
      isDay: hourWeather?.isDay == 1,
    );

    return AnimatedOpacity(
      duration: PromajaDurations.opacityAnimation,
      curve: Curves.easeIn,
      opacity: useOpacity ? 0 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        height: hourWeather != null ? null : 0,
        child: Column(
          children: [
            const SizedBox.shrink(),

            ///
            /// DATE & LOCATION
            ///
            Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  hourWeather != null ? DateFormat.Hm().format(hourWeather!.timeEpoch) : '',
                  style: PromajaTextStyles.currentLocation,
                  textAlign: TextAlign.center,
                ),
                Text(
                  hourWeather != null ? getForecastDate(dateEpoch: hourWeather!.timeEpoch) : '',
                  style: PromajaTextStyles.currentLastUpdated,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
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
                  end: const Offset(1.25, 1.25),
                  duration: 60.seconds,
                ),
              ],
              child: Transform.scale(
                scale: 1.35,
                child: Image.asset(
                  weatherIcon,
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            const SizedBox(height: 8),

            ///
            /// TEMPERATURE & WEATHER
            ///
            Column(
              children: [
                const SizedBox(height: 32),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      '${hourWeather?.tempC.round()}',
                      style: PromajaTextStyles.currentHourTemperature,
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
                const SizedBox(height: 2),
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
            const SizedBox(height: 32),

            ///
            /// ADDITIONAL INFO
            ///
            SizedBox(
              height: 144,
              child: PageView(
                controller: ref.watch(weatherCardHourAdditionalControllerProvider),
                physics: const BouncingScrollPhysics(),
                children: hourWeather != null
                    ? [
                        ///
                        /// WIND, HUMIDITY, PRECIPITATION
                        ///
                        AdditionalWHP(
                          windDegree: hourWeather!.windDegree,
                          windKph: hourWeather!.windKph,
                          humidity: hourWeather!.humidity,
                          precipitation: hourWeather!.precipMm,
                        ),

                        ///
                        /// PRESSURE, CLOUD, VISIBILITY
                        ///
                        AdditionalPCV(
                          pressure: hourWeather!.pressurehPa,
                          cloud: hourWeather!.cloud,
                          visibility: hourWeather!.visKm,
                        ),

                        ///
                        /// FEELS LIKE, UV, GUST
                        ///
                        AdditionalFUG(
                          feelsLikeTemperature: hourWeather!.feelsLikeC,
                          uv: hourWeather!.uv,
                          gust: hourWeather!.gustKph,
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
