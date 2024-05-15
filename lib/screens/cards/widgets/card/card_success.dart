import 'package:easy_localization/easy_localization.dart';
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
import '../../../../widgets/additional/additional_cvh.dart';
import '../../../../widgets/additional/additional_pug.dart';
import '../../../../widgets/additional/additional_wpf.dart';
import '../../../../widgets/keep_alive_widget.dart';
import '../../cards_notifiers.dart';

class CardSuccess extends ConsumerWidget {
  final Location location;
  final CurrentWeather currentWeather;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const CardSuccess({
    required this.location,
    required this.currentWeather,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
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

    final weatherDescription = getWeatherDescription(
      code: currentWeather.condition.code,
      isDay: currentWeather.isDay == 1,
    );

    return Container(
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
                const SizedBox(height: 14),
                Text(
                  'currentWeather'.tr(),
                  style: PromajaTextStyles.currentLastUpdated,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      location.name,
                      style: PromajaTextStyles.currentLocation,
                      textAlign: TextAlign.center,
                    ),
                    if (isPhoneLocation)
                      Positioned(
                        left: -32,
                        top: 4,
                        child: Image.asset(
                          PromajaIcons.location,
                          height: 24,
                          width: 24,
                          color: PromajaColors.white,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            ///
            /// WEATHER ICON
            ///
            Animate(
              onPlay: (controller) => controller.loop(reverse: true),
              delay: PromajaDurations.weatherIconScaleDelay,
              effects: [
                ScaleEffect(
                  curve: Curves.easeIn,
                  end: const Offset(1.5, 1.5),
                  duration: PromajaDurations.weatherIconScalAnimation,
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
                      showCelsius ? '${currentWeather.tempC.round()}' : '${currentWeather.tempF.round()}',
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
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 144,
              child: PageView(
                controller: ref.watch(cardAdditionalControllerProvider),
                physics: const BouncingScrollPhysics(),
                children: [
                  ///
                  /// WIND, PRECIPITATION, FEELS LIKE
                  ///
                  KeepAlivePage(
                    child: AdditionalWPF(
                      windDegree: currentWeather.windDegree,
                      windText: showKph ? '${currentWeather.windKph.round()} km/h' : '${currentWeather.windMph.round()} mi',
                      precipitationText: showMm ? '${currentWeather.precipMm.round()} mm' : '${currentWeather.precipIn.round()} in',
                      feelsLikeTemperature: showCelsius ? currentWeather.feelsLikeC : currentWeather.feelsLikeF,
                    ),
                  ),

                  ///
                  /// CLOUD, VISIBILITY, HUMIDITY
                  ///
                  AdditionalCVH(
                    cloud: currentWeather.cloud,
                    visibilityText: showKph ? '${currentWeather.visKm.round()} km' : '${currentWeather.visMiles.round()} mi',
                    humidity: currentWeather.humidity,
                  ),

                  ///
                  /// PRESSURE, UV, GUST
                  ///
                  AdditionalPUG(
                    pressureText: showhPa ? '${currentWeather.pressurehPa.round()} hPa' : '${currentWeather.pressureIn} inHg',
                    uv: currentWeather.uv,
                    gustText: showKph ? '${currentWeather.gustKph.round()} km/h' : '${currentWeather.gustMph.round()} mph',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
