import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';
import '../../weather_notifiers.dart';
import 'weather_card_summary_graph.dart';
import 'weather_card_summary_list_tile.dart';

class WeatherCardSummary extends ConsumerWidget {
  final Location location;
  final ForecastWeather forecastWeather;
  final bool isPhoneLocation;
  final bool showCelsius;

  const WeatherCardSummary({
    required this.location,
    required this.forecastWeather,
    required this.isPhoneLocation,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lightenColor(PromajaColors.indigo),
                darkenColor(PromajaColors.indigo),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).bottom,
            child: ListView(
              controller: ref.watch(weatherSummaryProvider),
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: AnimateList(
                delay: PromajaDurations.weatherDataAnimationDelay,
                interval: PromajaDurations.weatherDataAnimationDelay,
                effects: [
                  if (ref.watch(weatherCardSummaryShowAnimationProvider))
                    FadeEffect(
                      curve: Curves.easeIn,
                      duration: PromajaDurations.fadeAnimation,
                    ),
                ],
                children: [
                  SizedBox(
                    height: MediaQuery.paddingOf(context).top + 40,
                  ),

                  ///
                  /// TITLE & LOCATION
                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'weatherSummary'.tr(),
                      style: PromajaTextStyles.settingsSubtitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${location.name}, ${location.country}',
                          ),
                          if (!isPhoneLocation) ...[
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(width: 8),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                PromajaIcons.location,
                                height: 32,
                                width: 32,
                                color: PromajaColors.white,
                              ),
                            ),
                          ]
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: PromajaTextStyles.settingsTitle,
                    ),
                  ),

                  ///
                  /// DIVIDER
                  ///
                  const SizedBox(height: 16),
                  const Divider(
                    indent: 120,
                    endIndent: 120,
                    color: PromajaColors.white,
                  ),

                  ///
                  /// SUMMARY FORECASTS
                  ///
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: forecastWeather.forecastDays.length,
                    itemBuilder: (_, index) {
                      final forecast = forecastWeather.forecastDays[index];

                      return WeatherCardSummaryListTile(
                        forecast: forecast,
                        onPressed: () async {
                          ref.read(activeSummaryWeatherProvider.notifier).state = forecast;

                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => ref.read(weatherSummaryProvider).animateTo(
                                  ref.read(weatherSummaryProvider).positions.last.maxScrollExtent,
                                  duration: PromajaDurations.scrollAnimation,
                                  curve: Curves.fastOutSlowIn,
                                ),
                          );
                        },
                        isSelected: ref.watch(activeSummaryWeatherProvider) == forecast,
                        showCelsius: showCelsius,
                      );
                    },
                  ),

                  ///
                  /// DIVIDER
                  ///
                  const SizedBox(height: 4),
                  const Divider(
                    indent: 120,
                    endIndent: 120,
                    color: PromajaColors.white,
                  ),
                  const SizedBox(height: 28),

                  ///
                  /// TEMPERATURE CHART
                  ///
                  WeatherCardSummaryGraph(
                    forecastWeather: forecastWeather,
                    showCelsius: showCelsius,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
}
