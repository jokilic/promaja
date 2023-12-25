import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
import '../../../cards/cards_notifiers.dart';
import '../../weather_notifiers.dart';
import '../weather_card_hour/weather_card_hour_error.dart';
import '../weather_card_hour/weather_card_hour_success.dart';
import '../weather_card_hour/weather_card_individual_hour.dart';

class WeatherCardSuccess extends ConsumerStatefulWidget {
  final Location location;
  final ForecastDayWeather forecast;
  final bool useOpacity;
  final int index;
  final bool isPhoneLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const WeatherCardSuccess({
    required this.location,
    required this.forecast,
    required this.useOpacity,
    required this.index,
    required this.isPhoneLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherCardSuccessState();
}

class _WeatherCardSuccessState extends ConsumerState<WeatherCardSuccess> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(activeHourWeatherProvider.notifier).state = widget.forecast.hours.firstWhere(
        (hour) => hour.timeEpoch.hour == DateTime.now().hour,
      ),
    );
  }

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
            duration: PromajaDurations.scrollAnimation,
            curve: Curves.easeIn,
          );

      ref.read(hiveProvider.notifier).logPromajaEvent(
            text: 'ForecastWeather -> weatherCardHourPressed -> ${widget.location.name}, ${widget.location.country} -> Hour disabled',
            logLevel: PromajaLogLevel.forecastWeather,
          );
    }

    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      ref.read(activeHourWeatherProvider.notifier).state = hourWeather;
      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider(index)).animateTo(
              ref.read(weatherCardControllerProvider(index)).position.maxScrollExtent,
              duration: PromajaDurations.scrollAnimation,
              curve: Curves.easeIn,
            ),
      );

      ref.read(hiveProvider.notifier).logPromajaEvent(
            text:
                'ForecastWeather -> weatherCardHourPressed -> ${widget.location.name}, ${widget.location.country} -> Hour enabled -> ${DateFormat.Hm().format(hourWeather.timeEpoch)}',
            logLevel: PromajaLogLevel.forecastWeather,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeHourWeather = ref.watch(activeHourWeatherProvider);

    final weatherCode = widget.forecast.day.condition.code;

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
      code: widget.forecast.day.condition.code,
      isDay: true,
    );

    final weatherDescription = getWeatherDescription(
      code: widget.forecast.day.condition.code,
      isDay: true,
    );

    final showRain = widget.forecast.day.dailyWillItRain == 1;
    final showSnow = widget.forecast.day.dailyWillItSnow == 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: AnimatedOpacity(
        duration: PromajaDurations.opacityAnimation,
        curve: Curves.easeIn,
        opacity: widget.useOpacity ? 0.45 : 1,
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
            opacity: widget.useOpacity ? 0 : 1,
            child: ListView(
              controller: ref.watch(weatherCardControllerProvider(widget.index)),
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ///
                /// MAIN CARD CONTENT
                ///
                SizedBox(
                  height: MediaQuery.sizeOf(context).height - 136,
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
                        /// DATE & LOCATION
                        ///
                        Column(
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              getForecastDate(dateEpoch: widget.forecast.dateEpoch),
                              style: PromajaTextStyles.weatherCardLastUpdated,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  widget.location.name,
                                  style: PromajaTextStyles.currentLocation,
                                  textAlign: TextAlign.center,
                                ),
                                if (widget.isPhoneLocation)
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
                          child: Animate(
                            delay: PromajaDurations.weatherIconAnimationDelay,
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
                                          widget.showCelsius ? '${widget.forecast.day.minTempC.round()}' : '${widget.forecast.day.minTempF.round()}',
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
                                          widget.showCelsius ? '${widget.forecast.day.maxTempC.round()}' : '${widget.forecast.day.maxTempF.round()}',
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
                                      right: -36,
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
                                            '${widget.forecast.day.dailyChanceOfRain}%',
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
                                      right: -36,
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
                                            '${widget.forecast.day.dailyChanceOfSnow}%',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 160,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 24, bottom: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.forecast.hours.length,
                            controller: ref.watch(
                              weatherDaysControllerProvider(MediaQuery.sizeOf(context).width),
                            ),
                            physics: const PageScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            itemBuilder: (context, hourIndex) {
                              final hourWeather = widget.forecast.hours.elementAtOrNull(hourIndex);

                              /// Return proper [ForecastHourSuccess]
                              if (hourWeather != null) {
                                return WeatherCardHourSuccess(
                                  hourWeather: hourWeather,
                                  useOpacity: ref.watch(weatherCardMovingProvider),
                                  isActive: activeHourWeather == hourWeather,
                                  borderColor: backgroundColor,
                                  showCelsius: widget.showCelsius,
                                  onPressed: () => weatherCardHourPressed(
                                    hourWeather: hourWeather,
                                    activeHourWeather: activeHourWeather,
                                    ref: ref,
                                    index: widget.index,
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
                      ],
                    ),
                  ),
                ),

                ///
                /// INDIVIDUAL HOUR
                ///
                WeatherCardIndividualHour(
                  hourWeather: activeHourWeather,
                  useOpacity: ref.watch(weatherCardMovingProvider),
                  key: ValueKey(activeHourWeather),
                  showCelsius: widget.showCelsius,
                  showKph: widget.showKph,
                  showMm: widget.showMm,
                  showhPa: widget.showhPa,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
