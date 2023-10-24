import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../notifiers/weather_notifier.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';
import '../../../../widgets/additional/additional_tu.dart';
import '../../../../widgets/additional/additional_whp.dart';

// TODO: Finish this
class WeatherCardSuccess extends ConsumerWidget {
  final Location location;
  final ForecastDayWeather forecast;
  final bool useOpacity;

  const WeatherCardSuccess({
    required this.location,
    required this.forecast,
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = getWeatherColor(
      code: forecast.day.condition.code,
      isDay: true,
    );

    final weatherIcon = getWeatherIcon(
      code: forecast.day.condition.code,
      isDay: true,
    );

    final weatherDescription = getWeatherDescription(
      code: forecast.day.condition.code,
      isDay: true,
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
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
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            opacity: useOpacity ? 0 : 1,
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
                      getForecastDate(dateEpoch: forecast.dateEpoch),
                      style: PromajaTextStyles.weatherCardLastUpdated,
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
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                      weatherIcon,
                      height: 176,
                      width: 176,
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
                          '${forecast.day.avgTempC.round()}',
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

                ///
                /// ADDITIONAL INFO
                ///
                SizedBox(
                  height: 144,
                  child: PageView(
                    controller: ref.watch(weatherCardAdditionalControllerProvider),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ///
                      /// WIND, HUMIDITY, PRECIPITATION
                      ///
                      AdditionalWHP(
                        windKph: forecast.day.maxWindKph,
                        humidity: forecast.day.avgHumidity.round(),
                        precipitation: forecast.day.totalPrecipMm,
                      ),

                      ///
                      /// MIN/MAX TEMPERATURE, UV
                      ///
                      AdditionalTU(
                        minTemp: forecast.day.minTempC,
                        maxTemp: forecast.day.maxTempC,
                        uv: forecast.day.uv,
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
