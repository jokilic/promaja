import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';
import 'weather_card_summary_list_tile.dart';

class WeatherCardSummary extends ConsumerWidget {
  final Location location;
  final ForecastWeather forecastWeather;
  final bool useOpacity;
  final bool useGradientOpacity;
  final bool isPhoneLocation;
  final bool showCelsius;

  const WeatherCardSummary({
    required this.location,
    required this.forecastWeather,
    required this.useOpacity,
    required this.useGradientOpacity,
    required this.isPhoneLocation,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: AnimatedOpacity(
          duration: PromajaDurations.opacityAnimation,
          curve: Curves.easeIn,
          opacity: useOpacity ? 0.45 : 1,
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
            child: AnimatedOpacity(
              duration: PromajaDurations.opacityAnimation,
              curve: Curves.easeIn,
              opacity: useOpacity ? 0 : 1,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).bottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.paddingOf(context).top + 24,
                    ),

                    ///
                    /// TITLE & LOCATION
                    ///
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Summary',
                        style: PromajaTextStyles.settingsSubtitle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            '${location.name}, ${location.country}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: PromajaTextStyles.settingsTitle,
                          ),
                          if (isPhoneLocation)
                            Positioned(
                              right: -44,
                              top: 0,
                              bottom: 0,
                              child: Image.asset(
                                PromajaIcons.location,
                                height: 32,
                                width: 32,
                                color: PromajaColors.white,
                              ),
                            ),
                        ],
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
                    const SizedBox(height: 4),

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
                          showCelsius: showCelsius,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    ///
                    /// TEMPERATURE CHART
                    ///
                    AnimatedOpacity(
                      duration: PromajaDurations.opacityAnimation,
                      curve: Curves.easeIn,
                      opacity: useGradientOpacity ? 0 : 1,
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(),
                            ],
                            lineTouchData: const LineTouchData(),
                          ),
                          duration: PromajaDurations.summaryGraphAnimation,
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
