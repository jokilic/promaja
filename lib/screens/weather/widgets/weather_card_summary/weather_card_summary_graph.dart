import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../weather_notifiers.dart';

class WeatherCardSummaryGraph extends ConsumerWidget {
  final ForecastWeather forecastWeather;
  final bool showCelsius;

  const WeatherCardSummaryGraph({
    required this.forecastWeather,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSummaryWeather = ref.watch(activeSummaryWeatherProvider);

    return Center(
      child: SizedBox(
        height: 136,
        width: MediaQuery.sizeOf(context).width - 40,
        child: Row(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      isStrokeCapRound: true,
                      isStrokeJoinRound: true,
                      barWidth: 4,
                      color: PromajaColors.white,
                      dotData: const FlDotData(
                        show: false,
                      ),
                      spots: List.generate(
                        activeSummaryWeather?.hours.length ?? 0,
                        (index) {
                          final hourModel = activeSummaryWeather!.hours[index];
                          final hour = double.tryParse(DateFormat.H().format(hourModel.timeEpoch));

                          return FlSpot(
                            hour ?? index.toDouble(),
                            showCelsius ? hourModel.tempC : hourModel.tempF,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    getTouchLineStart: (_, __) => 0,
                    getTouchLineEnd: (_, __) => 0,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 100,
                      tooltipBgColor: PromajaColors.indigo,
                      getTooltipItems: (touchedSpots) => touchedSpots.map(
                        (touchedSpot) {
                          final temperature = '${touchedSpot.y.round()}°${showCelsius ? 'C' : 'F'}';
                          final hour = '${touchedSpot.x.round()}';

                          return LineTooltipItem(
                            'weatherSummaryGraphTooltip'.tr(
                              args: [temperature, hour],
                            ),
                            PromajaTextStyles.summaryGraphTooltip,
                          );
                        },
                      ).toList(),
                      tooltipBorder: const BorderSide(
                        color: PromajaColors.white,
                        width: 2,
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 48,
                        getTitlesWidget: (value, _) => Text(
                          '${value.round()}',
                          style: PromajaTextStyles.summaryGraphTitles,
                        ),
                        showTitles: true,
                        interval: 100,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, _) => Text(
                          '${value.round()}',
                          style: PromajaTextStyles.summaryGraphTitles,
                        ),
                        showTitles: true,
                        interval: 8,
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  gridData: const FlGridData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
                duration: PromajaDurations.summaryGraphAnimation,
                curve: Curves.easeIn,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
