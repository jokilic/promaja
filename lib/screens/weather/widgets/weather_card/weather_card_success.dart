import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../models/forecast_weather/hour_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../notifiers/weather_notifier.dart';
import '../../../../services/logger_service.dart';
import '../../../../util/color.dart';
import '../../../../util/weather.dart';
import '../weather/weather_success.dart';
import '../weather_card_hour/weather_card_hour_error.dart';
import '../weather_card_hour/weather_card_hour_success.dart';
import '../weather_card_hour/weather_card_individual_hour.dart';

// TODO: Finish this
class WeatherCardSuccess extends ConsumerWidget {
  final Location location;
  final ForecastDayWeather forecast;
  final bool useOpacity;
  final int index;

  const WeatherCardSuccess({
    required this.location,
    required this.forecast,
    required this.useOpacity,
    required this.index,
    super.key,
  });

  void weatherCardHourPressed({
    required WidgetRef ref,
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
    required int index,
  }) {
    /// User pressed already active hour
    /// Disable active hour and scroll up
    if (activeHourWeather == hourWeather) {
      ref.read(activeHourWeatherProvider.notifier).state = null;
      ref.read(weatherCardControllerProvider(index)).animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
    }

    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      ref.read(loggerProvider).f(ref.read(weatherCardControllerProvider(index)).position.maxScrollExtent);

      ref.read(activeHourWeatherProvider.notifier).state = hourWeather;
      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider(index)).animateTo(
              ref.read(weatherCardControllerProvider(index)).position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeHourWeather = ref.watch(activeHourWeatherProvider);

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
            child: ListView(
              controller: ref.watch(weatherCardControllerProvider(index)),
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ///
                /// DATE & LOCATION
                ///
                Column(
                  children: [
                    const SizedBox(height: 64),
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
                const SizedBox(height: 56),

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
                const SizedBox(height: 56),

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
                const SizedBox(height: 40),

                ///
                /// HOURS
                ///
                SizedBox(
                  height: 144,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: forecast.hours.length,
                    controller: ref.watch(
                      weatherDaysControllerProvider(
                        MediaQuery.sizeOf(context).width,
                      ),
                    ),
                    physics: const PageScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemBuilder: (context, hourIndex) {
                      final hourWeather = forecast.hours.elementAtOrNull(hourIndex);

                      /// Return proper [ForecastHourSuccess]
                      if (hourWeather != null) {
                        return WeatherCardHourSuccess(
                          hourWeather: hourWeather,
                          useOpacity: ref.watch(weatherCardMovingProvider),
                          isActive: activeHourWeather == hourWeather,
                          borderColor: backgroundColor,
                          onPressed: () => weatherCardHourPressed(
                            hourWeather: hourWeather,
                            activeHourWeather: activeHourWeather,
                            ref: ref,
                            index: index,
                          ),
                        );
                      }

                      /// This should never happen, but if it does, return [ForecastHourError]
                      return WeatherCardHourError(
                        useOpacity: ref.watch(weatherCardMovingProvider),
                        onPressed: () {},
                      );
                    },
                  ),
                ),

                ///
                /// INDIVIDUAL HOUR
                ///
                WeatherCardIndividualHour(
                  hourWeather: activeHourWeather,
                  useOpacity: ref.watch(weatherCardMovingProvider),
                  key: ValueKey(activeHourWeather),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
