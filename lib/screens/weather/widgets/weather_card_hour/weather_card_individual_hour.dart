import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../models/promaja_log/promaja_log_level.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/weather.dart';
import '../../../../widgets/additional/additional_cvh.dart';
import '../../../../widgets/additional/additional_pug.dart';
import '../../../../widgets/additional/additional_wpf.dart';
import '../../weather_notifiers.dart';

class WeatherCardIndividualHour extends ConsumerWidget {
  final HourWeather? hourWeather;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherCardIndividualHour({
    required this.hourWeather,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
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

    final showRain = hourWeather?.willItRain == 1;
    final showSnow = hourWeather?.willItSnow == 1;

    return Container(
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
                hourWeather != null ? getTodayDateMonth(dateEpoch: hourWeather!.timeEpoch) : '',
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
            key: ValueKey(key),
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
          /// TEMPERATURE, WEATHER DESCRIPTION & CHANCE OF RAIN
          ///
          Column(
            children: [
              const SizedBox(height: 32),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Text(
                    showCelsius ? '${hourWeather?.tempC.round()}' : '${hourWeather?.tempF.round()}',
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
                child: Text.rich(
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
                          child: SizedBox(width: 8),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                PromajaIcons.umbrella,
                                color: PromajaColors.white,
                                height: 24,
                                width: 24,
                              ),
                              Text(
                                '${hourWeather?.chanceOfRain}%',
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
                          child: SizedBox(width: 8),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                PromajaIcons.snow,
                                color: PromajaColors.white,
                                height: 24,
                                width: 24,
                              ),
                              Text(
                                '${hourWeather?.chanceOfSnow}%',
                                style: PromajaTextStyles.weatherCardIndividualHourChanceOfRain,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
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
              onPageChanged: (index) => ref.read(hiveProvider.notifier).logPromajaEvent(
                    text: 'Hour -> Additional info swipe',
                    logGroup: PromajaLogGroup.forecastWeather,
                  ),
              physics: const BouncingScrollPhysics(),
              children: hourWeather != null
                  ? [
                      ///
                      /// WIND, PRECIPITATION, FEELS LIKE
                      ///
                      AdditionalWPF(
                        windDegree: hourWeather!.windDegree,
                        windText: showKph ? '${hourWeather!.windKph.round()} km/h' : '${hourWeather!.windMph.round()} mi',
                        precipitationText: showMm ? '${hourWeather!.precipMm.round()} mm' : '${hourWeather!.precipIn.round()} in',
                        feelsLikeTemperature: showCelsius ? hourWeather!.feelsLikeC : hourWeather!.feelsLikeF,
                        useAnimations: false,
                      ),

                      ///
                      /// CLOUD, VISIBILITY, HUMIDITY
                      ///
                      AdditionalCVH(
                        cloud: hourWeather!.cloud,
                        visibilityText: showKph ? '${hourWeather!.visKm.round()} km' : '${hourWeather!.visMiles.round()} mi',
                        humidity: hourWeather!.humidity,
                      ),

                      ///
                      /// PRESSURE, UV, GUST
                      ///
                      AdditionalPUG(
                        pressureText: showhPa ? '${hourWeather!.pressurehPa.round()} hPa' : '${hourWeather!.pressureIn} inHg',
                        uv: hourWeather!.uv,
                        gustText: showKph ? '${hourWeather!.gustKph.round()} km/h' : '${hourWeather!.gustMph.round()} mph',
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
