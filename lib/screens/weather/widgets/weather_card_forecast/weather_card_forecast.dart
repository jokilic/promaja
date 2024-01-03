import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/custom_color/custom_color.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../models/promaja_log/promaja_log_level.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';
import '../../weather_notifiers.dart';
import '../weather_card_hour/weather_card_hour_success.dart';
import '../weather_card_hour/weather_card_individual_hour.dart';

class WeatherCardForecast extends ConsumerWidget {
  final Location location;
  final ForecastDayWeather forecast;
  final int index;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;
  final Function({
    required WidgetRef ref,
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
    required int index,
  }) weatherCardHourPressed;

  const WeatherCardForecast({
    required this.location,
    required this.forecast,
    required this.index,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
    required this.weatherCardHourPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeHourWeather = ref.watch(activeHourWeatherProvider);

    final weatherCode = forecast.day.condition.code;

    final backgroundColor = ref
        .watch(hiveProvider.notifier)
        .getCustomColorsFromBox()
        .firstWhere(
          (customColor) => customColor.code == weatherCode && customColor.isDay,
          orElse: () => CustomColor(
            code: weatherCode,
            isDay: true,
            color: getWeatherColor(
              code: weatherCode,
              isDay: true,
            ),
          ),
        )
        .color;

    final weatherIcon = getWeatherIcon(
      code: forecast.day.condition.code,
      isDay: true,
    );

    final weatherDescription = getWeatherDescription(
      code: forecast.day.condition.code,
      isDay: true,
    );

    final showRain = forecast.day.dailyWillItRain == 1;
    final showSnow = forecast.day.dailyWillItSnow == 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ///
          /// MAIN CONTENT
          ///
          Container(
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
            child: ListView(
              controller: ref.watch(weatherCardControllerProvider(index)),
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ///
                /// MAIN CARD CONTENT
                ///
                SizedBox(
                  height: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).bottom - 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),

                      ///
                      /// DATE & LOCATION
                      ///
                      Column(
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            getForecastDate(
                              dateEpoch: forecast.dateEpoch,
                            ),
                            style: PromajaTextStyles.weatherCardLastUpdated,
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
                      /// TEMPERATURE, WEATHER DESCRIPTION & CHANCE OF RAIN
                      ///
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 104,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///
                                /// MIN TEMP
                                ///
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        showCelsius ? '${forecast.day.minTempC.round()}' : '${forecast.day.minTempF.round()}',
                                        style: PromajaTextStyles.weatherTemperatureMin,
                                        textAlign: TextAlign.center,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: -24,
                                        child: Text(
                                          '°',
                                          style: PromajaTextStyles.weatherTemperatureMin,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 24),

                                ///
                                /// MAX TEMP
                                ///
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        showCelsius ? '${forecast.day.maxTempC.round()}' : '${forecast.day.maxTempF.round()}',
                                        style: PromajaTextStyles.weatherTemperatureMax,
                                        textAlign: TextAlign.center,
                                      ),
                                      const Positioned(
                                        top: 0,
                                        right: -24,
                                        child: Text(
                                          '°',
                                          style: PromajaTextStyles.weatherTemperatureMax,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                ///
                                /// WEATHER DESCRIPTION
                                ///
                                Text(
                                  weatherDescription,
                                  style: PromajaTextStyles.currentWeather,
                                  textAlign: TextAlign.center,
                                ),

                                ///
                                /// CHANCE OF RAIN
                                ///
                                if (showRain && !showSnow)
                                  Positioned(
                                    right: -40,
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
                                          '${forecast.day.dailyChanceOfRain}%',
                                          style: PromajaTextStyles.weatherCardIndividualHourChanceOfRain,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                ///
                                /// CHANCE OF SNOW
                                ///
                                if (showSnow)
                                  Positioned(
                                    right: -40,
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
                                          '${forecast.day.dailyChanceOfSnow}%',
                                          style: PromajaTextStyles.weatherCardIndividualHourChanceOfRain,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      ///
                      /// HOURS
                      ///
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        height: 160,
                        child: PageView.builder(
                          controller: ref.watch(
                            weatherHoursControllerProvider(index),
                          ),
                          itemCount: (forecast.hours.length / 4).round(),
                          onPageChanged: (index) => ref.read(hiveProvider.notifier).logPromajaEvent(
                                text: 'Hours swipe -> ${location.name}, ${location.country}',
                                logGroup: PromajaLogGroup.forecastWeather,
                              ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, pageViewIndex) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              4,
                              (listIndex) {
                                final properIndex = (pageViewIndex * 4) + listIndex;
                                final hourWeather = forecast.hours[properIndex];

                                return WeatherCardHourSuccess(
                                  hourWeather: hourWeather,
                                  isActive: activeHourWeather == hourWeather,
                                  borderColor: backgroundColor,
                                  showCelsius: showCelsius,
                                  onPressed: () => weatherCardHourPressed(
                                    hourWeather: hourWeather,
                                    activeHourWeather: activeHourWeather,
                                    ref: ref,
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///
                /// INDIVIDUAL HOUR
                ///
                WeatherCardIndividualHour(
                  hourWeather: activeHourWeather,
                  key: ValueKey(activeHourWeather),
                  showCelsius: showCelsius,
                  showKph: showKph,
                  showMm: showMm,
                  showhPa: showhPa,
                ),
              ],
            ),
          ),

          ///
          /// CONTAINER VISIBLE WHEN INDIVIDUAL HOUR ACTIVE
          ///
          Positioned(
            top: 0,
            child: AnimatedOpacity(
              opacity: ref.watch(showWeatherTopContainerProvider) ? 1 : 0,
              duration: PromajaDurations.opacityAnimation,
              curve: Curves.easeIn,
              child: Container(
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
                height: MediaQuery.paddingOf(context).top,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
